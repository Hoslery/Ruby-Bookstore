# frozen_string_literal: true

require_relative 'office_sup'
require_relative 'same_func'

# The class that contains all office supplies
class OfficeSupList
  def initialize(supplies = [])
    @supplies = supplies.map do |sup|
      [sup.id, sup]
    end.to_h
  end

  def add_sup(sup)
    @supplies[sup.id] = sup
  end

  def add_supplies_user(parameters)
    flag = true
    @supplies.each do |_k, v|
      next unless v.title.downcase == parameters[:title].downcase &&
                  v.price.round(2) == parameters[:price].round(2)

      flag = false
      v.quantity += 1
    end
    return if flag == false

    sup_id = @supplies.keys.max + 1
    @supplies[sup_id] =
      OfficeSup.new(sup_id, parameters[:title], parameters[:price], 1)
  end

  def all_supplies
    @supplies.values
  end

  def sum_instance
    sum = 0
    @supplies.each do |_k, v|
      sum += v.quantity
    end
    sum
  end

  def sup_by_id(id)
    @supplies[id]
  end

  def all_title
    titles = []
    @supplies.each do |_k, v|
      titles.append(v.title)
    end
    titles
  end

  def search_price_by_title(title)
    @supplies.each do |_k, v|
      return v.price if v.title == title
    end
  end

  def search_quantity_by_title(title)
    @supplies.each do |_k, v|
      return v.quantity if v.title == title
    end
  end

  def recalculating_list(shop_list)
    # @supplies.each do |key,value|
    #   shop_list.each do |k,v|
    #     if k.include? "_sup"
    #       if value.title == k.split('_')[0]
    #         if value.quantity == v
    #           @supplies.delete(value.id)
    #         else 
    #           value.quantity = value.quantity - v
    #         end
    #       end
    #     end
    #   end
    # end

    @supplies = SameFunc.rec_list(@supplies,shop_list)
    # @supplies.each do |k, v|
    #   CSV.foreach("#{file_name}.csv", headers: true) do |row|
    #     if v.title == row[0]
    #       if v.quantity <= row[2].to_i
    #         @supplies.delete(k)
    #       else
    #         v.quantity = v.quantity - row[2].to_i
    #       end
    #     end
    #   end
    # end
  end

  def delete_sup(id)
    @supplies.delete(id)
  end
end
