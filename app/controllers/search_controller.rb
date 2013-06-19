class SearchController < ApplicationController

  def index
  end

  def fetch_results
     Search.new(params[:search]) do |results, message|
       if results.blank?
         flash[:error] = message
       else
         flash[:notice] = message
         @results = results
       end
       redirect_to root_path
     end
  end

end
