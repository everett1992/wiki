class PageController < ApplicationController
  def index
    respond_to do |format|
      format.html { @pages = Page.all }
      format.json { render :json => Page.all }
    end
  end
end
