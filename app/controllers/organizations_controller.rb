class OrganizationsController < ApplicationController
  # GET /organizations/search
  # GET /organizations/search.json
  before_filter :authenticate_user!, :except => [:search, :index, :show]
  def search
    # should this be a model method with a model spec around it ...?
    @query_term = params[:q]
    @results = Organization.search_by_keyword(@query_term)
    flash.now[:alert] = "Sorry, it seems we don't quite have what you are looking for." if @results.empty?
    @organizations = @results.page(params[:page]).per(5)
    @json = @results.to_gmaps4rails
    respond_to do |format|
      format.js   { render :template =>'organizations/index'}
      format.html { render :template =>'organizations/index'}
      format.json { render json:  @organizations }
      format.xml  { render :xml => @organizations }
    end
  end

  # GET /organizations
  # GET /organizations.json
  def index
    @results = Organization.order("updated_at DESC")
    @organizations = @results.page(params[:page]).per(5)
    @json = @results.to_gmaps4rails
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.json { render json: @organizations }
      format.xml  { render :xml => @organizations }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])
    @editable = current_user.can_edit?(@organization) if current_user
    @json = @organization.to_gmaps4rails
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.json
  def new
    @organization = Organization.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
    @organization = Organization.find(params[:id])
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(params[:organization])

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render json: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.json
  def update
    @organization = Organization.find(params[:id])
    unless current_user.try(:can_edit?,@organization)
      flash[:notice] = "You don't have permission"
      redirect_to organization_path(params[:id]) and return false
    end
    respond_to do |format|
      if @organization.update_attributes(params[:organization])
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    unless current_user.try(:admin?)
      flash[:notice] = "You don't have permission"
      redirect_to organization_path(params[:id]) and return false
    end
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :ok }
    end
  end
end
