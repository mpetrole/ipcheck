require 'resolv'

class Ipcheck
  
  def initialize()
  end
  
  def self.check()
    urls = Hash.new()
    File.foreach("input.txt") do |url|
      url = url.sub(/\Ahttps?:\/\//,"")
      begin
      ip = Resolv.new.getaddress(url.chomp())
      rescue Resolv::ResolvError
        ip = "Error, unable to resolve hostname."
      end
      urls[url] = ip
    end
    sorted_ip = urls.sort_by{ |url, ip|
  ip[1].split('.').map{ |digits| digits.to_i }}
  sorted_ip.each { |url, ip|
  File.open("output.txt", 'a') do |result|
      result.puts "#{url} #{ip}"
      end
    }
  end
end

Ipcheck.check