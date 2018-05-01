module Api
  class Certificate_Helper

    def self.get_all_certificates directory = nil
      certificate_directory = directory != nil ? directory : ENV['cert_path']
      all_certificates_files = Dir[File.join(certificate_directory, '*')]
      all_certificates = Array.new
      all_certificates_files.each do |file|
        raw_file = File.read file
        all_certificates.push(OpenSSL::X509::Certificate.new raw_file)
      end
      all_certificates
    end

    def self.get_all_serial directory = nil
      all_certificates = self.get_all_certificates directory
      all_serials = Array.new
      all_certificates.each do |cert|
        all_serials.push cert.serial
      end
      all_serials
    end

    def self.write_certificate(path = "#{ENV['cert_path']}/", name, certificate)
      File.open(File.join(path, name), "wb") { |f| f.print certificate.to_pem }
    end

    def self.load_certificate(path = "#{ENV['cert_path']}/", name)
      raw = File.read File.join(path, name)
      certificate = OpenSSL::X509::Certificate.new raw
      certificate
    end

    def self.load_key(path = "#{ENV['private_dir']}/", name)
      OpenSSL::PKey::RSA.new File.read File.join(path, name)
    end

    def self.write_key(path = "#{ENV['private_dir']}/", name, key)
      File.open(File.join(path, name), "wb") { |f| f.print key.to_pem }
    end

  end
end