require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'
require 'json'
require './certificate_helper.rb'
require './certificate.rb'
require './../data/env.rb'

module Api

  class Server < Sinatra::Base

    post '/api/v1/certificate/request/:hostname' do
      key = request.body.string
      Api::Certificate_Helper.generate_csr(params['hostname'], key)
      if ENV['autosign'] == '1'
        cn = params['hostname']
        key = Api::Certificate_Helper.load_key(ENV['certreq_path'], cn)
        formatted_name = "CN=" + cn.gsub(".", "/DC=")
        certificate = Api::Certificate.generate_certificate(key, formatted_name, 2)
        Api::Certificate_Helper.write_certificate(cn, certificate)
        Api::Certificate_Helper.remove_csr(cn)


        content_type 'text/plain'
        cert = Api::Certificate_Helper.get_certificate(cn)
        if cert.is_a? OpenSSL::X509::Certificate
          status = 200
          body cert.to_s
        else
          status = 404
        end
      else
        status = 200
        body "Autosign is disabled... check back and see if signed."
      end
    end

    get '/api/v1/certificate/request/:hostname' do
      #request.body.rewind
      cn = params['hostname']
      content_type 'text/plain'
      cert = Api::Certificate_Helper.get_certificate(cn)
      if cert.is_a? OpenSSL::X509::Certificate
        status = 200
        body cert.to_s
      else
        status = 404
      end
    end
  end

  ENV['data_dir'] = "C:/Users/ewander/Documents/projects/certificate_authority/data"
  ENV['key_path'] = "C:/Users/ewander/Documents/projects/certificate_authority/private"
  ENV['cert_path'] = "C:/Users/ewander/Documents/projects/certificate_authority/certs"
  ENV['certreq_path'] = "C:/Users/ewander/Documents/projects/certificate_authority/certreqs"
  ENV['RACK_ENV'] = "production"

  CERT_PATH = ENV['cert_path']
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