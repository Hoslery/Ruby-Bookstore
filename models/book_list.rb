# frozen_string_literal: true

require_relative 'book'
require 'csv'
require_relative 'same_func'

# The class that contains all books
class BookList
  def initialize(books = [])
    @books = books.map do |book|
      [book.id, book]
    end.to_h
  end

  def add_book(book)
    @books[book.id] = book
  end

  def add_book_user(parameters)
    flag = true
    @books.each do |_k, v|
      next unless v.author.downcase == parameters[:author].downcase &&
                  v.title.downcase == parameters[:title].downcase &&
                  v.genre.downcase == parameters[:genre].downcase &&
                  v.price.round(2) == parameters[:price].round(2)

      flag = false
      v.quantity += 1
    end
    return if flag == false

    book_id = @books.keys.max + 1
    @books[book_id] =
      Book.new(book_id, parameters[:author], parameters[:title], parameters[:genre],
               parameters[:price], 1)
  end

  def all_books
    @books.values
  end

  def book_by_id(id)
    @books[id]
  end

  def filter(title, genre)
    @books.select do |_k, v|
      next if title && !title.empty? && title.downcase != v.title.downcase
      next if genre && !genre.empty? && genre.downcase != v.genre.downcase

      true
    end
  end

  def genres
    genres = {}
    @books.each do |_k, v|
      if genres[v.genre].nil?
        genres[v.genre] = v.quantity
      else
        genres[v.genre] += v.quantity
      end
    end
    genres
  end

  def count_book_by_genre(genre)
    count = 0
    @books.each do |_k, v|
      count += 1 if v.genre == genre
    end
    count
  end

  def sum_of_price(genre)
    sum = 0
    @books.each do |_k, v|
      sum += v.price if v.genre == genre
    end
    sum
  end

  def all_title
    titles = []
    @books.each do |_k, v|
      titles.append(v.title)
    end
    titles
  end

  def search_price_by_title(title)
    @books.each do |_k, v|
      return v.price if v.title == title
    end
  end

  def recalculating_list(shop_list)
    # @books.each do |key,value|
    #   shop_list.each do |k,v|
    #     next if k.include? "_sup"
    #     if value.title == k
    #       if value.quantity == v
    #         @books.delete(value.id)
    #       else 
    #         value.quantity = value.quantity - v
    #       end
    #     end
    #   end
    # end

    @books = SameFunc.rec_list(@books,shop_list)

    # @books.each do |k, v|
    #   CSV.foreach("#{file_name}.csv", headers: true) do |row|
    #     if v.title == row[0]
    #       if v.quantity <= row[2].to_i
    #         @books.delete(k)
    #       else
    #         v.quantity = v.quantity - row[2].to_i
    #       end
    #     end
    #   end
    # end
  end

  def search_quantity_by_title(title)
    @books.each do |_k, v|
      return v.quantity if v.title == title
    end
  end

  def delete_book(id)
    @books.delete(id)
  end
end
