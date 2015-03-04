class BikeController < ApplicationController
  def index
    start = params["start"].gsub!(' ', "+")
    ending = params["end"].gsub!(' ', '+')

    response = RestClient.get "https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + start + "&destinations=" + ending +"&mode=biking&units=imperial&key=AIzaSyA6LTKJE21pYmBhAU0PiVndEyb7YZ9Cepo"
    @results = JSON.parse(response.body)

    @results = @results["rows"][0]["elements"][0]
    render json: @results
  end
end
