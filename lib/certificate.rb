require 'openssl'
require File.join(ENV['lib_path'], 'certificate_helper.rb')
module Api
  class Certificate
    def self.generate_ca(cypher = 2048, ca_key = 'ca-key.pem', ca_cert = 'ca-crt.pem', name, valid_years)
      root_key = OpenSSL::PKey::RSA.new cypher # the CA's public/private key
      root_ca = OpenSSL::X509::Certificate.new
      root_ca.version = 2 # cf. RFC 5280 - to make it a "v3" certificate
      root_ca.serial = self.generate_serial
      # /DC=org/DC=ruby-lang/CN=Ruby CA
      root_ca.subject = OpenSSL::X509::Name.parse name
      root_ca.issuer = root_ca.subject # root CA's are "self-signed"
      root_ca.public_key = root_key.public_key
      root_ca.not_before = Time.now
      root_ca.not_after = root_ca.not_before + valid_years * 365 * 24 * 60 * 60 # 2 years validity
      Api::Certificate_Helper.write_key('ca-key.pem', root_key)
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = root_ca
      ef.issuer_certificate = root_ca
      root_ca.add_extension(ef.create_extension("basicConstraints","CA:TRUE",true))
      root_ca.add_extension(ef.create_extension("keyUsage","keyCertSign, cRLSign", true))
      root_ca.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      root_ca.add_extension(ef.create_extension("authorityKeyIdentifier","keyid:always",false))
      root_ca.sign(root_key, OpenSSL::Digest::SHA256.new)
      Api::Certificate_Helper.write_certificate('ca-crt.pem', root_ca)
    end

    def self.generate_certificate(key, name, ca_key = 'ca-key.pem', ca_cert = 'ca-crt.pem', valid_years)
      cert = OpenSSL::X509::Certificate.new
      cert.version = 2
      cert.serial = generate_serial
      cert.subject = OpenSSL::X509::Name.parse name
      root_ca = Api::Certificate_Helper.load_certificate(ca_cert)
      root_key = Api::Certificate_Helper.load_key(ca_key)
      cert.issuer = root_ca.subject # root CA is the issuer
      cert.public_key = key.public_key
      cert.not_before = Time.now
      cert.not_after = cert.not_before + 1 * 365 * 24 * 60 * 60 # 1 years validity
      ef = OpenSSL::X509::ExtensionFactory.new
      ef.subject_certificate = cert
      ef.issuer_certificate = root_ca
      cert.add_extension(ef.create_extension("keyUsage","digitalSignature", true))
      cert.add_extension(ef.create_extension("subjectKeyIdentifier","hash",false))
      cert.sign(root_key, OpenSSL::Digest::SHA256.new)
      cert
    end

    def self.generate_serial
      randgen = Random.new
      lower_bound = 11
      upper_bound = 2**160
      new_serial = randgen.rand(lower_bound..upper_bound)
      all_serials = Api::Certificate_Helper.get_all_serial
      while all_serials.include? new_serial
        new_serial = randgen.rand(lower_bound..upper_bound)
      end
      new_serial
    end

    def self.verify(ca, certificate)
      return ca.issuer == certificate.issuer
    end

  end
end
