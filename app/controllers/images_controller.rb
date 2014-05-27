class ImagesController < ApplicationController
  before_action :redirect_if_not_signed_in
  before_action :set_user
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = @user.images.paginate page: params[:page]
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @faces = @image.faces
    @delta_height = (500 - (@image.normal_height || 0)) / 2
    @delta_width  = (1000 - (@image.normal_width || 0)) / 2
  end

  # GET /images/new
  def new
    @image = @user.images.build
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    @user = current_user
    @image = @user.images.build(image_params)

    respond_to do |format|
      if @image.save
        ImageDataMiner.perform_async(@image.id)
        format.html { redirect_to [current_user, @image], notice: 'Image was successfully created.' }
        format.json { render action: 'show', status: :created, location: @image }
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update

    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to [current_user, @image], notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to user_images_url }
      format.json { head :no_content }
    end
  end

  # GET /images/1/data
  def data
    @image = @user.images.find(params[:image_id])
    @exif_fields = @image.exif_fields
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

    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = @user.images.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:user_id, :store)
    end
end
