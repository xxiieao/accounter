# frozen_string_literal: true

# DataServiceController
class DataServiceController < ApplicationController
  skip_before_action :verify_authenticity_token, except: [:index]

  def index; end

  def consumption_aggregate
    data = Transaction.get_consumption_analysis(data_service_params.to_hash.symbolize_keys)
    render json: data, status: 200
  end

  def daily_aggregate
    data = Transaction.get_daily_lines(data_service_params.to_hash.symbolize_keys)
    render json: data, status: 200
  end

  private

  def data_service_params
    # params[:end_date] = (Date.today-20).to_s unless params.has_key? :end_date
    # params[:start_date] = (Date.today-30).to_s unless params.has_key? :start_date
    params.require(:data_service).permit(:start_date, :end_date)
  end
end
