require 'json'

def setup_files
		path = File.join(File.dirname(__FILE__), '../data/products.json')
		file = File.read(path)
		$products_hash = JSON.parse(file)
		$report_file = File.new("report.txt","w+")
		$stdout = $report_file
end

def create_report
		print_sales_report_heading
		print_product_heading
		print_product_data ($products_hash)
		print_brands_heading
		print_brands_data ($products_hash)
end

def print_sales_report_heading
		print_sales_report_date
		print_sales_report_ascii
end

def print_product_heading
	puts
	puts "                     _            _       "
	puts "                    | |          | |      "
	puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	puts "| |                                       "
	puts "|_|                                       "
	puts
end

def print_product_data (hash_data)
		hash_data["items"].each do |toy|
		purchases_count = toy["purchases"].length
		purchases_sum = 0
		toy["purchases"].each {|purchase_record| purchases_sum += Float(purchase_record["price"])}
		average_price = purchases_sum / purchases_count
		average_discount = 100 - (average_price / Float(toy["full-price"]) * 100)
		puts toy["title"]
		puts "**********************"
		puts "Retail Price: #{toy["full-price"]}"
		puts "Total Purchases: #{purchases_count}"
		puts "Total Sales: #{purchases_sum}"
		puts "Average Price: #{average_price}"
		puts "Average Discount: #{average_discount.round(2)}%"
		puts
	end
end

def print_brands_heading
	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	puts

end

def print_brands_data (hash_data)
	brands = hash_data["items"].map {|product| product["brand"]}.uniq
	brands.each do |brand|
		brand_stock = 0
		brand_num_saled = 0
		brand_total_revenue = 0
		brand_toy_num_sum = 0
		brand_toy_price_sum = 0
		hash_data["items"].each do |toy|
			if toy["brand"] == brand
				brand_toy_num_sum += 1
				brand_toy_price_sum += Float(toy["full-price"])
				brand_stock += toy["stock"]
				brand_num_saled += toy["purchases"].length
				toy["purchases"].each {|each_purchase| brand_total_revenue += Float(each_purchase["price"]) }
			end
		end

		puts brand
		puts "***********************"
		puts "Number of stocks: #{brand_stock}"
		puts "Average Product Price: #{(brand_toy_price_sum / brand_toy_num_sum).round(2)}"
		puts "Total Sales: $#{brand_total_revenue.round(2)}"
		puts
	end
end

def print_sales_report_ascii
		require 'Artii'
		puts Artii::Base.new.asciify('Sales Report')
end

def print_sales_report_date
		require 'date'
		puts "Today's Date: #{DateTime.now.strftime('%d/%m/%Y')}"
end

setup_files
create_report
