class CategoriesController < ApplicationController
  before_action :redirect_if_not_signed_in
  before_action :set_user


  def index
    @categories = @user.categories
    @new_category = @user.categories.build
  end  

  def create
    @user.categories.create(category_params)   
    redirect_to user_categories_url @user
  end

  def destroy
    @category = @user.categories.find(params[:id])
    @category.destroy
    redirect_to user_categories_url @user
  end  

  private

    def redirect_if_not_signed_in
      redirect_to root_url unless current_user
    end  

    def set_user
      @user = User.find(params[:user_id])
      if current_user.id != @user.id 
        redirect_to root_url
        # TODO verifica daca redirecteaza si mai adauga un notice flash prin care sa-l anunti ca a
        # folosit linkul altui user
      else 
        @user = current_user
      end    
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name)
    end
end
