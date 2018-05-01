require "C:/Users/ewander/Documents/projects/certificate_authority/lib/certificate.rb"
require "C:/Users/ewander/Documents/projects/certificate_authority/lib/certificate_helper.rb"

# Environment Variables
ENV['data_dir'] = "C:/Users/ewander/Documents/projects/certificate_authority/data"
ENV['cert_path'] = "C:/Users/ewander/Documents/projects/certificate_authority/certs"
ENV['private_dir'] = "C:/Users/ewander/Documents/projects/certificate_authority/private"
def cert

  Api::Certificate.generate_ca("/DC=org/DC=ruby-lang/CN=localhost", 2)
  ca = Api::Certificate_Helper.load_certificate('ca-crt.pem')

  cert_key = OpenSSL::PKey::RSA.new 2048
  Api::Certificate_Helper.write_key('server-key.pem', cert_key)

  certificate = Api::Certificate.generate_certificate(cert_key,"/DC=org/DC=ruby-lang/CN=localhost", 2)
  Api::Certificate_Helper.write_certificate('server-crt.pem', certificate)
end

def run_cert_hlpr

  Api::Certificate_Helper.get_all_certificates
  Api::Certificate_Helper.get_all_serial
end

cert
run_cert_hlpr

