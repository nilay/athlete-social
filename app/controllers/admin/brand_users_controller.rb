class Admin::BrandUsersController < Admin::ApplicationController
  load_and_authorize_resource
  before_action :set_query, only: :index
  before_action :set_brand_user, only: [:show, :edit, :update, :deactivate, :destroy]

  def index
    @brand_users = BrandUser.active.search(@query).result
      .page(params[:page])
      .per(25)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
  end

  def create
    @brand_user = BrandUser.new(brand_user_params)
    @brand_user.brand = current_user.brand unless can? :manage, :brand
    if @brand_user.save
      redirect_to root_path, notice: "Brand User created!"
    else
      redirect_to new_brand_user_path, alert: "Brand User could not be saved: #{@brand_user.errors.full_messages}."
    end
  end

  def show
  end

  def edit
  end

  def update
    if @brand_user.update(brand_user_params)
      redirect_to root_path, notice: "Brand User updated!"
    else
      redirect_to new_brand_user_path, alert: "Brand User could not be updated: #{@brand_user.errors.full_messages}."
    end
  end

  def destroy
    if @brand_user.destroy
      redirect_to root_path, notice: "Brand User destroyed!"
    else
      redirect_to new_brand_user_path, alert: "Brand User could not be destroyed: #{@brand_user.errors.full_messages}."
    end
  end

  def deactivate
    if @brand_user.update(active: false)
      redirect_to root_path, notice: "Brand User deactivated!"
    else
      redirect_to new_brand_user_path, alert: "Brand User could not be updated: #{@brand_user.errors.full_messages}."
    end
  end

  private

  def brand_user_params
    params.require(:brand_user).permit([:first_name, :last_name, :email, :active, :brand_id])
  end

  def set_query
    @query = {}
    @query[:first_name_or_last_name_cont_any] = params[:search].to_s.split(" ")
  end

  def set_brand_user
    @brand_user = User.find(params[:id])
  end
end
