# frozen_string_literal: true

require_relative 'book'
require_relative 'book_list'
require_relative 'office_sup'
require_relative 'office_sup_list'
require 'csv'

# module Reader
module Reader
  BOOKS_FILE = File.expand_path('../data/books.csv', __dir__)
  SUP_FILE =   File.expand_path('../data/supplies.csv', __dir__)
  def self.read_books
    book_list = BookList.new
    id = 1
    CSV.foreach(BOOKS_FILE) do |row|
      book = Book.new(id, row[0], row[1], row[2], Float(row[3]), Integer(row[4]))
      book_list.add_book(book)
      id += 1
    end
    book_list
  end

  def self.read_supplies
    sup_list = OfficeSupList.new
    id = 1
    CSV.foreach(SUP_FILE) do |row|
      sup = OfficeSup.new(id, row[0], Float(row[1]), Integer(row[2]))
      sup_list.add_sup(sup)
      id += 1
    end
    sup_list
  end
end
