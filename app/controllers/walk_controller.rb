class WalkController < ApplicationController
  def index

    start = params["start"].gsub!(' ', "+") #"1163+63rd+st+oakland+ca"
    ending = params["end"].gsub!(' ', '+') #"1200+Park+Ave+Emeryville+CA"

    response = RestClient.get "https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + start + "&destinations=" + ending +"&mode=walking&key="
    @results = JSON.parse(response.body)

    @results = @results["rows"][0]["elements"][0]
    render json: @results
  end
end
