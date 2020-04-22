# frozen_string_literal: true

require_relative 'basket'

class Checkout
  attr_reader :prices, :basket
  private :prices, :basket

  def initialize(prices)
    @prices = prices
    @basket = Basket.new(prices)
  end

  def total
    basket.calculate_total
  end
end
