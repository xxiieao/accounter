# frozen_string_literal: true

# Model TransactionFeatureCounter
class TransactionFeatureCounter < ActiveRecord::Base
  belongs_to :purpose

  def counter_plus_one
    increment!(:counter)
  end

  def counter_minus_one
    decrement!(:counter)
  end

  def self.counters_for_given_feature(search_condition)
    where(search_condition).pluck(:purpose_id, :counter)
  end
end
