class OrganizationsController < ApplicationController

  OrganizationsController::ALPHABETICALLY='ALPHABETICALLY'
  OrganizationsController::UPDATE_DATE='UPDATE_DATE'
  OrganizationsController::DESCENDING='DESCENDING'
  OrganizationsController::ASCENDING='ASCENDING'

  @order = nil
  @method = nil

# GET /organizations/search
  # GET /organizations/search.json
  before_filter :authenticate_charity_worker!, :except => [:search, :index, :show]
  def search
    # should this be a model method with a model spec around it ...?

    @organizations = Organization.search_by_keyword(params[:q])
    @json = @organizations.to_gmaps4rails
    respond_to do |format|
      format.html { render :template =>'organizations/index'}
      format.json { render json: @organizations }
    end
  end

  # GET /organizations
  # GET /organizations.json
  def index
    @order = nil
    @method = nil
    redir = true
    if params[:method]&& params[:order] then
      @method=params[:method]
      session[:method]=params[:method]
      @order=params[:order]
      session[:order]=params[:order]
      redir = false
    elsif params[:method]
      @method=params[:method]
      session[:method]=params[:method]
      params[:order]=load_params_order
    elsif params[:order]
      @order=params[:order]
      session[:order]=params[:order]
      params[:method]=load_params_method
    else
      params[:order]=load_params_order
      session[:order]=params[:order]
      params[:method]=load_params_method
      session[:method]=params[:method]
    end
    if redir == true then
      flash.keep
      return redirect_to organizations_path(:order => params[:order],:method => params[:method])
    end
    @organizations = Organization.get_Organizations(@order,@method)
# @organizations = Organization.order("updated_at DESC")
    @json = @organizations.to_gmaps4rails
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @organizations }
    end
  end


  def load_params_order
    if session[:order]
       @order=session[:order]
       session[:order]
    else
      @order=OrganizationsController::UPDATE_DATE
      OrganizationsController::UPDATE_DATE
    end
  end

  def load_params_method
    if session[:method]
       @method=session[:method]
       session[:method]
    else
      @method=OrganizationsController::DESCENDING
      OrganizationsController::DESCENDING
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
