# frozen_string_literal: true

class DiscountManager
  OFFERS = [
    {
      applies_to: %i[apple pear],
      offer_type: :buy_one_get_one_free
    },
    {
      applies_to: %i[pineapple],
      offer_type: :single_item_half_price_discount
    },
    {
      applies_to: %i[banana],
      offer_type: :half_price_discount
    },
    {
      applies_to: %i[mango],
      offer_type: :buy_three_get_one_free_discount
    }
  ].freeze
end
