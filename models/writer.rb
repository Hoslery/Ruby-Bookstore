# frozen_string_literal: true

require_relative 'book'
require_relative 'book_list'
require_relative 'office_sup'
require_relative 'office_sup_list'
require 'csv'

# module Writer
module Writer
  def self.write_list(file_name, shop_list, books, supplies)
    CSV.open("#{file_name}.csv", 'wb') do |csv|
      csv << ['Товар', 'Цена', 'Кол-во штук']
      shop_list.each do |k, v|
        csv << if k.include? '_sup'
                 [k.split('_')[0], supplies.search_price_by_title(k.split('_')[0]) * v, v]
               else
                 [k, books.search_price_by_title(k) * v, v]
               end
      end
    end
  end
end
