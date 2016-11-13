require 'rest-client'
require 'json'

if (ARGV.size != 1)
  puts 'Usage: random_user [number of users to generate]'
  exit(1)
end


users = ARGV[0].to_i
safeurl = URI.encode(('https://randomuser.me/api/?results=' + users.to_s).strip)

puts 'Getting random user data...'
response = RestClient.get(safeurl)
puts 'Random users generated successfully'
json = JSON.parse(response)

json['results'].each do |user|
  puts ''
  puts '==================================================='
  puts 'First Name: ' + user['name']['first']
  puts 'Last Name: ' + user['name']['last']
  puts 'Email: ' + user['email']
  puts 'Street: ' + user['location']['street']
  puts 'City: ' + user['location']['city']
  puts 'State: ' + user['location']['state']
  puts 'Country: ' + user['nat']
  puts 'PostCode: ' + user['location']['postcode'].to_s
end
