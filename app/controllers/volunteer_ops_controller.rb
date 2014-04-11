class VolunteerOpsController < ApplicationController
  before_filter :authorize, :except => [:index, :show]

  # GET /volunteer_ops
  # GET /volunteer_ops.json
  def index
    @volunteer_ops = VolunteerOp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @volunteer_ops }
    end
  end

  # GET /volunteer_ops/1
  # GET /volunteer_ops/1.json
  def show
    @volunteer_op = VolunteerOp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @volunteer_op }
    end
  end

  # GET /volunteer_ops/new
  # GET /volunteer_ops/new.json
  def new
    @volunteer_op = VolunteerOp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @volunteer_op }
    end
  end

  # GET /volunteer_ops/1/edit
  def edit
    @volunteer_op = VolunteerOp.find(params[:id])
  end

  # POST /volunteer_ops
  # POST /volunteer_ops.json
  def create
    @volunteer_op = VolunteerOp.new(params[:volunteer_op])
    #TODO add association with current_user's organization

    respond_to do |format|
      if @volunteer_op.save
        format.html { redirect_to @volunteer_op, notice: 'Volunteer op was successfully created.' }
        format.json { render json: @volunteer_op, status: :created, location: @volunteer_op }
      else
        format.html { render action: "new" }
        format.json { render json: @volunteer_op.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /volunteer_ops/1
  # PUT /volunteer_ops/1.json
  def update
    @volunteer_op = VolunteerOp.find#(params[:id])

    respond_to do |format|
      if @volunteer_op.update_attributes(params[:volunteer_op])
        format.html { redirect_to @volunteer_op, notice: 'Volunteer op was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @volunteer_op.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /volunteer_ops/1
  # DELETE /volunteer_ops/1.json
  def destroy
    @volunteer_op = VolunteerOp.find(params[:id])
    @volunteer_op.destroy

    respond_to do |format|
      format.html { redirect_to volunteer_ops_url }
      format.json { head :no_content }
    end
  end

  private

  def authorize
    unless org_owner?
      flash[:error] = 'You must be signed in as an organization owner to perform this action!'
      redirect_to '/'
      false
    end
  end

  def org_owner?
    current_user.try :can_edit?
  end
end
