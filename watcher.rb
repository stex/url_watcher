#!/usr/bin/env ruby
# frozen_string_literal: true

require 'net/http'
require 'fileutils'

URL = URI(ENV.fetch('PAGE_URL'))
WEBHOOK_URL = URI(ENV.fetch('WEBHOOK_URL'))
CHECK_INTERVAL = ENV.fetch('CHECK_INTERVAL', 60).to_i

OLD_FILE = File.expand_path('old.html', __dir__)
CURRENT_FILE = File.expand_path('current.html', __dir__)

check_string = "Checking #{URL} every #{CHECK_INTERVAL} seconds..."

puts <<~GREETING
  **#{'*' * check_string.length}**
  * #{check_string} *
  **#{'*' * check_string.length}**
GREETING

def log(msg)
  puts "[#{Time.now}] #{msg}"
end

loop do
  content = Net::HTTP.get(URL)

  File.write(CURRENT_FILE, content)

  if File.exist?(OLD_FILE)
    diff_output = `diff #{OLD_FILE} #{CURRENT_FILE}`

    unless diff_output.length.zero?
      log 'Content changed, triggering webhook'
      Net::HTTP.post(WEBHOOK_URL, '')
    end

    FileUtils.rm(OLD_FILE)
  end

  FileUtils.mv(CURRENT_FILE, OLD_FILE)

  sleep CHECK_INTERVAL
end
