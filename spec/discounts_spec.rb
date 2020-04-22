# frozen_string_literal: true

require 'spec_helper'
require 'discounts'
require 'order_item'

RSpec.describe Discounts do
  describe '#apply' do
    subject { described_class.new(prices, item).apply(discount) }

    let(:prices) do
      {
        apple: 10,
        orange: 20,
        pear: 15,
        banana: 30,
        pineapple: 100,
        mango: 200
      }
    end

    context 'when a half price offer is active' do
      let(:discount) do
        {
          applies_to: %i[banana],
          offer_type: :half_price_discount
        }
      end
      let(:item) { OrderItem.new(:banana, 1) }

      it 'it makes the product cost half' do
        expect(subject).to eq(15)
      end
    end

    context 'when a buy three get one free offer is active' do
      let(:discount) do
        {
          applies_to: %i[mango],
          offer_type: :buy_three_get_one_free_discount
        }
      end
      let(:item) { OrderItem.new(:mango, 4) }

      it 'makes every 4th product free' do
        expect(subject).to eq(600)
      end
    end

    context 'when a half price offer on a single item is selected' do
      let(:discount) do
        {
          applies_to: %i[pineapple],
          offer_type: :single_item_half_price_discount
        }
      end
      let(:item) { OrderItem.new(:pineapple, 2) }

      it 'makes a single item half price' do
        expect(subject).to eq(150)
      end
    end

    context 'when a two for one offer is selected' do
      let(:discount) do
        {
          applies_to: %i[apple pear],
          offer_type: :buy_one_get_one_free
        }
      end
      let(:item) { OrderItem.new(:pear, 2) }

      it 'makes every 2nd product free' do
        expect(subject).to eq(15)
      end
    end
  end

  describe '#buy_with_no_discount' do
    subject { described_class.new(prices, item).buy_with_no_discount }

    let(:prices) { { mango: 200 } }

    context 'when not eligible for buy three get one free discount' do
      let(:item) { OrderItem.new(:mango, 2) }

      it 'is expected to return full price' do
        expect(subject).to eq(400)
      end
    end
  end
end
