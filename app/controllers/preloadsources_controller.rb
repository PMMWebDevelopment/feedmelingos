class PreloadsourcesController < ApplicationController
  before_action :set_preloadsource, only: [:show, :edit, :update, :destroy]

  # GET /preloadsources
  # GET /preloadsources.json
  def index
    @preloadsources = Preloadsource.all
  end

  # GET /preloadsources/1
  # GET /preloadsources/1.json
  def show
  end

  # GET /preloadsources/new
  def new
    @preloadsource = Preloadsource.new
  end

  # GET /preloadsources/1/edit
  def edit
  end

  # POST /preloadsources
  # POST /preloadsources.json
  def create
    @preloadsource = Preloadsource.new(preloadsource_params)

    respond_to do |format|
      if @preloadsource.save
        format.html { redirect_to @preloadsource, notice: 'Preloadsource was successfully created.' }
        format.json { render :show, status: :created, location: @preloadsource }
      else
        format.html { render :new }
        format.json { render json: @preloadsource.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /preloadsources/1
  # PATCH/PUT /preloadsources/1.json
  def update
    respond_to do |format|
      if @preloadsource.update(preloadsource_params)
        format.html { redirect_to @preloadsource, notice: 'Preloadsource was successfully updated.' }
        format.json { render :show, status: :ok, location: @preloadsource }
      else
        format.html { render :edit }
        format.json { render json: @preloadsource.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /preloadsources/1
  # DELETE /preloadsources/1.json
  def destroy
    @preloadsource.destroy
    respond_to do |format|
      format.html { redirect_to preloadsources_url, notice: 'Preloadsource was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_preloadsource
      @preloadsource = Preloadsource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def preloadsource_params
      params.require(:preloadsource).permit(:preloadsourcename, :preloadsourceurl, :language_id, :sourcetype_id)
    end
end
