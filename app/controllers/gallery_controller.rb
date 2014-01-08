class GalleryController < ApplicationController
  def index
	render :json => Comic.ordered.limited.all
  end

  def show
	render :json => Comic.find(params[:id])
  end
end
