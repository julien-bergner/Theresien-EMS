class DanceTrainingRegistrationsController < ApplicationController
  # GET /dance_training_registrations
  # GET /dance_training_registrations.json
  def index
    @dance_training_registrations = DanceTrainingRegistration.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @dance_training_registrations }
    end
  end

  # GET /dance_training_registrations/1
  # GET /dance_training_registrations/1.json
  def show
    @dance_training_registration = DanceTrainingRegistration.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dance_training_registration }
    end
  end

  # GET /dance_training_registrations/new
  # GET /dance_training_registrations/new.json
  def new
    @dance_training_registration = DanceTrainingRegistration.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dance_training_registration }
    end
  end

  # GET /dance_training_registrations/1/edit
  def edit
    @dance_training_registration = DanceTrainingRegistration.find(params[:id])
  end

  # POST /dance_training_registrations
  # POST /dance_training_registrations.json
  def create
    @dance_training_registration = DanceTrainingRegistration.new(params[:dance_training_registration])

    respond_to do |format|
      if @dance_training_registration.save
        format.html { redirect_to @dance_training_registration, notice: 'Dance training registration was successfully created.' }
        format.json { render json: @dance_training_registration, status: :created, location: @dance_training_registration }
      else
        format.html { render action: "new" }
        format.json { render json: @dance_training_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /dance_training_registrations/1
  # PUT /dance_training_registrations/1.json
  def update
    @dance_training_registration = DanceTrainingRegistration.find(params[:id])

    respond_to do |format|
      if @dance_training_registration.update_attributes(params[:dance_training_registration])
        format.html { redirect_to @dance_training_registration, notice: 'Dance training registration was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dance_training_registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dance_training_registrations/1
  # DELETE /dance_training_registrations/1.json
  def destroy
    @dance_training_registration = DanceTrainingRegistration.find(params[:id])
    @dance_training_registration.destroy

    respond_to do |format|
      format.html { redirect_to dance_training_registrations_url }
      format.json { head :no_content }
    end
  end
end
