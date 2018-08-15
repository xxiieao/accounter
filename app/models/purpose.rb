# frozen_string_literal: true

# Model Purpose
class Purpose < ActiveRecord::Base
  has_many :transactions
  has_many :transaction_feature_counters

  validates :the_name, presence: true, uniqueness: { case_sensitive: false }
  before_destroy :confirm_presence_of_transactions

  scope :has_one_transaction_at_least, -> { where('counter > ?', 0) }

  def counter_plus_one
    increment!(:counter)
  end

  def counter_minus_one
    decrement!(:counter)
  end

  def self.counters_for_all_purposes
    has_one_transaction_at_least.pluck(:id, :counter)
  end

  private

  def confirm_presence_of_transactions
    trans_number = transactions.count
    return if trans_number.zero?
    errors.add :base, "Purpose can be deleted when #{trans_number} transactions atteched to it."
    throw(:abort)
  end
end
