#!/usr/bin/env ruby

require "net/http"
require "fileutils"

URL = URI(ENV.fetch("PAGE_URL"))
WEBHOOK_URL = URI(ENV.fetch("WEBHOOK_URL"))
CHECK_INTERVAL = ENV.fetch("CHECK_INTERVAL", 60).to_i

OLD_FILE = File.expand_path("old.html", __dir__)
CURRENT_FILE = File.expand_path("current.html", __dir__)

loop do
  content = Net::HTTP.get(URL)

  File.write(CURRENT_FILE, content)

  if File.exist?(OLD_FILE)
    diff_output = `diff #{OLD_FILE} #{CURRENT_FILE}`

    if diff_output.length.zero?
      puts "Not Changed"
    else
      puts "Content changed, triggering webhook."
      Net::HTTP.post(WEBHOOK_URL, "")
    end

    FileUtils.rm(OLD_FILE)
  end

  FileUtils.mv(CURRENT_FILE, OLD_FILE)

  sleep CHECK_INTERVAL
end
