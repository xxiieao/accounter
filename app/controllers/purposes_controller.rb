# frozen_string_literal: true

# PurposesController
class PurposesController < ApplicationController
  before_action :set_purpose, except: %i[index create]

  def index
    @purposes = Purpose.all.paginate(page: params[:page])
    @new_purpose = Purpose.new
  end

  def create
    purpose = Purpose.new(purpose_params)
    if purpose.save
      flash[:notice] = 'success'
      flash[:messages] = "Purpose #{purpose.the_name} was successfully created."
    else
      flash[:notice] = 'warnning'
      flash[:messages] = purpose.errors.full_messages
    end
    redirect_to purposes_url
  end

  def edit; end

  def update
    if @purpose.update(purpose_params)
      flash[:notice] = 'success'
      flash[:messages] = "Purpose #{@purpose.the_name} was successfully updated."
      redirect_to purposes_url
    else
      flash[:notice] = 'warnning'
      flash[:messages] = @purpose.errors.full_messages
      render :edit
    end
  end

  def destroy
    if @purpose.destroy
      flash[:notice] = 'success'
      flash[:messages] = "Purpose #{@purpose.the_name} was successfully destroyed."
    else
      flash[:notice] = 'warnning'
      flash[:messages] = @purpose.errors.full_messages
    end
    redirect_to purposes_url
  end

  private

  def set_purpose
    @purpose = Purpose.find(params[:id])
  end

  def purpose_params
    params.require(:purpose).permit(:the_name)
  end
end
