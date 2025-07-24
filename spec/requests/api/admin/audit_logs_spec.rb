#spec/requests/api/admin/audit_logs_spec.rb

require 'swagger_helper'

RSpec.describe 'api/v1/admin/audit_logs', type: :request do
  path '/api/v1/admin/audit_logs' do
    get('list audit logs') do
      tags 'Admin Audit Logs'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            created_at: { type: :string, format: :date_time },
            action: { type: :string },
            action_type: { type: :string },
            details: { type: :string }
          },
          required: ['created_at', 'action', 'action_type', 'details']
        }

        run_test!
      end
    end
  end
end
