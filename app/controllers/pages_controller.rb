class PagesController < ApplicationController
  layout 'full_width'
  # in a method use render layout: "layout"
  before_filter :authorize, :except => :show

  # GET /pages
  # GET /pages.json
  #TODO Hide all but show and edit
  def index
    @pages = Page.all
  end

  # GET /pages/:permalink
  # GET /pages/:permalink.json
  def show
    @admin = current_user.admin? if current_user
    begin
      # find_by_permalink! returns exception if no match
      @page = Page.find_by_permalink!(params[:id])
      status_code = 200
    rescue ActiveRecord::RecordNotFound
      @page = Page.find_by_permalink!('404')
      status_code = 404
    end
    render :html => @page, :status => status_code
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new
  end

  # GET /pages/:permalink/edit
  def edit
    @page = Page.find_by_permalink!(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(params[:page])

    if @page.save
      redirect_to @page, notice: 'Page was successfully created.'
    else
      render action: "new"
    end
  end

  # PUT /pages/:permalink
  # PUT /pages/:permalink.json
  def update
    @page = Page.find_by_permalink!(params[:id])

    if @page.update_attributes(params[:page])
      redirect_to @page, notice: 'Page was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /pages/:permalink
  # DELETE /pages/:permalink.json
  def destroy
    @page = Page.find_by_permalink!(params[:id])
    @page.destroy

    redirect_to pages_url
  end

  private

  # http://railscasts.com/episodes/20-restricting-access
  def authorize
    unless admin?
      flash[:error] = 'unauthorized access'
      redirect_to '/'
      false
    end
  end

  # Not to be confused with the activerecord admin? method
  def admin?
    current_user.present? ? current_user.admin? : false
  end

end
