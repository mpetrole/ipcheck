require 'resolv'
require 'net/http'
require 'uri'

class Ipcheck
  
  def initialize()
  end
  
def self.url_exist?(url_string)
  begin
    url = URI.parse(URI.encode(url_string))
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = (url.scheme == 'https')
    req.verify_mode = OpenSSL::SSL::VERIFY_NONE #I know this is normally bad, but we just want to connect, we don't care about the security of the connection. Please don't hate me!
    path = url.path if ! url.path.empty? #use a path if available
    res = req.request_head(path || '/')
    res.code != "404" # false if returns 404 - not found
  rescue Errno::ENOENT
    false # false if can't find the server
  rescue OpenSSL::SSL::SSLError
    false #ssl can't connect
  end
end
  
  def self.check()
    puts "Fetching IPs..."
    urls = Hash.new() #hash to store the url-ip pairs
    ipPhish = Hash.new() #will use this later to store the potential IP phish
    File.foreach("input.txt") do |url| #go through the input file and get each line, then do some changes to make the URL readable
      url.gsub!(/\s.+/, '')
      url.chomp!
      unless url.to_s.empty? #ignore blank lines
        domainNoScheme = url.sub(/\Ahttps?:\/\//,"") #strip the scheme and any trailing bits
        domain = domainNoScheme.sub(/(?=\/).+/,"")
        unless urls.has_key? "#{domain}" #ignore duplicate domains
         begin
          ip = Resolv.new.getaddress(domain) #try to get the ip
          rescue Resolv::ResolvError #unable to get ip
            ip = "Error, unable to resolve hostname."
          end
          urls[domain] = ip #set the domain and ip pair
          #check to see if the urls will work with the ip subbed for the url
          if ip != "Error, unable to resolve hostname." #ignore ones that are offline or otherwise invalid
            new_url = url.sub("#{domain}","#{ip}")
            ip_phish = url_exist?("#{new_url}")
            ipPhish[url] = ip_phish
          else 
            ipPhish[url] = "Error, unable to resolve hostname."
          end
        end
      end
    end
    puts "Sorting Results..."
  ipPhish.each { |uri, ipphish| #sorted_ip
  File.open("output.txt", 'a') do |result| #put the sorted url-possible ip phish pairs into the output file
      result.puts "#{uri} Potential IP phish? #{ipphish}"
      end
    }
end

File.open('output.txt', 'w') {}
Ipcheck.check
puts "Finished, press enter to exit" #just because I like closure
    wait = gets
    end