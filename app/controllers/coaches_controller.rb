class CoachesController < ApplicationController
  # GET /coaches or /coaches.json
  def index
    @coaches = Coach.all
  end

  # GET /coaches/1 or /coaches/1.json
  def show
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
  end

  # GET /coaches/new
  def new
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
  end


  # GET /coaches/1/edit
  def edit
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
  end

  # POST /coaches or /coaches.json
  def create
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @coach = @tournament_club.build_coach(coach_params)
    respond_to do |format|
      if @coach.save
        format.html { redirect_to tournament_club_path(@tournament_club), notice: "Coach was successfully created." }
        format.json { render :show, status: :created, location: tournament_club_path(@tournament_club) }
      end
    end
  end

  # PATCH/PUT /coaches/1 or /coaches/1.json
  def update
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @coach = @tournament_club.coach
    respond_to do |format|
      if @coach.update(coach_params)
        format.html { redirect_to tournament_club_coach_path(@tournament_club), notice: "Coach was successfully updated." }
        format.json { render :show, status: :ok, location: tournament_club_coach_path(@tournament_club) }
      end
    end
  end

  # DELETE /coaches/1 or /coaches/1.json
  def destroy
    @tournament_club = TournamentClub.find(params[:tournament_club_id])
    @coach = @tournament_club.coach
    #Coach.delete_all
    @coach.destroy
     respond_to do |format|
      format.html { redirect_to tournament_club_coach_path(@tournament_club), notice: "Coach was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private


    # Only allow a list of trusted parameters through.
    def coach_params
      params.require(:coach).permit(:name, :contract_until, :age, :appointed, :preferred_formation, :average_term, :tournament_club_id, :country, :last_club, :achievements)
    end
end
