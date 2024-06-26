class Api::V1::VotersController < ApplicationController
 
  require "csv"
  # GET /voters
  def index
    puts params
     ballot_id = params[:ballot_id]
     @ballot = Ballot.find(ballot_id)
     @voters = @ballot.voters

    render json: @voters
  end

  # GET /voters/1
  def show
   
    voter_id  = params[:id]
    @voter = Voter.find(voter_id)
    render json: @voter
  end

  # POST /voters
  def create
    first_name = params[:voter][:first_name]
    last_name = params[:voter][:last_name]
    email = params[:voter][:email]
    ballot_id = params[:ballot_id]
    @voter = Voter.new(first_name:first_name,last_name:last_name,email: email,ballot_id:ballot_id)

    if @voter.save
      render json: {message:"success"}, status: :created
    else
      render json: {errors:@voter.errors.full_messages}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /voters/1
  def update
    first_name = params[:voter][:first_name]
    last_name = params[:voter][:last_name]
    email = params[:voter][:email]
    @voter = Voter.find(params[:id])
    if @voter.update(email:email,first_name:first_name,last_name:last_name)
      render json: {message:"success"}
    else
      render json: {errors:@voter.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def upload
    puts params
    ballot_id = params[:ballot_id]
    cleaned_csv =clean_csv(params[:csv_file])
    puts 10
    message = createvoters(cleaned_csv)
    if message == "added"
      render json: {message: "Voters Added successfully"}.as_json()
    else
      render json: {errors: "Your Record contains an already added voter.New voters were added"}.as_json()
    end

  end
  # DELETE /voters/1
  def destroy
    id = params[:id]
    @voter = Voter.find(id)
    if @voter.destroy!
      render json: {message:"success"}
    end 
  end

   private
    def clean_csv(file)
        csv=CSV.read(file)
        cleared_csv = csv.map{|row| row.compact }.reject{|row| row.empty?}
        array =[]
        cleared_csv.each_with_index do |row,i|
            if i == 0
                next 
            end 
            array << row 
        end
        return array 
    end

    def createvoters(array)
      ballot_id = params[:ballot_id]
        begin
            array.each do |voter|
                first_name = voter[0]
                last_name = voter[1]
                email = voter[2]
                 obj = Voter.create(first_name: first_name,last_name: last_name,email: email,ballot_id:ballot_id)

                 
            end 
            "added"
        rescue Exception 
            return nil 
        end
    end 


end
