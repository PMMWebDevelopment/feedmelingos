class LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy, :feeds]
  before_action :authenticate_user!
  
  # GET /languages
  # GET /languages.json
  def index
    @languages = Language.all
  end
  
  # GET /languages/1
  # GET /languages/1.json
  def show
    @allfeeds = Preloadsource.where(language: @language)
    @submittagresults = params[:feed_ids]
    @selectedfeeds = @allfeeds.where(defaultbool: true)
    @otherfeedsavailable = @allfeeds.where(defaultbool: false)
    if current_user
      # Does user have any existing subs?
      @usersubscriptions = Subscription.where(user_id: current_user.id, language_id: @language)
      if !@usersubscriptions 
        if @submittagresults
          @submittagresults.each do |submittagresult|
            if !Subscription.where(user_id: current_user.id, preloadsource_id: submittagresult)  
              Subscription.create(user_id: current_user.id, preloadsource_id: submittagresult, language_id: @language, preloadsourcename: @allfeeds.where(id: preloadsource_id).preloadsourcename, preloadsourceurl: @allfeeds.where(id: preloadsource_id).preloadsourceurl)
            end
          end
        end
      end
      @usersubIDs = []
      @usersubscriptions.each do |i|
        @usersubIDs.push(i.preloadsource_id)
      end
      @selectedfeeds = @allfeeds.where(id: @usersubIDs)
      @otherfieldsavailable = @allfeeds - @selectedfeeds
    else
      @selectedfeeds = @allfeeds.where(defaultbool: true)
      @otherfeedsavailable = @allfeeds.where(defaultbool: false)
    end
  end

  # GET /languages/new
  def new
    @language = Language.new
  end

  # GET /languages/1/edit
  def edit
  end

  # POST /languages
  # POST /languages.json
  def create
    # @language = Language.new(language_params)

    # respond_to do |format|
    #   if @language.save
    #     format.html { redirect_to @language, notice: 'Language was successfully created.' }
    #     format.json { render :show, status: :created, location: @language }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @language.errors, status: :unprocessable_entity }
    #   end
    # end
  end
  
  # PATCH/PUT /languages/1
  # PATCH/PUT /languages/1.json
  def update
    respond_to do |format|
      if @language.update(language_params)
        format.html { redirect_to @language, notice: 'Language was successfully updated.' }
        format.json { render :show, status: :ok, location: @language }
      else
        format.html { render :edit }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /languages/1
  # DELETE /languages/1.json
  def destroy
    @language.destroy
    respond_to do |format|
      format.html { redirect_to languages_url, notice: 'Language was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_language
      @language = Language.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def language_params
      params.permit(:language)
    end

end