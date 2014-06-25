class CategoriesController < ApplicationController
  before_action :redirect_if_not_signed_in
  before_action :set_user


  def index
    @categories = Category.all
  end  

  def destroy
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
    # def image_params
    #   params.require(:image).permit(:user_id, :store, :category_id)
    # end
end
