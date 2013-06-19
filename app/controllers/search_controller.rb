class SearchController < ApplicationController

  def index
  end

  def fetch_results
     Search.new(params[:search]) do |results|
       if results.blank?
          render :text => "X No results found",  :status => 401
       else
         logger.debug "*********Output******************"
         logger.debug results.inspect
         @results = results
       end
     end
  end

end
