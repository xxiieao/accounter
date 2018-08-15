# frozen_string_literal: true

# TransactionsController
class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[edit update]
  skip_before_action :verify_authenticity_token, only: [:batch_create]

  def index
    @transactions = Transaction.includes(:purpose).order('id desc').paginate(page: params[:page], per_page: 20)
  end

  def edit; end

  def update
    if @transaction.update(transaction_params)
      flash[:notice] = 'success'
      flash[:messages] = "Transaction #{@transaction.id} was successfully updated."
      redirect_to transactions_url
    else
      flash[:notice] = 'warnning'
      flash[:messages] = @transaction.errors.full_messages
      render :edit
    end
  end

  # get the unassorted transactions page
  def unassorted
    @transactions = Transaction.unassorted.limit(10)
  end

  # batch update purpose ids of transactions
  def purpose_confirm
    Transaction.batch_update_purpose(transaction_confirm_params)
    redirect_to unassorted_transactions_url
  end

  def preview; end

  def batch_create
    if Transaction.batch_create(transaction_batch_create_params)
      render json: 'Data has been imported', status: 200
    else
      render json: 'These is something wrong about data', status: 400
    end
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:purpose_id)
  end

  def transaction_confirm_params
    params.require(:transaction).permit(ids: [], purpose_ids: [])
  end

  def transaction_batch_create_params
    params.require(:transaction).require(:data)
  end
end
