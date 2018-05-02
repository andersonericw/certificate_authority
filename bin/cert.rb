#!/usr/bin/ruby
require File.join(Dir.pwd, 'data/env.rb')
require File.join(ENV['lib_path'],'certificate_helper.rb')
require File.join(ENV['lib_path'],'certificate.rb')

if ARGV.size < 1
  puts 'The name of the certificate to sign is required'
  exit 1
end

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
