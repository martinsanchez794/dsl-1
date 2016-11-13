require 'rest-client'
require 'json'
require 'csv'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::WARN

inputFile = ARGV[0]
if ( inputFile.nil? || !File.file?(inputFile) )
  logger.error ('A valid input file with a list of IP adresses must be specified.')
  logger.error ('Usage: bulkipinfo [csv file]')
  exit(1)
end

rows = []
File.open(inputFile, "r") do |f|
  f.each_line do |line|
    if ( (line.length > 1) && (!line.nil?) )
      puts ('Querying IP ' + line)
      safeurl = URI.encode(('http://ip-api.com/json/' + line.to_str).strip)
      response = RestClient.get(safeurl)
      if (response.code == 200)
        json = JSON.parse(response.to_str)
        if (json['status'] == 'fail')
          logger.warn('Invalid IP Address')
        else
          rows << json
        end
      end
      sleep(1.0) #This is to avoid the limit in the ip-api service
    end
  end
end

outputFile = 'output/ipinfo_results_' + Time.now.getutc.to_i.to_s + '.csv'
CSV.open(outputFile, "w") do |csv|
  csv << rows[0].keys
  rows.each do |row|
    csv << row.values
  end
end
puts 'Done. Your results are here: ' + outputFile
