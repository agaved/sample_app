class UsersController < ApplicationController
	before_filter :signed_in_user, 	only: [:index, :edit, :update, :destroy]
	before_filter :correct_user, 	only: [:edit, :update]
	before_filter :admin_user, 		only: :destroy

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

	def new
		@user = User.new
		redirect_to(root_path) if signed_in?
	end

	def create
		@user = User.new(params[:user])
		redirect_to(root_path) if signed_in?
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			# Handle a successful update
			flash[:success] = "Profile updated"
			sign_in @user
			redirect_to @user
		else
			render 'edit'
		end			
	end

	def destroy
		@user = User.find(params[:id])
		if (current_user? @user) && current_user.admin?
			flash[:error] = "As admin you cannot destroy yourself."
		else
			@user.destroy
			flash[:success] = "User destroyed. ID: #{@user.id}"
		end
		redirect_to users_url
	end

	def index
		@users = User.paginate(page: params[:page])
	end

	private

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end