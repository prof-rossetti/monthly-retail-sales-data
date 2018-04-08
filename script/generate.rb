require "pry"
require "highline"
require "csv"
require "active_support/core_ext/date"
require "active_support/core_ext/time"

PRODUCTS = [
  {
    name: "Super Soft Sweater",
    price: 149.99,
    months_in_season:[1, 2, 9, 10, 11, 12],
    avg_sold_per_month: 10,
    avg_sold_per_month_in_season: 40
  },
  {
    name: "Brown Boots",
    price: 125.00,
    months_in_season: [1, 2, 3, 4, 5, 9, 10, 11, 12],
    avg_sold_per_month: 10,
    avg_sold_per_month_in_season: 20
  },
  {
    name: "Khaki Pants",
    price: 89.00,
    months_in_season: [1, 2, 3, 4, 5, 9, 10, 11, 12],
    avg_sold_per_month: 30,
    avg_sold_per_month_in_season: 50
  },
  {
    name: "Super Soft Hoodie",
    price: 75.00,
    months_in_season: [1, 2, 3, 4, 5, 9, 10, 11, 12],
    avg_sold_per_month: 40,
    avg_sold_per_month_in_season: 60

  },
  {
    name: "Button-Down Shirt",
    price: 65.05,
    months_in_season: [1, 2, 3, 4, 5, 9, 10, 11, 12],
    avg_sold_per_month: 100,
    avg_sold_per_month_in_season: 150
  },
  {
    name: "Swim Trunks",
    price: 42.20,
    months_in_season: [5, 6, 7, 8],
    avg_sold_per_month: 6,
    avg_sold_per_month_in_season: 60
  },
  {
    name: "Baseball Cap",
    price: 22.33,
    months_in_season: [3, 4, 5, 6, 7, 8, 9],
    avg_sold_per_month: 15,
    avg_sold_per_month_in_season: 30
  },
  {
    name: "Vintage Logo Tee",
    price: 15.95,
    months_in_season: [3, 4, 5, 6, 7, 8, 9],
    avg_sold_per_month: 75,
    avg_sold_per_month_in_season: 120
  },
  {
    name: "Winter Hat",
    price: 12.95,
    months_in_season:[1, 2, 9, 10, 11, 12], # winter months
    avg_sold_per_month: 4,
    avg_sold_per_month_in_season: 40
  },
  {
    name: "Sticker Pack",
    price: 4.50,
    months_in_season: [8, 12], # back-to-school and holidays
    avg_sold_per_month: 100,
    avg_sold_per_month_in_season: 200
  }
]

def format_usd(numeric)
  return sprintf('%.2f', numeric)
end

#
# CAPTURE USER INPUTS
#

if ENV.fetch("SCRIPT_ENV", "development") == "test"
  response = "201803"
else
  cli = HighLine.new
  response = cli.ask("Please enter a year and month (e.g. 201803)")
end

month_beg = Date.strptime(response, "%Y%m")
month = month_beg.month
month_end = month_beg.end_of_month
puts "MONTH NUM: #{month}"
puts "BEGIN: #{month_beg.to_s}"
puts "END: #{month_end.to_s}"
days = (month_beg .. month_end).to_a

#
# WRITE DATA TO CSV
#

csv_filepath = "./data/sales-#{response}.csv"
headers = ["date", "product", "unit price", "units sold", "sales price"]

FileUtils.rm_rf(csv_filepath)

CSV.open(csv_filepath, "w", :write_headers=> true, :headers => headers) do |csv|
  days.each do |day|
    puts "#{day.to_s}"
    PRODUCTS.each do |product|
      units = product[:months_in_season].include?(month) ? product[:avg_sold_per_month_in_season] : product[:avg_sold_per_month]

      case day.wday
      when 6,0 # weekend days
        units = units * 2
      when 5 # fridays
        units = units * 1.5
      end

      units = rand(units)
      units = units / 30
      units = units.to_i

      if units > 0
        puts "   + #{product[:name]} (#{units})"

        sales_usd = format_usd(product[:price] * units)
        price_usd = format_usd(product[:price])
        csv << [day.to_s, product[:name], price_usd, units, sales_usd]
      end
    end
  end
end
