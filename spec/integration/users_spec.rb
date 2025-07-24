# spec/integration/users_spec.rb
require 'swagger_helper'

RSpec.describe '/api/v1/users/register', type: :request do
  path '/api/v1/users' do
    get('list users') do
      tags 'Users'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end
  end

  path '/api/v1/users' do
    post 'Register a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              user_role: { type: :string, enum: ['doctor', 'patient'] }
            },
            required: %w[email password password_confirmation user_role]
          },
          doctor: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              specialty: { type: :string },
              email: { type: :string },
              phone: { type: :string },
              clinic_name: { type: :string },
              clinic_address: { type: :string },
              location: { type: :string }
            }
          },
          patient: {
            type: :object,
            properties: {
              first_name: { type: :string },
              last_name: { type: :string },
              phone_number: { type: :string },
              dob: { type: :string, format: :date }
            }
          }
        }
      }

      response '201', 'user created' do
        let(:user) do
          {
            user: {
              email: 'doc@example.com',
              password: 'password123',
              password_confirmation: 'password123',
              user_role: 'doctor'
            },
            doctor: {
              first_name: 'John',
              last_name: 'Doe',
              specialty: 'Dermatology',
              email: 'doc@example.com',
              phone: '1234567890',
              clinic_name: 'Skin Clinic',
              clinic_address: '123 Main Street',
              location: 'City A'
            }
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) do
          {
            user: {
              email: 'bademail',
              password: 'short',
              password_confirmation: 'short',
              user_role: 'doctor'
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    get('show user') do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response(200, 'found') do
        let(:id) { User.create(first_name: 'A', last_name: 'B', email: 'a@b.com', user_id: 1).id }
        run_test!
      end
    end
  end
end

