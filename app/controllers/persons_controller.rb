require 'csv'

class PersonsController < ApplicationController
	
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

	# POST /persons/bulk_upload.json
	def bulk_upload
		person_data = []

		CSV.parse(person_params[:person_data], headers: true) do |row|
			person_data << row.to_hash
		end

		@persons = Person.create(person_data)

		respond_to do |format|
			format.json { render collected_success_json_response }
		end
	end

	private

	# Never trust parameters from the scary internet, only allow the white list through.
	def person_params
		params.require(:person).permit(:first_name, :last_name, :email, :phone, :person_data)
	end

	# Collected persons response
	def collected_success_json_response
		person_response = @persons.collect do |person| 
			{ 
				first_name: person.first_name,
				last_name: person.last_name,
				email: person.email,
				phone: person.phone,
				has_error: !person.valid?, 
				error_message: person.error_message
			}
		end
		
		{
			json: { person_data: person_response }.to_json,
			status: :created
		}
	end

	# Collected person response
	def success_json_response
		{ 
			json: JSON.parse(@person.to_json).merge!({ has_error: !@person.valid? }).to_json,
			status: :created
		}
	end

	# Collected person error response
	def error_json_response
		{ 
			json: { 
				has_error: !@person.valid?, 
				error_message: @person.error_message
			}.to_json, 
			
			status: :unprocessable_entity 
		}
	end
end
