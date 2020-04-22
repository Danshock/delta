# frozen_string_literal: true

require 'spec_helper'
require 'checkout'

RSpec.describe Checkout do
  describe '#total' do
    subject { checkout.total }
    let(:checkout) { described_class.new(pricing_rules) }

    let(:pricing_rules) do
      {
        apple: 10,
        orange: 20,
        pear: 15,
        banana: 30,
        pineapple: 100,
        mango: 200
      }
    end

    context 'when there are items in basket' do
      it 'returns the calculated total from the basket' do
        expect_any_instance_of(Basket).to receive(:calculate_total)
        subject
      end
    end
  end
end
