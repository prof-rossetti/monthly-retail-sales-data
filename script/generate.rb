require "pry"
require "highline"
require "csv"
require "active_support/core_ext/date"
require "active_support/core_ext/time"

if ENV.fetch("SCRIPT_ENV") == "test"
  response = "201803"
else
  cli = HighLine.new
  response = cli.ask("Please enter a year and month (e.g. 201803)")
end

month_beg = Date.strptime(response, "%Y%m")
puts "BEGIN #{month_beg.to_s}"
month_end = month_beg.end_of_month
puts "END #{month_end.to_s}"


#binding.pry

#CSV.open(csv_filepath, "w", :write_headers=> true, :headers => headers) do |csv|
#  rankings.each do |ranking|
#    csv << [1,2,3,4,5]
#  end
#end
