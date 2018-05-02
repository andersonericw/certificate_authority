require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'
require 'json'

module Api

  class Server < Sinatra::Base

    post '/' do
      #content_type 'application/json'
      #request.body.rewind
      #contents = request.params
      #puts contents.inspect
      #puts contents['file'][:tempfile].read
      File.exist? 'C:/Users/ewander/Documents/projects/certificate_authority/cert/ca-crt.pem'
      file_content = File.read("#{Dir.pwd}/../data/ca-crt.pem")
      request.body.rewind
      json = {
          "key:" => "val"
      }
      status 200
      #body file.to_s
      body file_content
    end

  end
  ENV['data_dir'] = "C:/Users/ewander/Documents/projects/certificate_authority/data"
  ENV['key_path'] = "C:/Users/ewander/Documents/projects/certificate_authority/private"
  ENV['RACK_ENV'] = "production"
  CERT_PATH = ENV['data_dir']
  KEY_PATH = ENV['key_path']
  webrick_options = {
      :Port               => 8443,
      :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
      :DocumentRoot       => "/ruby/htdocs",
      :SSLEnable          => true,
      :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
      :SSLClientCA        => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "ca-crt.pem")).read),
      :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "server-crt.pem")).read),
      :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(KEY_PATH, "server-key.pem")).read),
      :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
  }

  Rack::Handler::WEBrick.run Server, webrick_options
end