class LegsController < ApplicationController
  def index
    @legs = Leg.all
    render json: @legs
  end

  def create
    @leg = Leg.new(leg_params)
    if @leg.save
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
    params.require(:leg).permit(:mode, :start_location, :end_location, :distance, :emissions, :created_at, :updated_at, :trip_id)
  end
end
