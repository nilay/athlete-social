class Admin::BrandsController < Admin::ApplicationController
  load_and_authorize_resource
  before_action :set_query, only: :index
  before_action :set_brand, only: [:show, :edit, :update, :deactivate, :destroy]


  def index
    @brands = Brand.active.search(@query).result
      .page(params[:page])
      .per(25)

    @questions = Question.all
      .page(params[:page])
      .per(25)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
  end

  def accounts
    @brands = Brand.search(@query).result
      .page(params[:page])
      .per(25)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def questions
    @questions = Question.all
      .page(params[:page])
      .per(25)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def campaigns

  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    #The redirect here will eventually change.
    if @brand.save
      redirect_to root_path, notice: "Brand Created!"
    else
      redirect_to root_path, alert: "Brand could not be created... #{@brand.errors.full_messages}."
    end
  end

  def edit
  end

  def update
    if @brand.update
      redirect_to root_path, notice: "Brand Updated!"
    else
      redirect_to root_path, alert: "Brand could not be updated... #{@brand.errors.full_messages}."
    end
  end

  def deactivate
    if @brand.update(deactivated_at: Time.current)
      redirect_to root_path, notice: "Brand Deactivated!"
    else
      redirect_to root_path, alert: "Brand could not be deactivated... #{@brand.errors.full_messages}."
    end
  end

  def activate
    if @brand.update(deactivated_at: nil)
      redirect_to root_path, notice: "Brand Activated!"
    else
      redirect_to root_path, alert: "Brand could not be Activated... #{@brand.errors.full_messages}."
    end
  end

  def destroy
    if @brand.destroy
      redirect_to root_path, notice: "Brand Deleted!"
    else
      redirect_to root_path, notice: "Brand could not be deleted... #{@brand.errors.full_messages}."
    end
  end

  private

  def brand_params
    params.require(:brand).permit([:address_line_1, :address_line_2, :city, :contact_name, :description,
      :email, :name, :phone, :postal_code, :state, brand_user_attributes: [:first_name, :last_name, :email,
      :password, :password_confirmation]])
  end

  def set_brand
    @brand = Brand.active.find(params[:id])
  end

  def set_query
    @query = {}
    @query[:name_cont_any] = params[:search].to_s.split(" ")
  end
end
