require "C:/Users/Jacksonecac/RubymineProjects/certificate_athority/lib/certificate.rb"

# Environment Variables
ENV['data_dir'] = "C:/Users/Jacksonecac/RubymineProjects/certificate_athority/data"

def cert

  Api::Certificate.generate_ca("/DC=org/DC=ruby-lang/CN=localhost", 2)
  ca = Api::Certificate.load_certificate('ca-crt.pem')

  cert_key = OpenSSL::PKey::RSA.new 2048
  Api::Certificate.write_certificate('server-key.pem', cert_key)

  certificate = Api::Certificate.generate_certificate(cert_key,"/DC=org/DC=ruby-lang/CN=localhost", 2)
  Api::Certificate.write_certificate('server-crt.pem', certificate)
end

def post
  require 'uri'
  require 'net/http'

  url = URI("https://localhost:8443/")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.ca_file = File.join(ENV['data_dir'], 'ca-crt.pem')
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  request = Net::HTTP::Post.new(url)
  request["content-type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
  request["cache-control"] = 'no-cache'
  request["postman-token"] = 'bda22821-bc77-befc-2885-ac61151e5a67'
  request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"file\"; filename=\"C:\\Users\\Jacksonecac\\Desktop\\thing.txt\"\r\nContent-Type: text/plain\r\n\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
  file='file'
  file_path='C:\\Users\\Jacksonecac\\Desktop\\thing.txt'

  start_boundary="------WebKitFormBoundary7MA4YWxkTrZu0gW\r\n"
  disposition="Content-Disposition: form-data;"
  name="name=\"#{file}\";"
  filename="filename=\"#{file_path}\"\r\n"
  content_type="Content-Type: text/plain\r\n\r\n\r\n-"
  end_boundary="-----WebKitFormBoundary7MA4YWxkTrZu0gW--"

  request.body="#{start_boundary}#{disposition}#{name}#{filename}#{content_type}#{end_boundary}"

  response = http.request(request)
  puts response.read_body

  request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"file\"; filename=\"C:\\Users\\Jacksonecac\\Desktop\\thing.txt\"\r\nContent-Type: text/plain\r\n\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
  response = http.request(request)
  puts response.read_body
end

cert
#post

