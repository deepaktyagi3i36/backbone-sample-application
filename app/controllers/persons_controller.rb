require 'csv'

class PersonsController < ApplicationController
	# GET /persons
  # GET /persons.json
  def index
    @persons = Person.all
  end

	# POST /persons.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.json { render success_json_response }
      else
        format.json { render error_json_response }
      end
    end
  end

	def bulk_upload
    data = []

    CSV.parse(person_params[:person_data], headers: true) do |row|
      data << row.to_hash
    end

    data.each do |p|
      person = Person.new(p)
      if person.save
        p[:id] = person.id
        p[:has_error] = false
      else
        p[:has_error] = true
        p[:error_message] = person.errors.full_messages
      end
    end

    respond_to do |format|
      format.json { render json: { data: data }.to_json, status: :ok }
    end
  end

	private
	
		# Never trust parameters from the scary internet, only allow the white list through.
		def person_params
			params.require(:person).permit(:first_name, :last_name, :email, :phone, :person_data)
		end

    def success_json_response
      { 
        json: JSON.parse(@person.to_json).merge!({ has_error: false }).to_json,
        status: :created
      }
    end

    def error_json_response
      { 
        json: { 
          has_error: @person.has_error, 
          error_message: @person.error_message
        }.to_json, 
        
        status: :unprocessable_entity 
      }
    end
end
