class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    ps = user_params

    unless ps
      respond_to do |format|
        format.html { render :new, notice: 'interest_list is invlid' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

    @user = User.new(ps)
    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to posts_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authenticate_user
    if current_user.id != @user.id
      redirect_to edit_user_path(current_user.id)
    end
    
    respond_to do |format|
      ps = user_params

      if !ps
        format.html { redirect_to edit_user_path, notice: 'interest_list is invlid'}

      elsif @user.update(ps)
        format.html { redirect_to posts_path, notice: 'User was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      ps = params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :bio, :interest_list)
      ps[:interest_list].split(%r{[(,\s*)|s*]}).each do |tag|
        if ActsAsTaggableOn::Tag.where(name:tag) == []
          return false
        end
      end
      ps
    end
end
