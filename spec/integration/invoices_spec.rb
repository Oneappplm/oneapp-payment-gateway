# spec/integration/invoices_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/invoices', type: :request do
  path '/api/v1/invoices' do
    get('list invoices') do
      tags 'Invoices'
      produces 'application/json'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create invoice') do
      tags 'Invoices'
      consumes 'application/json'
      parameter name: :invoice, in: :body, schema: {
        type: :object,
        properties: {
          doctor_id: { type: :integer },
          patient_id: { type: :integer },
          service_name: { type: :string },
          amount: { type: :number },
          discount: { type: :number },
          tax: { type: :number },
          payment_method: { type: :string },
          status: { type: :string },
          conversion_rate: { type: :number },
          blockchain_network: { type: :integer },
          sender_wallet_address: { type: :string },
          receiver_wallet_address: { type: :string }
        },
        required: ['doctor_id', 'patient_id', 'service_name', 'amount']
      }

      response(201, 'created') do
        let(:invoice) do
          {
            doctor_id: 1,
            patient_id: 1,
            service_name: 'Consultation',
            amount: 500,
            discount: 50,
            tax: 20,
            payment_method: 'medv_token',
            conversion_rate: 10,
            blockchain_network: 1,
            sender_wallet_address: 'SENDER123',
            receiver_wallet_address: 'RECEIVER456'
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/invoices/{id}' do
    get('show invoice') do
      tags 'Invoices'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response(200, 'found') do
        let(:id) { Invoice.create(service_name: 'X', doctor_id: 1, patient_id: 1, amount: 100).id }
        run_test!
      end
    end

    patch('update invoice') do
      tags 'Invoices'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :invoice, in: :body, schema: {
        type: :object,
        properties: {
          status: { type: :string },
          solana_signature: { type: :string }
        }
      }

      response(200, 'updated') do
        let(:id) { Invoice.create(service_name: 'Y', doctor_id: 1, patient_id: 1, amount: 200).id }
        let(:invoice) { { status: 'Paid', solana_signature: 'TXSIGN123456' } }
        run_test!
      end
    end
  end
end
