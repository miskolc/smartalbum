class StaticPagesController < ApplicationController
  def home
    if current_user
      if current_user.images.size > 0
        redirect_to user_images_url(current_user)
      end  
    end
  end

  def about
  end
end
