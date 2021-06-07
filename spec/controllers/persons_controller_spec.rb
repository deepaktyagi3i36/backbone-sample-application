require 'rails_helper'
require 'csv'

RSpec.describe PersonsController, type: :controller do
  let(:person_params) do
    {
      first_name: fname,
      last_name: lname,
      phone: phone,
      email: email,
    }
  end

  let(:success_json_response) do
    {
      'id' => 1, 
      'first_name' => fname, 
      'last_name' => lname, 
      'email' => email, 
      'phone' => phone, 
      'has_error' => false, 
      'error_message' => []
    }
  end

  let(:fname) { 'fname' }
  let(:lname) { 'lname' }
  let(:phone) { '+91787856479' }
  let(:email) { 'test@example.com' }

  describe "GET #index" do
    it "returns a success response" do
      Person.create! person_params
      get :index, {}
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Person" do
        expect {
          post :create, {:person => person_params}
        }.to change(Person, :count).by(1)
      end

      it "should get valid response" do
        post :create, {:person => person_params}
        
        expect(JSON.parse(response.body)).to eq(success_json_response)
      end
    end

    context "with invalid params" do
      
      context "when first_name if blank" do
        let(:fname) { nil }

        it "should return first_name blank error" do
          post :create, {:person => person_params}
  
          expect(JSON.parse(response.body)).to eq({
            'has_error' => true,
            'error_message' => ["First name can't be blank"]
          })  
        end
      end

      context "when last_name is blank" do
        let(:lname) { nil }

        it "should return last_name blank error" do
          post :create, {:person => person_params}
  
          expect(JSON.parse(response.body)).to eq({
            'has_error' => true,
            'error_message' => ["Last name can't be blank"]
          })  
        end
      end

      context "when email is blank" do
        let(:email) { nil }

        it "should return email blank error" do
          post :create, {:person => person_params}
  
          expect(JSON.parse(response.body)).to eq({
            'has_error' => true,
            'error_message' => ["Email should be valid"]
          })  
        end
      end

      context "when email is invalid" do
        let(:email) { 'invalidemail' }

        it "should return email blank error" do
          post :create, {:person => person_params}
  
          expect(JSON.parse(response.body)).to eq({
            'has_error' => true,
            'error_message' => ["Email should be valid"]
          })  
        end
      end

      context "when phone is blank" do
        let(:phone) { nil }

        it "should return phone blank error" do
          post :create, {:person => person_params}
  
          expect(JSON.parse(response.body)).to eq({
            'has_error' => true,
            'error_message' => ["Phone should be numbers and prefixed with +"]
          })  
        end
      end

      context "when phone is invalid" do
        let(:phone) { '99099090009' }

        it "should return phone blank error" do
          post :create, {:person => person_params}
  
          expect(JSON.parse(response.body)).to eq({
            'has_error' => true,
            'error_message' => ["Phone should be numbers and prefixed with +"]
          })  
        end
      end
    end
  end

  describe "POST #bulk_upload" do
    
    let(:csv_header) {
      ['first_name', 'last_name', 'email', 'phone']
    }

    let(:csv_valid_data) {
      ['fname', 'lname', 'test@example.com', '+919999887765']
    }

    let(:csv_invalid_data) {
      ['fname', 'lname', 'invalid_email', '+919999887765']
    }


    let(:valid_response) {
      {
        'first_name' => 'fname',
        'last_name' => 'lname',
        'email' => 'test@example.com',
        'phone' => '+919999887765',
        'has_error' => false, 
        'error_message' => []
      }
    }

    let(:invalid_response) {
      {
        'first_name' => 'fname',
        'last_name' => 'lname',
        'email' => 'invalid_email',
        'phone' => '+919999887765',
        'has_error' => true, 
        'error_message' => ['Email should be valid']
      }
    }
    
    context "when csv data string having valid data" do
      
      let(:valid_csv_string_data) {
        csv_header.to_csv + csv_valid_data.to_csv
      }

      it "should return success json response" do
        post :bulk_upload, {:person => { person_data: valid_csv_string_data} }
        
        expect(JSON.parse(response.body)).to eq({
          'person_data' => [
              valid_response
            ]
          })
      end
    end

    context "when csv data string having invalid data" do
      
      let(:invalid_csv_string_data) {
        csv_header.to_csv + csv_invalid_data.to_csv
      }

      it "should return success json response" do
        post :bulk_upload, {:person => { person_data: invalid_csv_string_data} }
        
        expect(JSON.parse(response.body)).to eq({
          'person_data' => [
              invalid_response
            ]
          })
      end
    end

    context "when csv data string having valid and invalid data" do
      
      let(:csv_string_data) {
        csv_header.to_csv + csv_valid_data.to_csv + csv_invalid_data.to_csv
      }

      it "should return success json response" do
        post :bulk_upload, {:person => { person_data: csv_string_data} }
        
        expect(JSON.parse(response.body)).to eq({
          'person_data' => [
              valid_response,
              invalid_response
            ]
          })
      end
    end
  end
end
