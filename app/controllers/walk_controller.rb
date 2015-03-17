class WalkController < ApplicationController
  def index

    start = params["start"].gsub!(' ', "+")
    ending = params["end"].gsub!(' ', '+')

    response = RestClient.get "https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + start + "&destinations=" + ending +"&mode=walking&units=imperial&key="
    @results = JSON.parse(response.body)

    @results = @results["rows"][0]["elements"][0]
    render json: @results
  end
end
