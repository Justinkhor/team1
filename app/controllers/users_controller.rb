class UsersController < Clearance::UsersController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login, only: [:show, :edit, :update, :destroy, :index]
  before_action :superadmin_only, only: [:index]
  before_action :authorize_check, only: [:update, :destroy]

    def new
        @user = User.new  # = user_from_params
        # render template: "users/new"
    end

    def create
        @user = User.new(user_params)
        if @user.save
            sign_in @user
            redirect_back_or url_after_create
        else
            render template: "users/new"
        end
    end

    def index
      @users = User.all
    end

    def edit
    end

    def show
      @bid = current_user.bids
      # unless current_user.superadmin
        # redirect_to root_path
      # end
    end

    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /items/1
    # DELETE /items/1.json
    def destroy
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
        format.json { head :no_content }
      end
    end

    private
    def set_user
      @user = User.find(params[:id])
    end

    def authorize_check
      if @user != current_user && !current_user.superadmin?
        redirect_to root_path
      end
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :username, :age, :gender, :state, :email, :password, :vice)
    end

    def superadmin_only
      redirect_to sign_in_path unless current_user.superadmin?
    end

end
