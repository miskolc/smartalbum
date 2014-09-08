class SubCategoriesController < ApplicationController
  before_action :redirect_if_not_signed_in
  before_action :set_user
  before_action :set_category

  def create
    @category.sub_categories.create(sub_category_params)   
    redirect_to user_category_url @user, @category
  end

  def destroy
    @sub_category = @category.sub_categories.find(params[:id])
    @sub_category.destroy
    redirect_to user_category_url @user, @category
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

    def set_category
      @category = @user.categories.find(params[:category_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_category_params
      params.require(:sub_category).permit(:name)
    end
end
