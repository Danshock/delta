# frozen_string_literal: true

require_relative './basket'
require_relative './order_item'

class Checkout
  attr_reader :prices, :basket
  private :prices, :basket

  def initialize(prices)
    @prices = prices
    @basket = Basket.new(prices)
  end

  def total
    basket_total
  end

  private

  def basket_total
    basket.calculate_total
  end
end
