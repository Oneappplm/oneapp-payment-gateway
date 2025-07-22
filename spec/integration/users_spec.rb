# spec/integration/users_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    post('create user') do
      tags 'Users'
      consumes 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        required: ['user'],
        properties: {
          user: {
            type: :object,
            required: ['email', 'password', 'password_confirmation', 'user_role'],
            properties: {
              email: { type: :string, format: :email },
              password: { type: :string, format: :password },
              password_confirmation: { type: :string, format: :password },
              user_role: { type: :string, enum: ['doctor', 'patient'] },
              # Optional common user fields can go here
            },
            oneOf: [
              {
                required: ['doctor_attributes'],
                properties: {
                  doctor_attributes: {
                    type: :object,
                    required: ['first_name', 'last_name', 'phone', 'license_number'],
                    properties: {
                      first_name: { type: :string },
                      last_name: { type: :string },
                      email: { type: :string },
                      phone: { type: :string },
                      specialty: { type: :string },
                      license_number: { type: :string },
                      clinic_name: { type: :string },
                      clinic_address: { type: :string },
                      location: { type: :string },
                      profile_picture: { type: :string, format: :binary }
                    }
                  }
                }
              },
              {
                required: ['patient_attributes'],
                properties: {
                  patient_attributes: {
                    type: :object,
                    required: ['first_name', 'last_name', 'phone_number', 'dob'],
                    properties: {
                      first_name: { type: :string },
                      last_name: { type: :string },
                      phone_number: { type: :string },
                      dob: { type: :string, format: :date }
                    }
                  }
                }
              }
            ]
          }
        }
      }

      response(201, 'created') do
        let(:user) do
          {
            user: {
              email: 'doctor@example.com',
              password: 'password',
              password_confirmation: 'password',
              user_role: 'doctor',
              doctor_attributes: {
                first_name: 'John',
                last_name: 'Doe',
                email: 'doctor@example.com',
                phone: '1234567890',
                specialty: 'Dermatology',
                license_number: 'DOC123',
                clinic_name: 'Health Clinic',
                clinic_address: '123 Clinic St',
                location: 'City',
                profile_picture: nil
              }
            }
          }
        end

        run_test!
      end

      response(422, 'invalid request') do
        let(:user) { { user: { email: 'bad_email' } } }
        run_test!
      end
    end
  end
end
