class VolunteerOpForm
  include ActiveModel::Model

  class DoitVolunteerOp
    include ActiveModel::Model

    validates :advertise_start_date, presence: true, format: { with: /\d{4}-\d{2}-\d{2}/ }
    validates :advertise_end_date, presence: true
    validates :doit_org_id, presence: true

    validate :advertise_end_date_cannot_be_before_advertise_start_date

    attr_accessor :advertise_start_date, :advertise_end_date, :doit_org_id

    private

      # Custom validation methods
      def advertise_end_date_cannot_be_before_advertise_start_date
        errors.add :advertise_end_date, 'is invalid' unless
        iso_format? advertise_end_date and valid_end_date?
      end

      # Custome validaton 'helper' methods
      def iso_format? date
        date.match(/\d{4}-\d{2}-\d{2}/)
      end

      def valid_end_date?
        advertise_end_date >= advertise_start_date
      end
  end

  attr_writer :volunteer_op, :post_to_doit, :doit_volunteer_op

  validate :validate_children

  def initialize(attributes={})
    super
    @volunteer_op ||= VolunteerOp.new
    @doit_volunteer_op ||= DoitVolunteerOp.new
    @post_to_doit ||= 0
  end

  def volunteer_op
    @volunteer_op ||= VolunteerOp.new
  end

  def doit_volunteer_op
    @doit_volunteer_op ||= DoitVolunteerOp.new
  end

  def post_to_doit
    @post_to_doit ||= 0
  end

  def self.volunteer_op_attributes
    VolunteerOp.column_names.push(VolunteerOp.reflections.keys).flatten
  end

  def self.doit_volunteer_op_attributes
    [:advertise_start_date, :advertise_end_date, :doit_org_id]
  end

  volunteer_op_attributes.each do |attr|
    delegate attr.to_sym, "#{attr}=".to_sym, to: :volunteer_op
  end

  doit_volunteer_op_attributes.each do |attr|
    delegate attr.to_sym, "#{attr}=".to_sym, to: :doit_volunteer_op
  end

  delegate :id, :persisted?, :new_record?, to: :volunteer_op

  def self.model_name
    new.volunteer_op.model_name
  end

  def assign_attributes(params)
    return if params.empty?
    volunteer_op_params = setup_volunteer_op_params(params)
    volunteer_op.assign_attributes(volunteer_op_params)
    @post_to_doit = params[:post_to_doit]
    doit_volunteer_op_params = params.slice(*self.class.doit_volunteer_op_attributes).to_h
    @doit_volunteer_op = DoitVolunteerOp.new(doit_volunteer_op_params)
  end

  def save
    return false unless valid?
    volunteer_op.save!
    PostToDoitJob.perform_later(build_options) if post_to_doit?
    true
  end

  private

  def setup_volunteer_op_params(params)
    args = self.class.volunteer_op_attributes
    return params[:volunteer_op].slice(*args).to_h unless params[:volunteer_op].nil?
    params.slice(*args).to_h
  end

  def post_to_doit?
    post_to_doit == '1'
  end

  def build_options
    {
      volunteer_op: volunteer_op,
      advertise_start_date: advertise_start_date,
      advertise_end_date: advertise_end_date,
      doit_org_id: doit_org_id
    }
  end

  def validate_children
    promote_errors(volunteer_op.errors) if volunteer_op.invalid?
    promote_errors(doit_volunteer_op.errors) if valid_doit_post?
  end

  def valid_doit_post?
    post_to_doit? && doit_volunteer_op.invalid?
  end

  def promote_errors(child_errors)
    child_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
