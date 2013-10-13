class PageController < ApplicationController
  def index
    respond_to do |format|
      format.html { @pages = Page.all }
      format.json { render :json => Page.all }
    end
  end

  def limited_closure
    start_page = Page.find_by_title params[:start_title]
    end_page = Page.find_by_title params[:end_title]

    closure = start_page.limited_closure end_page.title
    respond_to do |format|
      format.json { render :json => {:pages => closure, :links => Page.get_links(closure) } }
    end
  end

  def nearest
    respond_to do |format|
      format.html
      format.json do
        page = Page.find_by_title params[:title]
        n = 3 #params[:n].to_i || 10
        nearest = page.nearest n
        render :json => {:pages => nearest, :links => Page.get_links(nearest) }
      end
    end
  end

  def titles
    pages=Page.all.map do |page|
      page.title
    end
    respond_to do |format|
      format.html
      format.json { render :json => pages }
    end
  end
  
  def id
    pageid = Page.find_by_title(params[:title]).id
    render :json => pageid
  end
end
