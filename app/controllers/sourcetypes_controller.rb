class SourcetypesController < ApplicationController
  before_action :set_sourcetype, only: [:show, :edit, :update, :destroy]

  # GET /sourcetypes
  # GET /sourcetypes.json
  def index
    @sourcetypes = Sourcetype.all
  end

  # GET /sourcetypes/1
  # GET /sourcetypes/1.json
  def show
  end

  # GET /sourcetypes/new
  def new
    @sourcetype = Sourcetype.new
  end

  # GET /sourcetypes/1/edit
  def edit
  end

  # POST /sourcetypes
  # POST /sourcetypes.json
  def create
    @sourcetype = Sourcetype.new(sourcetype_params)

    respond_to do |format|
      if @sourcetype.save
        format.html { redirect_to @sourcetype, notice: 'Sourcetype was successfully created.' }
        format.json { render :show, status: :created, location: @sourcetype }
      else
        format.html { render :new }
        format.json { render json: @sourcetype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sourcetypes/1
  # PATCH/PUT /sourcetypes/1.json
  def update
    respond_to do |format|
      if @sourcetype.update(sourcetype_params)
        format.html { redirect_to @sourcetype, notice: 'Sourcetype was successfully updated.' }
        format.json { render :show, status: :ok, location: @sourcetype }
      else
        format.html { render :edit }
        format.json { render json: @sourcetype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sourcetypes/1
  # DELETE /sourcetypes/1.json
  def destroy
    @sourcetype.destroy
    respond_to do |format|
      format.html { redirect_to sourcetypes_url, notice: 'Sourcetype was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sourcetype
      @sourcetype = Sourcetype.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sourcetype_params
      params.require(:sourcetype).permit(:sourcetype)
    end
end
