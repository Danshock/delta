# frozen_string_literal: true

class Discounts
  attr_reader :prices, :item
  private :prices, :item

  def initialize(prices, item)
    @prices = prices
    @item = item
  end

  def apply(discount)
    send(discount[:offer_type])
  end

  def buy_with_no_discount
    price_for(item) * item.quantity
  end

  private

  def price_for(item)
    prices.fetch(item.name)
  end

  def buy_one_get_one_free
    price_for(item) * item.quantity - (price_for(item) * (item.quantity / 2))
  end

  def half_price_discount
    (price_for(item) / 2) * item.quantity
  end

  def single_item_half_price_discount
    price_for(item) / 2 + price_for(item) * (item.quantity - 1)
  end

  def buy_three_get_one_free_discount
    price_for(item) * item.quantity - (price_for(item) * (item.quantity / 4))
  end
end
