# spec/integration/doctors_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/doctors', type: :request do
  path '/api/v1/doctors' do
    get('list doctors') do
      tags 'Doctors'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end

    # post('create doctor') do
    #   tags 'Doctors'
    #   consumes 'application/json'
    #   parameter name: :doctor, in: :body, schema: {
    #     type: :object,
    #     properties: {
    #       first_name: { type: :string },
    #       last_name: { type: :string },
    #       specialty: { type: :string },
    #       license_number: { type: :string },
    #       email: { type: :string },
    #       phone: { type: :string },
    #       clinic_name: { type: :string },
    #       clinic_address: { type: :string },
    #       location: { type: :string },
    #       user_id: { type: :integer }
    #     },
    #     required: ['first_name', 'last_name', 'email', 'user_id']
    #   }

    #   response(201, 'created') do
    #     let(:doctor) do
    #       {
    #         first_name: 'Alice',
    #         last_name: 'Smith',
    #         specialty: 'Cardiology',
    #         email: 'alice@example.com',
    #         phone: '1234567890',
    #         clinic_name: 'Heart Care',
    #         clinic_address: '456 Lane',
    #         location: 'NY',
    #         user_id: 1
    #       }
    #     end
    #     run_test!
    #   end
    # end
  end

  path '/api/v1/doctors/{id}' do
    get('show doctor') do
      tags 'Doctors'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response(200, 'found') do
        let(:id) { Doctor.create(first_name: 'A', last_name: 'B', email: 'a@b.com', user_id: 1).id }
        run_test!
      end
    end

    patch('update doctor') do
      tags 'Doctors'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :doctor, in: :body, schema: {
        type: :object,
        properties: {
          phone: { type: :string }
        }
      }

      response(200, 'updated') do
        let(:id) { Doctor.create(first_name: 'Update', last_name: 'Me', email: 'update@me.com', user_id: 1).id }
        let(:doctor) { { phone: '9876543210' } }
        run_test!
      end
    end
  end
end
