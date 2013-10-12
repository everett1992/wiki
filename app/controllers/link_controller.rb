class LinkController < ApplicationController
  def index
    respond_to do |format|
      format.html { @links = Link.all }
      format.json { render :json => Link.all }
    end
  end
end
