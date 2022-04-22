class AwaysController < ApplicationController
  # GET /homes or /homes.json
  def index
    @aways = Away.all
  end

  # GET /homes/1 or /homes/1.json
  def show
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @away_match = Away.find(params[:id])
  end

  # GET /homes/new
  def new
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
  end

  # GET /homes/1/edit
  def edit
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @away = Away.find(params[:id])
  end

  # POST /homes or /homes.json
  def create
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @away = @tournament_club.away.create(away_params)

    respond_to do |format|
      if @away.save
        format.html { redirect_to tournament_club_path(@tournament_club), notice: "Away was successfully created." }
        format.json { render :show, status: :created, location: tournament_club_path(@tournament_club) }
      end
    end
  end

  # PATCH/PUT /homes/1 or /homes/1.json
  def update
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @away = @tournament_club.away.find(params[:id])
    respond_to do |format|
      if @away.update(away_params)
        format.html { redirect_to tournament_club_path(@tournament_club), notice: "Away was successfully updated." }
        format.json { render :show, status: :ok, location: tournament_club_path(@tournament_club) }
      end
    end
  end

  # DELETE /homes/1 or /homes/1.json
  def destroy
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @away = @tournament_club.away.find(params[:id])
    @away.destroy
    respond_to do |format|
      format.html { redirect_to tournament_club_path(@tournament_club), notice: "Away was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private


    # Only allow a list of trusted parameters through.
    def away_params
      params.require(:away).permit(:tour, :match_date, :home_team, :result, :away_team, :tournament_club_id)
    end
end
