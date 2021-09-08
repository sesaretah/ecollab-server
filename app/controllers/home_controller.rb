class HomeController < ApplicationController
  def index
    if !params[:slug].blank?
      #Events.where(shortname: params[:slug])
      redirect_to "/#/events/name/#{params[:slug]}"
    end
    #redirect_to "index.html"
  end
end
