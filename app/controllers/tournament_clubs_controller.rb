class TournamentClubsController < ApplicationController
  before_action :set_tournament_club, only: %i[ show edit update destroy ]

  # GET /tournaments or /tournaments.json
  def index
    @tournament_clubs_all = TournamentClub.all
    @tournament_clubs = TournamentClub.order(:place)
  end

  # GET /tournaments/1 or /tournaments/1.json
  def show
    @tournament_club = TournamentClub.find(params[:id])
  end

  # GET /tournaments/new
  def new
    @tournament_club = TournamentClub.new
  end

  # GET /tournaments/1/edit
  def edit
  end

  # POST /tournaments or /tournaments.json
  def create
    @tournament_club = TournamentClub.new(tournament_club_params)

    respond_to do |format|
      if @tournament_club.save
        format.html { redirect_to @tournament_club, notice: "Club was successfully created." }
        format.json { render :show, status: :created, location: @tournament_club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tournament_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tournaments/1 or /tournaments/1.json
  def update
    respond_to do |format|
      if @tournament_club.update(tournament_club_params)
        format.html { redirect_to @tournament_club, notice: "Club was successfully updated." }
        format.json { render :show, status: :ok, location: @tournament_club }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tournament_club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tournaments/1 or /tournaments/1.json
  def destroy
    #Tournament.delete_all
    @tournament_club.destroy
    respond_to do |format|
      format.html { redirect_to tournament_clubs_url, notice: "Club was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tournament_club
      @tournament_club = TournamentClub.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tournament_club_params
      params.require(:tournament_club).permit(:club, :points, :place)
    end
end
