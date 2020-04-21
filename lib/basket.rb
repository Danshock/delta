# frozen_string_literal: true

require_relative './item'
require_relative './order_item'

class Basket
  attr_reader :prices, :contents

  def initialize(prices, contents: [])
    @prices = prices
    @contents = contents
  end

  def calculate_total
    items_with_prices.map(&:price).sum
  end

  def add(item)
    
    contents << OrderItem.new(item.to_sym, 1)
  end

  private

  def items_in_basket
    contents.each_with_object([]) do |order_item, items_array|
      if items_array.any? { |item| item.name == order_item.name }
        items_array.find { |item| item.name == order_item.name }
                   .quantity += order_item.quantity
      else
        items_array << OrderItem.new(order_item.name, order_item.quantity)
      end
    end
  end
  
  def items_with_prices
    items_in_basket.each_with_object([]) do |item, items_array|
      items_array << Item.new(item.name, calculated_cost_for(item))
    end
  end

  def price_for(item)
    prices.fetch(item.name)
  end

  def calculated_cost_for(item)
    if %i[apple pear].include?(item.name)
      if eligible_for_discount?(item)
        buy_one_get_one_free(item)
      else
        buy_with_no_discount(item)
      end
    elsif %i[pineapple].include?(item.name)
      single_item_half_price_discount(item)
    elsif %i[banana].include?(item.name)
      half_price_discount(item)
    elsif %i[mango].include?(item.name)
      if eligible_for_discount?(item)
        buy_three_get_one_free_discount(item)
      else
        buy_with_no_discount(item)
      end
    else
      buy_with_no_discount(item)
    end
  end

  def eligible_for_discount?(item)
    (item.quantity % 2).zero? || (item.quantity % 4).zero?
  end

  def buy_one_get_one_free(item)
    price_for(item) * (item.quantity / 2)
  end

  def half_price_discount(item)
    (price_for(item) / 2) * item.quantity
  end

  def single_item_half_price_discount(item)
    (price_for(item) / 2) + price_for(item) * (item.quantity - 1)
  end

  def buy_three_get_one_free_discount(item)
    price_for(item) * (item.quantity - 1)
  end

  def buy_with_no_discount(item)
    price_for(item) * item.quantity
  end
end
