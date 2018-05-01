require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'

module Api

  class Server < Sinatra::Base

    post '/' do
      #request.body.rewind
      #contents = request.params
      #puts contents.inspect
      #puts contents['file'][:tempfile].read

      request.body.rewind
      content = request.body

      puts content.inspect
    end

  end
  ENV['data_dir'] = "C:/Users/Jacksonecac/RubymineProjects/certificate_athority/data"
  ENV['RACK_ENV'] = "production"
  CERT_PATH = ENV['data_dir']
  webrick_options = {
      :Port               => 8443,
      :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
      :DocumentRoot       => "/ruby/htdocs",
      :SSLEnable          => true,
      :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
      :SSLClientCA        => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "ca-crt.pem")).read),
      :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "server-crt.pem")).read),
      :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "server-key.pem")).read),
      :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
  }

  Rack::Handler::WEBrick.run Server, webrick_options
end