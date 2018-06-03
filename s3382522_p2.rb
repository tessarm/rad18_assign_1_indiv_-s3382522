require 'nokogiri'
require 'json'
require 'optparse'

def start #method that gets called at the start
    if ARGV[0] == nil # if there's no argument passed when the script is loaded, it will print the stuff below
        puts "Commands:"
        puts "s33382522_p2.rb	-xml	[filename] # Load a XML file"
        puts "s33825226_p2.rb	help	[COMMAND]  # Describe available commands or one specific command"
    else #options parser, puts the arguments into a variable so the correct method can be run
        $options = {:xmlFile => nil, :ipAddress => nil, :name => nil} #possible variables for the commands
        OptionParser.new do |opts|
            #if the -n or --name options are put in, the argument will be stored in the hash as a name
            opts.on('-n', '--name name', 'Displays records with the specified name') do |name|
                $options[:name] = name
            end
            
            #if the -i or --ip options are put in, the argument will be stored in the hash as a ip
            opts.on('-i', '--ip ipAddress', 'Displays records with the specified IP Address') do |ipAddress|
                $options[:ipAddress] = ipAddress
            end  

            #if the -x or --xml options are put in, the argument will be stored in the hash as xmlFile
            opts.on('-x', '--xml xmlFile', 'Loads the XML specified') do |xmlFile|
                $options[:xmlFile] = xmlFile  
            end
            
            #if -h or --help is used, it will display the options and their description then exit
            opts.on('-h', '--help', 'Display the help page') do
                puts "Help text goes here"
                exit
            end
            opts.parse!
        end
    end
end

def searchIP(ipAddress)
    $records.each do |record|
        if ipAddress == record[:ip_address]
            puts record.to_json
        end
    end
end

def searchNames(name)
    $records.each do |record|
        if name == record[:first_name] || name == record[:last_name]
            puts record.to_json
        end
    end

        
end

def extract(emails)
    $records = [] # Initialise variable to allow <<  to work
    emails.xpath("//record").each do |record| #iterate through the xml file
        $records << { "id" => record.xpath('id').text,     #append each node and it's values to the records hash
        :first_name => record.xpath('first_name').text, #add first name value, repeating for each otehr value below
        :last_name => record.xpath('last_name').text, 
        :email => record.xpath('email').text, 
        :gender => record.xpath('gender').text, 
        :ip_address => record.xpath('ip_address').text,
        :send_date => record.xpath('send_date').text,
        :email_body => record.xpath('email_body').text,
        :email_title => record.xpath('email_title').text }
    end
end
  
#start of scrip, run the start method to display options and get options
start 

d = Date.parse('3rd Feb 2001')
puts d.wday

    
if $options[:xmlFile] != nil #if/else to check what method to run, based on the options hash above
    emails = Nokogiri::XML(File.open("#{$options[:xmlFile]}"))
    extract(emails)


    # We need to know what xml file to run, so that's why this is nested in the :xmlFile check
    if $options[:name] != nil
        searchNames($options[:name])
    elsif $options[:ipAddress] != nil
        searchIP($options[:ipAddress])
    end
end

