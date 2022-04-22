class PlayersController < ApplicationController
  # GET /players or /players.json
  def index
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @players = Player.all
  end

  # GET /players/1 or /players/1.json
  def show
    @player = Player.find(params[:id])
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
  end

  # GET /players/new
  def new
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
  end
  # GET /players/1/edit
  def edit
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @player = Player.find(params[:id])
  end

  # POST /players or /players.json
  def create
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @player = @tournament_club.players.create(player_params)
    respond_to do |format|
      if @player.save
        format.html { redirect_to tournament_club_players_path(@tournament_club), notice: "Player was successfully created." }
        format.json { render :show, status: :created, location: tournament_club_players_path(@tournament_club) }
      end
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @player = @tournament_club.players.find(params[:id])
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to tournament_club_players_path(@tournament_club), notice: "Player was successfully updated." }
        format.json { render :show, status: :ok, location: tournament_club_players_path(@tournament_club) }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @player = @tournament_club.players.find(params[:id])
    #Player.delete_all
    @player.destroy
     respond_to do |format|
      format.html { redirect_to tournament_club_players_path(@tournament_club), notice: "Player was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:name, :position, :number, :age, :contract_until, :country, :market_value, :cost_type, :last_club, :tournament_club_id)
    end
end
