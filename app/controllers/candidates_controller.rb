class CandidatesController < ApplicationController
  # GET /candidates
  # GET /candidates.json
  
  before_filter :lookup_election
  
  def index
    @election = Election.find(params[:election_id])
    @candidates = @election.candidates

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @candidates }
      format.pdf do
        pdf = BallotPdf.new(@election)
        send_data pdf.render, filename: "election_ballots_#{@election.unit_number}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  # GET /candidates/1
  # GET /candidates/1.json
  def show
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @candidate }
    end
  end

  # GET /candidates/new
  # GET /candidates/new.json
  def new
    @candidate = Candidate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @candidate }
    end
  end

  # GET /candidates/1/edit
  def edit
    @candidate = Candidate.find(params[:id])
  end

  # POST /candidates
  # POST /candidates.json
  def create
    @candidate = Candidate.new(params[:candidate])

    @candidate.election = @election
    
    respond_to do |format|
      if @candidate.save
        format.html { redirect_to election_candidates_path(@election), notice: 'Candidate was successfully created.' }
        format.json { render json: @candidate, status: :created, location: @candidate }
      else
        format.html { render action: "new" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /candidates/1
  # PUT /candidates/1.json
  def update
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        format.html { redirect_to election_candidates_path(@election), notice: 'Candidate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidates/1
  # DELETE /candidates/1.json
  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy

    respond_to do |format|
      format.html { redirect_to election_candidates_url(@election) }
      format.json { head :no_content }
    end
  end
  
  private
  
  def lookup_election
    @election = Election.find(params[:election_id])
  end
end
