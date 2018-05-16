# Certificate Authority

This is an API based Certificate Authority that can be used for creating, signing, rejecting, and managing certificates

## Getting Started
```
git clone https://github.com/andersonericw/certificate_authority.git
cd certificate_authority/bin
ruby setup.rb /path/to/certificate/root/directory
cd /path/to/certificate/root/directory
ruby certificate_http.rb
```

### Prerequisites
```
ruby 2.3.0
RedHat 7
SLES 12
Oracle Linux 7

gems 
openssl 2.1.0
sinatra 2.0.1
json 1.8.3
```

### Installing

See Getting Started

## Authors

Eric Anderson

## License

This project is licensed under the MIT License - see the certificate_authority/LICENSE file for details

## Acknowledgments

* Ruby Openssl documentation
* Circle Engineering (https://engineering.circle.com/https-authorized-certs-with-node-js-315e548354a2) 

Gist article about SSL & Trust
https://gist.github.com/andersonericw/69d4a934e02dc0a197db0f071bbfa750
