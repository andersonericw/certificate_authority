# Environment Variables
require File.join(Dir.pwd, 'data/env.rb')
require File.join(ENV['lib_path'],'certificate_helper.rb')
require File.join(ENV['lib_path'],'certificate.rb')
def cert

  Api::Certificate.generate_ca("/DC=org/DC=ruby-lang/CN=localhost", 2)
  ca = Api::Certificate_Helper.load_certificate('ca-crt.pem')

  cert_key = OpenSSL::PKey::RSA.new 2048
  Api::Certificate_Helper.write_key('server-key.pem', cert_key)

  certificate = Api::Certificate.generate_certificate(cert_key,"/DC=org/DC=ruby-lang/CN=localhost", 2)
  Api::Certificate_Helper.write_certificate('server-crt.pem', certificate)

  Api::Certificate_Helper.get_all_certificates
  Api::Certificate_Helper.get_all_serial

  certificate = Api::Certificate_Helper.load_certificate('server-crt.pem')
  ca = Api::Certificate_Helper.load_certificate('ca-crt.pem')
  puts Api::Certificate.verify(ca, certificate)
end

def post
  require 'uri'
  require 'net/https'

  url = URI("https://localhost:8443")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  file = File.new 'C:/Users/ewander/Documents/projects/certificate_authority/data/ca-crt.pem'
  http.cert = OpenSSL::X509::Certificate.new file
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new(url)
  request["Content-Type"] = 'application/json'
  request["Cache-Control"] = 'no-cache'
  request["Postman-Token"] = '2799b65b-b15f-4ff4-814c-1921a050e0b2'

  response = http.request(request)
  puts response.body
end

cert
#post
