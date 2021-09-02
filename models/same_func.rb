# frozen_string_literal: true

require_relative 'book'
require_relative 'book_list'
require_relative 'office_sup'
require_relative 'office_sup_list'

module SameFunc
    def self.rec_list(tovar,shop_list)
        tovar.each do |key,value|
            shop_list.each do |k,v|
              if k.include? "_sup"
                k = k.split('_')[0]
              end  
              if value.title == k
                if value.quantity == v
                  tovar.delete(value.id)
                else 
                  value.quantity = value.quantity - v
                end
              end
            end
        end
        tovar
    end
end