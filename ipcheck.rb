require 'resolv'

class Ipcheck
  
  def initialize()
  end
  
  def self.check()
    puts "Fetching IPs..."
    urls = Hash.new() #hash to store the url-ip pairs
    File.foreach("input.txt") do |url| #go through the input file and get each line
      unless url.to_s.empty? #ignore blank lines
        domain = url.sub(/\Ahttps?:\/\//,"") #strip the scheme and any trailing bits
        domain = domain.sub(/(?=\/).+/,"")
        begin
        ip = Resolv.new.getaddress(url.chomp()) #try to get the ip
        rescue Resolv::ResolvError #don't break on error
          ip = "Error, unable to resolve hostname."
        end
        urls[domain] = ip #set the domain and ip pair
      end
    end
    puts "Sorting Results..."
    sorted_ip = urls.sort_by{ |domain, ip|
  ip[1].split('.').map{ |digits| digits.to_i }} #this breaks the ip up into individual numbers because it's easier to ensure a good sort this way.
  sorted_ip.each { |domain, ip|
  File.open("output.txt", 'a') do |result| #put the sorted domain-ip pairs into the output file
      result.puts "#{domain} #{ip}"
      end
    }
    puts "Finished, press enter to exit" #just because I like closure
    wait = gets
  end

end

Ipcheck.check