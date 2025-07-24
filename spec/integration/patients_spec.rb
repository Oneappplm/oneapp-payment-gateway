# spec/integration/patients_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/doctors/:doctor_id/patients', type: :request do
  let!(:doctor) { create(:user, user_role: 'doctor') }
  let!(:auth_token) { JsonWebToken.encode(user_id: doctor.id) }
  let(:Authorization) { "Bearer #{auth_token}" }

  path '/api/v1/doctors/{doctor_id}/patients' do
    parameter name: :doctor_id, in: :path, type: :string, description: 'Doctor ID'
    # parameter name: 'Authorization', in: :header, type: :string, required: true

    get('list patients') do
      tags 'Patients'
      produces 'application/json'

      response(200, 'successful') do
        let(:doctor_id) { doctor.id }
        before do
          create_list(:patient, 3, doctor:)
        end

        run_test!
      end
    end

    post('create patient') do
      tags 'Patients'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :patient, in: :body, schema: {
        type: :object,
        properties: {
          # user: {
          #   type: :object,
          #   properties: {
          #     email: { type: :string },
          #     password: { type: :string },
          #     password_confirmation: { type: :string },
          #     user_role: { type: :string, enum: ['patient'] }
          #   },
          #   required: ['email', 'password', 'password_confirmation', 'user_role']
          # },
          patient: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              phone_number: { type: :string },
              email_address: { type: :string }
            },
            required: ['first_name', 'last_name', 'phone_number']
          }
        }
      }

      response(201, 'created') do
        let(:doctor_id) { doctor.id }
        let(:patient) do
          {
            user: {
              email: 'patient1@example.com',
              password: 'password',
              password_confirmation: 'password',
              user_role: 'patient'
            },
            patient: {
              first_name: 'John',
              last_name: 'Doe',
              phone_number: '1234567890'
            }
          }
        end

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:doctor_id) { doctor.id }
        let(:patient) do
          {
            user: {
              email: '',
              password: '',
              password_confirmation: '',
              user_role: 'patient'
            },
            patient: {
              first_name: '',
              last_name: '',
              phone_number: ''
            }
          }
        end

        run_test!
      end
    end
  end

  path '/api/v1/doctors/{doctor_id}/patients/{id}' do
    parameter name: :doctor_id, in: :path, type: :string
    parameter name: :id, in: :path, type: :string
    # parameter name: 'Authorization', in: :header, type: :string, required: true

    get('show patient') do
      tags 'Patients'
      produces 'application/json'

      response(200, 'successful') do
        let(:doctor_id) { doctor.id }
        let(:patient_record) { create(:patient, doctor:) }
        let(:id) { patient_record.id }

        run_test!
      end
    end

    put('update patient') do
      tags 'Patients'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :patient, in: :body, schema: {
        type: :object,
        properties: {
          patient: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              phone_number: { type: :string }
            }
          }
        }
      }

      response(200, 'updated') do
        let(:doctor_id) { doctor.id }
        let(:patient_record) { create(:patient, doctor:) }
        let(:id) { patient_record.id }
        let(:patient) do
          {
            patient: {
              first_name: 'Updated',
              last_name: 'Patient',
              phone_number: '9876543210'
            }
          }
        end

        run_test!
      end
    end

    delete('delete patient') do
      tags 'Patients'
      produces 'application/json'

      response(204, 'deleted') do
        let(:doctor_id) { doctor.id }
        let(:patient_record) { create(:patient, doctor:) }
        let(:id) { patient_record.id }

        run_test!
      end
    end
  end
end

