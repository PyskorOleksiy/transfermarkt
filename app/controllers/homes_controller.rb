class HomesController < ApplicationController
  # GET /homes or /homes.json
  def index
    @homes = Home.all
  end

  # GET /homes/1 or /homes/1.json
  def show
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home_match = Home.find(params[:id])
  end

  # GET /homes/new
  def new
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
  end

  # GET /homes/1/edit
  def edit
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home = Home.find(params[:id])
  end

  # POST /homes or /homes.json
  def create
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home = @tournament_club.homes.create(home_params)

    respond_to do |format|
      if @home.save
        format.html { redirect_to tournament_club_path(@tournament_club), notice: "Home was successfully created." }
        format.json { render :show, status: :created, location: tournament_club_path(@tournament_club) }
      end
    end
  end

  # PATCH/PUT /homes/1 or /homes/1.json
  def update
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home = @tournament_club.homes.find(params[:id])
    respond_to do |format|
      if @home.update(home_params)
        format.html { redirect_to tournament_club_path(@tournament_club), notice: "Home was successfully updated." }
        format.json { render :show, status: :ok, location: tournament_club_path(@tournament_club) }
      end
    end
  end

  # DELETE /homes/1 or /homes/1.json
  def destroy
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @home = @tournament_club.homes.find(params[:id])
    @home.destroy
    respond_to do |format|
      format.html { redirect_to tournament_club_path(@tournament_club), notice: "Home was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private


    # Only allow a list of trusted parameters through.
    def home_params
      params.require(:home).permit(:tour, :match_date, :home_team, :result, :away_team, :tournament_club_id)
    end
end
