class PagesController < ApplicationController
  layout 'full_width'
  before_filter :authorize, :except => :show

  # GET /pages
  def index
    @pages = Page.order('name ASC')
  end

  # GET /pages/:permalink
  def show
    @superadmin = current_user.superadmin? if current_user
    # find_by_permalink! returns exception if no match
    @page = Page.find_by_permalink!(params[:id])
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/:permalink/edit
  def edit
    @page = Page.find_by_permalink!(params[:id])
  end

  # POST /pages
  def create
    @page = Page.new(params[:page])

    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render action: 'new'
    end
  end

  # PUT /pages/:permalink
  def update
    @page = Page.find_by_permalink!(params[:id])
    update_params = PageParams.build params
    if @page.update_attributes(update_params)
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /pages/:permalink
  def destroy
    @page = Page.find_by_permalink!(params[:id])
    @page.destroy

    redirect_to pages_url
  end
  class PageParams
    def self.build params
      params.require(:page).permit(
        :content,
        :name,
        :permalink,
        :link_visible
      )
    end
  end
end
