class PagesController < ApplicationController


  def show
    page = Page.find_by(id: params[:id])
    if page
      render json: page, status: 200
    else
      head 404
    end
  end

  def index
    pages = Page.all
    render json: pages, status: 200
  end

  def create
    page = Page.scrape(params[:url])
    if page.save
      head 204, location: page
    else
      render json: page.errors, status: 422
    end
  end

  def destroy
    page = Page.find_by(id: params[:id])
    head 404 and return unless page # page not found
    head 405 and return unless page.destroy # page can not be deleted (maybe action stoped by hook)
    head 204
  end

end

