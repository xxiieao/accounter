# frozen_string_literal: true

# Model Transaction
class Transaction < ActiveRecord::Base
  belongs_to :purpose, optional: true
  around_save :create_feature_counter

  scope :unassorted, -> { where(confirmed: false) }
  scope :spent, -> { where('amount < ?', 0) }
  scope :income, -> { where('amount > ?', 0) }
  scope :period, ->(params) { where('the_date >= :start_date and the_date <= :end_date', params) }

  FEATURES = %w[the_type shop payer amount_sep].freeze
  # NO_RECORD_WEIGHT is the default value for a feature
  # never found in history transactions. In bayesian inference,
  # those features would be given a default rate to prevent return 0
  NO_RECORD_WEIGHT = 0.1

  def purpose_name
    purpose&.the_name || 'unassorted'
  end

  def amount_sep
    (amount / 10).to_i
  end

  # create or update feature statistics when transaction update its purpose_id
  def create_feature_counter
    self.class.transaction do
      set_confirmed
      purpose_learning(need_relearing?) if need_learing? || need_relearing?
      yield
    end
  end

  # return the id of most possible purpose
  # return 0 if there is no possible purposes at all
  def most_possible_purpose
    inference_ratios = purpose_inference
    return 0 if inference_ratios.empty?
    inference_ratios.max_by { |_k, v| v }.first
  end

  # calculate the scores of each purpose
  def purpose_inference
    purpose_counters = Purpose.counters_for_all_purposes.to_h
    purpose_scores = purpose_counters.clone
    FEATURES.each do |feature|
      search_cond = { feature_name: feature, feature_value: send(feature) }
      feature_counters = TransactionFeatureCounter.counters_for_given_feature(search_cond).to_h
      feature_scores = purpose_counters.map do |k, v|
        [k, feature_counters[k] ? feature_counters[k] / v.to_f : NO_RECORD_WEIGHT]
      end
      purpose_scores = purpose_scores.merge(feature_scores.to_h) { |_k, v1, v2| v1 * v2 }
    end
    purpose_scores
  end

  def set_confirmed
    self.confirmed = true if purpose_id_was.nil? && purpose_id.present?
  end

  def need_learing?
    confirmed_changed?
  end

  def need_relearing?
    confirmed_was && purpose_id_changed?
  end

  def purpose_learning(relearn)
    prev_purpose = Purpose.find(purpose_id_was) if relearn
    curr_purpose = purpose
    FEATURES.each do |feature|
      search_condition = { feature_name: feature, feature_value: send(feature) }
      prev_purpose.transaction_feature_counters.where(search_condition).first.counter_minus_one if relearn
      curr_purpose.transaction_feature_counters.find_or_create_by(search_condition).counter_plus_one
    end
    prev_purpose.counter_minus_one if relearn
    curr_purpose.counter_plus_one
  end

  class << self
    def batch_update_purpose(params)
      params['ids'].zip(params['purpose_ids']).each do |t_id, p_id|
        find(t_id).update(purpose_id: p_id) unless p_id.to_i.zero?
      end
    end

    def batch_create(csv_data)
      return false unless csv_data_valid?(csv_data)
      # papaparse.js would read the last new line as a empty array
      # so we have to delete the last element if it was empty
      csv_data.pop if csv_data.last.empty?
      headers = csv_data.shift
      csv_data.each do |values|
        return false unless values&.length.eql? 6
        self.find_or_create_by(headers.zip(values).to_h)
      end
      return true
    end

    def get_daily_lines(date_range)
      {
        series:
          %w[spent income balance].map do |catg|
            {
              name: catg,
              data: fill_na(send("get_#{catg}_series", date_range), date_range),
              pointStart: date_range[:start_date],
              pointInterval: 24 * 3600 * 1000
            }
          end
      }
    end

    def get_consumption_analysis(date_range)
      {
        series: [{
          data: period(date_range).spent.joins(:purpose).group(:the_name).sum(:amount).
            map { |k, v| { 'name': k, 'y': v.to_f.abs } }
        }]
      }
    end

    def get_income_series(date_range)
      period(date_range).income.group(:the_date).sum(:amount)
    end

    def get_spent_series(date_range)
      period(date_range).spent.group(:the_date).sum(:amount)
    end

    def get_balance_series(date_range)
      period(date_range).group(:the_date).minimum(:balance)
    end

    private

      def fill_na(series, params)
        (params[:start_date].to_date..params[:end_date].to_date).each do |day|
          series[day] = series.key?(day) ? series[day].to_f.abs : 0.0
        end
        series.sort.transpose.second
      end

      def csv_data_valid?(csv_data)
        return false unless csv_data.is_a? Array
        return false if csv_data.empty?
        return false if csv_data.first.empty?
        return false unless csv_data.first.sort.eql?  %w[the_type shop payer the_date amount balance].sort
        return true
      end
  end
end
