# frozen_string_literal: true

require 'discounts'
require 'discount_manager'
require_relative './item'
require_relative './order_item'

class Basket
  attr_reader :prices, :contents, :discounts
  private :prices, :discounts

  def initialize(prices, contents: [])
    @prices = prices
    @contents = contents
    @discounts = DiscountManager::OFFERS
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

  def calculated_cost_for(item)
    selected_discount = select_discount_for(item)

    if selected_discount.nil?
      Discounts.new(prices, item).buy_with_no_discount
    else
      Discounts.new(prices, item).apply(selected_discount)
    end
  end

  def select_discount_for(item)
    discounts.find do |discount|
      discount[:applies_to].include?(item.name)
    end
  end
end
