# spec/integration/invoices_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/invoices', type: :request do
  let(:doctor) { create(:doctor) }
  let(:patient) { create(:patient, doctor:) }
  let(:Authorization) { "Bearer #{doctor.user.jwt_token}" }

  path '/api/v1/doctors/{doctor_id}/invoices' do
    parameter name: :doctor_id, in: :path, type: :string
    # parameter name: :Authorization, in: :header, type: :string

    get('List invoices') do
      tags 'Invoices'
      produces 'application/json'

      response(200, 'successful') do
        let(:doctor_id) { doctor.id }

        before { create(:invoice, patient:) }

        run_test!
      end
    end
  end

  path '/api/v1/doctors/{doctor_id}/patients/{patient_id}/invoices' do
    parameter name: :doctor_id, in: :path, type: :string
    parameter name: :patient_id, in: :path, type: :string
    # parameter name: :Authorization, in: :header, type: :string

    post('Create invoice') do
      tags 'Invoices'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :invoice, in: :body, schema: {
        type: :object,
        properties: {
          service_name: { type: :string },
          service_description: { type: :text },
          amount: { type: :number },
          discount: { type: :decimal },
          clinic_name: { type: :string },
          date_of_service: { type: :date },
          due_date: { type: :date }
        },
        required: %w[service_name service_description amount discount clinic_name date_of_service due_date ]
      }

      response(201, 'created') do
        let(:doctor_id) { doctor.id }
        let(:patient_id) { patient.id }
        let(:invoice) { { amount: 150.0, status: 'unpaid' } }

        run_test!
      end

      response(422, 'unprocessable entity') do
        let(:doctor_id) { doctor.id }
        let(:patient_id) { patient.id }
        let(:invoice) { { amount: nil, status: '' } }

        run_test!
      end
    end
  end

  path '/api/v1/doctors/{doctor_id}/patients/{patient_id}/invoices/{id}' do
    parameter name: :doctor_id, in: :path, type: :string
    parameter name: :patient_id, in: :path, type: :string
    parameter name: :id, in: :path, type: :string
    # parameter name: :Authorization, in: :header, type: :string

    get('Show invoice') do
      tags 'Invoices'
      produces 'application/json'

      response(200, 'successful') do
        let(:invoice) { create(:invoice, patient:) }
        let(:doctor_id) { doctor.id }
        let(:patient_id) { patient.id }
        let(:id) { invoice.id }

        run_test!
      end
    end

    put('Update invoice') do
      tags 'Invoices'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :invoice, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number },
          service_name: { type: :string },
          service_description: { type: :text }
        }
      }

      response(200, 'updated') do
        let(:invoice_record) { create(:invoice, patient:) }
        let(:doctor_id) { doctor.id }
        let(:patient_id) { patient.id }
        let(:id) { invoice_record.id }
        let(:invoice) { { amount: 200.0, status: 'paid' } }

        run_test!
      end
    end

    delete('Delete invoice') do
      tags 'Invoices'

      response(204, 'deleted') do
        let(:invoice) { create(:invoice, patient:) }
        let(:doctor_id) { doctor.id }
        let(:patient_id) { patient.id }
        let(:id) { invoice.id }

        run_test!
      end
    end
  end
end
