class PagesController < ApplicationController
  layout 'full_width'
  before_filter :authorize, :except => :show
  before_action :set_page, only: [:show, :update, :edit]
  before_action :set_tags, only: [:show]
  
  # GET /pages
  def index
    @pages = Page.order('name ASC')
  end

  # GET /pages/:permalink
  def show
    @superadmin = current_user.superadmin? if current_user
  end

  # GET /pages/new
  def new
    @page = Page.new
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

  private

  def set_page
    @page = Page.find_by_permalink!(params[:id])
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

  def meta_tag_title
    @page.name
  end

  def meta_tag_description
    @page.content
  end
end
