class HomeMatchesController < ApplicationController
  # GET /homes or /homes.json
  def index
    @homes_matches = HomeMatch.all
  end

  # GET /homes/1 or /homes/1.json
  def show
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home_match = HomeMatch.find(params[:id])
  end

  # GET /homes/new
  def new
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
  end

  # GET /homes/1/edit
  def edit
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home_match = HomeMatch.find(params[:id])
  end

  # POST /homes or /homes.json
  def create
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home_match = @tournament_club.home_matches.create(home_match_params)

    respond_to do |format|
      if @home_match.save
        format.html { redirect_to tournament_club_path(@tournament_club), notice: "Home was successfully created." }
        format.json { render :show, status: :created, location: tournament_club_path(@tournament_club) }
      end
    end
  end

  # PATCH/PUT /homes/1 or /homes/1.json
  def update
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home_match = @tournament_club.home_matches.find(params[:id])
    respond_to do |format|
      if @home_match.update(home_match_params)
        format.html { redirect_to tournament_club_path(@tournament_club), notice: "Home was successfully updated." }
        format.json { render :show, status: :ok, location: tournament_club_path(@tournament_club) }
      end
    end
  end

  # DELETE /homes/1 or /homes/1.json
  def destroy
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home_match = @tournament_club.home_matches.find(params[:id])
    @home_match.destroy
    respond_to do |format|
      format.html { redirect_to tournament_club_path(@tournament_club), notice: "Home was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private


    # Only allow a list of trusted parameters through.
    def home_match_params
      params.require(:home_match).permit(:tour, :match_date, :home_team, :result, :away_team, :tournament_club_id)
    end
end
