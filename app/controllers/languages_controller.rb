class LanguagesController < ApplicationController
  before_action :set_language, only: [:show, :edit, :update, :destroy, :feeds]
  
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
    # If no user is logged in
    if !current_user
      # Check whether the modal has been triggered
      if @submittagresults
        @selectedfeeds = @allfeeds.where(id: @submittagresults).take(3)
        @otherfeedsavailable = @allfeeds.where.not(id: @submittagresults)
      else
        # If the modal has been submitted blank, 
        @selectedfeeds = @allfeeds.where(defaultbool: true)
        @otherfeedsavailable = @allfeeds.where(defaultbool: false)
      end
      # We now know that there is a user logged in.
    else
      # Does user have any existing subs?
      @usersubscriptions = Subscription.where(user_id: current_user.id, language_id: @language)
      authorize! :create, :read, :update, :destroy, @usersubscriptions if can? :create, :read, :update, :destroy, @usersubscriptions
      # If user has no existing subs, show the defaults.
      if @usersubscriptions.empty?
          # We need to listen to any modal events for the first maximum three saved choices. If the modal load button hasn't been pressed...
          if @submittagresults.nil?
            # ...show the defaults.
            @selectedfeeds = @allfeeds.where(defaultbool: true)
            @otherfeedsavailable = @allfeeds.where(defaultbool: false)
            # If the modal button has been pressed, these will be the user's first saved choices. It doesn't matter whether there are 1, 2, 3. If there are nil, the logic should go back to displaying the defaults. 
          else
            @selectedfeeds = @allfeeds.where(id: @submittagresults).take(3)
            @otherfeedsavailable = @allfeeds.where.not(id: @submittagresults)
            x = 0
            while x < @selectedfeeds.length
              # Simply add whatever choices there are to the database and to the the twitter feed shown on the page.
              Subscription.create(user_id: current_user.id, preloadsource_id: @submittagresults[x], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[x]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[x]).pluck(:preloadsourceurl)[0])
              x += 1
            end
          end
      # We now know that there are subs in the database attached to this user.
      else
        @usersubIDs = []
        @usersubscriptions.each do |i|
          @usersubIDs.push(i.preloadsource_id)
        end
        # @selectedfeeds = @allfeeds.where(id: @usersubIDs)
        # @otherfeedsavailable = @allfeeds.where.not(id: @usersubIDs)
        # Has the user triggered the modal?
        if !@submittagresults
          #If not, show user's database existing entries associated with this language.
          @selectedfeeds = @allfeeds.where(id: @usersubIDs)
          @otherfeedsavailable = @allfeeds.where.not(id: @usersubIDs)
        # Now we're dealing with post modal events where the load button is pressed, whether or not this changes the user's choices.
        else
          # Have the user's choices changed?
          if @submittagresults == @usersubIDs
            #If no, we simply reflect their existing choices. This applies whether they have 1, 2 or 3 choices saved.
            @selectedfeeds = @allfeeds.where(id: @usersubIDs)
            @otherfeedsavailable = @allfeeds.where.not(id: @usersubIDs)
          else
            # If they have changed, we need to test whether we are dealing with three new choices to replace three in the database. We will deal with the scenario where they INCREASE to three later.
            @selectedfeeds = @allfeeds.where(id: @usersubIDs)
            @otherfeedsavailable = @allfeeds.where.not(id: @usersubIDs)
            if @submittagresults.length == 3 && @usersubscriptions.length == 3
            # If yes, update the three subs on file to reflect changes. Loop through the user's existing subs, testing each one against the three choices from the modal: - 
              x = 0
              while x < 3
                Subscription.find_by(id: @usersubscriptions.pluck(:id)[x]).update(preloadsource_id: @submittagresults[x], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[x]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[x]).pluck(:preloadsourceurl)[0])
                x += 1
              end
              # Then, reassign variables to determine user's new subs and then what gets shown in the feeds partial: -
              @usersubIDs.clear
              @usersubscriptions = Subscription.where(user_id: current_user.id, language_id: @language)
              @usersubscriptions.each do |i|
                @usersubIDs.push(i.preloadsource_id)
              end
              @selectedfeeds = @allfeeds.where(id: @usersubIDs)
              @otherfeedsavailable = @allfeeds.where.not(id: @usersubIDs)
            # Now we're dealing with fewer than three feeds. We've dealt with the scenario where the user has no subs saved, so we're dealing with either 1 or 2 in the database... 
            else   
            #...we need to test whether the number chosen is fewer than, greater than or equal to what is saved in the database. If the number submitted from the modal is less than what's in the database: -              
              if @submittagresults.length < @usersubIDs.length
              # There only two such cases: where the user has 1 sub with nothing submitted from the modal, or 2 subs with only one new choice has beeen selected.
                case @submittagresults.length
                # If the modal is submitted blank...
                when 0
                  #...delete all the user's subs related to that language and revert to the defaults...
                  x = 0
                  while x < 3
                    Subscription.find_by(preloadsource_id: @usersubIDs[x]).destroy
                    x += 1
                  end
                    @selectedfeeds = @allfeeds.where(defaultbool: true)
                    @otherfeedsavailable = @allfeeds.where(defaultbool: false)
                # We now know that the user has submitted data from the modal. They can only have submitted 1 or 2 choices (not 3, because that is the maximum anyway). If they submit only one choice...
                when 1, 2
                  # There may be two or three in the database. Update the first...  
                  Subscription.find_by(id: @usersubscriptions.pluck(:id)[0]).update(preloadsource_id: @submittagresults[0], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourceurl)[0])
                  #... and deleted the second (and third, if it exists): -
                  x = 1
                  while x < 3
                    Subscription.find_by(preloadsource_id: @usersubIDs[x]).destroy
                    x += 1
                  end
                  # Then, reassign variables to determine user's new subs and then what gets shown in the feeds partial: -
                  @usersubIDs.clear
                  @usersubscriptions = Subscription.where(user_id: current_user.id, language_id: @language)
                  @usersubscriptions.each do |i|
                    @usersubIDs.push(i.preloadsource_id)
                  end
                  @selectedfeeds = @allfeeds.where(id: @usersubIDs)
                  @otherfeedsavailable = @allfeeds.where.not(id: @usersubIDs)
                end
              # That deals with all scenarios in which the user's modal choices are fewer than what's in the database. Are their new choices greater in number than what's in the database? 
              elsif @submittagresults.length > @usersubIDs.length
                # This can only mean 1 sub in the database, with 2 or 3 chosen from the modal, or 2 subs in the database with 3 chosen from the modal. 
                if @usersubIDs.length == 1
                  # Now test this against what comes back from the modal, either 2 or 3.
                  case @submittagresults.length
                  # With database 1 modal 2...
                  when 2
                    #...update the first...
                    Subscription.find_by(id: @usersubscriptions.pluck(:id)[0]).update(preloadsource_id: @submittagresults[0], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourceurl)[0])
                    #...and create a new one.
                    Subscription.create(user_id: current_user.id, preloadsource_id: @submittagresults[1], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[1]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[1]).pluck(:preloadsourceurl)[0])
                  # With database 1 modal 3...
                  when 3
                    #...update the first...
                    Subscription.find_by(id: @usersubscriptions.pluck(:id)[0]).update(preloadsource_id: @submittagresults[0], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourceurl)[0])
                    #...and create two new ones.
                    Subscription.create(user_id: current_user.id, preloadsource_id: @submittagresults[1], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[1]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[1]).pluck(:preloadsourceurl)[0])
                    Subscription.create(user_id: current_user.id, preloadsource_id: @submittagresults[2], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[2]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[2]).pluck(:preloadsourceurl)[0])
                  end
                  # Then, reassign variables to determine user's new subs and then what gets shown in the feeds partial: -
                  @usersubIDs.clear
                  @usersubscriptions = Subscription.where(user_id: current_user.id, language_id: @language)
                  @usersubscriptions.each do |i|
                    @usersubIDs.push(i.preloadsource_id)
                  end
                  @selectedfeeds = @allfeeds.where(id: @usersubIDs)
                  @otherfeedsavailable = @allfeeds.where.not(id: @usersubIDs)
                # The only other possibility now is 3 from the modal, with 2 in the database, so...
                else
                  #...update the first two...
                  Subscription.find_by(id: @usersubscriptions.pluck(:id)[0]).update(preloadsource_id: @submittagresults[0], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourceurl)[0])
                  Subscription.find_by(id: @usersubscriptions.pluck(:id)[1]).update(preloadsource_id: @submittagresults[1], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[1]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[1]).pluck(:preloadsourceurl)[0])
                  #...and create a third...
                  Subscription.create(user_id: current_user.id, preloadsource_id: @submittagresults[2], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[2]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[2]).pluck(:preloadsourceurl)[0])
                  # Then, reassign variables to determine user's new subs and then what gets shown in the feeds partial: -
                  @usersubIDs.clear
                  @usersubscriptions = Subscription.where(user_id: current_user.id, language_id: @language)
                  @usersubscriptions.each do |i|
                    @usersubIDs.push(i.preloadsource_id)
                  end
                  @selectedfeeds = @allfeeds.where(id: @usersubIDs)
                  @otherfeedsavailable = @allfeeds.where.not(id: @usersubIDs)
                end
              # Or, their new choices are the same number than what's in the database, but not the same choices. 
              else
                # Simply update them, whether it is one or two choices. Remember we are still dealing with fewer than three existing choices, i.e 1 or 2.
                case @submittagresults.length
                when 1
                  Subscription.find_by(id: @usersubscriptions.pluck(:id)[0]).update(preloadsource_id: @submittagresults[0], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourceurl)[0])
                else                               
                  Subscription.find_by(id: @usersubscriptions.pluck(:id)[1]).update(preloadsource_id: @submittagresults[0], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[0]).pluck(:preloadsourceurl)[0])
                  Subscription.find_by(id: @usersubscriptions.pluck(:id)[2]).update(preloadsource_id: @submittagresults[1], language_id: @language.id, preloadsourcename: @allfeeds.where(id: @submittagresults[1]).pluck(:preloadsourcename)[0], preloadsourceurl: @allfeeds.where(id: @submittagresults[1]).pluck(:preloadsourceurl)[0])
                end
                # Then, reassign variables to determine user's new subs and then what gets shown in the feeds partial: -
                @usersubIDs.clear
                @usersubscriptions = Subscription.where(user_id: current_user.id, language_id: @language)
                @usersubscriptions.each do |i|
                  @usersubIDs.push(i.preloadsource_id)
                end
                @selectedfeeds = @allfeeds.where(id: @usersubIDs)
                @otherfeedsavailable = @allfeeds.where.not(id: @usersubIDs)
              # That deals with every scenario in which the user has changed their existing choices.
              end
            # That deals with every scenario in which the user has got fewer than three subs saved.
            end  
          # End of test as to whether there are any changes to user's saved subs.              
          end
        # End of test as to whether the modal load button has been pressed.
        end
      # End of test as to whether current_user has any subs saved in the database.
      end
    # End of current_user presence test
    end
  #end of def show
  end 

  # GET /languages/new
  # def new
  #   @language = Language.new
  # end

  # GET /languages/1/edit
  # def edit
  # end

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
  # def update
  #   respond_to do |format|
  #     if @language.update(language_params)
  #       format.html { redirect_to @language, notice: 'Language was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @language }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @language.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /languages/1
  # DELETE /languages/1.json
  # def destroy
  #   @language.destroy
  #   respond_to do |format|
  #     format.html { redirect_to languages_url, notice: 'Language was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

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