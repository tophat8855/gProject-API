class LegsController < ApplicationController
  def index
    @legs = current_user.legs
    render json: @legs
  end

  def create
    p "*" * 80

    p current_user
    @leg = Leg.new(leg_params)
    @leg.user = current_user
    p "*" * 80
    p @leg
    if @leg.save!
      render json: @leg
    end
  end

  def show
    @leg = Leg.find(params[:id])
    render json: @leg
  end

  def destroy
    @leg = Leg.find(params[:id])
    if @leg.destroy
      render json: @leg
    end
  end

  private
  def leg_params
    params.require(:leg).permit(:mode, :start_location, :end_location, :distance, :emissions, :direction, :route, :date, :created_at, :updated_at, :user_id, :trip_id)
  end
end
