class OrganizationsController < ApplicationController
  # GET /organizations/search
  # GET /organizations/search.json
  before_filter :authenticate_charity_worker!, :except => [:search, :index, :show]
  def search
    # should this be a model method with a model spec around it ...?
    @organizations = Organization.search_by_keyword(params[:q]).page(params[:page]).per(5)
    @json = Organization.search_by_keyword(params[:q]).to_gmaps4rails
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
#@organizations = Organization.all
    @organizations = Organization.order("updated_at DESC").page(params[:page]).per(5)
    @json = Organization.order("updated_at DESC").to_gmaps4rails
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
    #TODO: Refactor flow and/or into seperate filter.  This is getting smelly and defensive
    unless current_charity_worker.try(:admin?) ||(current_charity_worker.organization && current_charity_worker.organization.id.to_s == params[:id])
      flash[:notice] = "You don't have permission"
      redirect_to organization_path(params[:id]) and return false
    end
    @organization = Organization.find(params[:id])

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
    @organization = Organization.find(params[:id])
    @organization.destroy

    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :ok }
    end
  end
end
