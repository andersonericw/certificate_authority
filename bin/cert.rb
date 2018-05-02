#!/usr/bin/ruby
require '../lib/certificate'
require '../lib/certificate_helper'

if ARGV.size < 1
  puts 'The name of the certificate to sign is required'
  exit 1
end

require '../data/env.rb'

if File.exist? File.join(ENV['certreq_path'], ARGV[0])
  key = Api::Certificate_Helper.load_key(ENV['certreq_path'], ARGV[0])
  formatted_name = "CN=" + ARGV[0].gsub(".", "/DC=")
  certificate = Api::Certificate.generate_certificate(key, formatted_name, 2)
  Api::Certificate_Helper.write_certificate(ARGV[0], certificate)
  Api::Certificate_Helper.remove_csr(ARGV[0])
else
  puts "Could not find CSR for #{ARGV[0]}"
  exit 1
end
