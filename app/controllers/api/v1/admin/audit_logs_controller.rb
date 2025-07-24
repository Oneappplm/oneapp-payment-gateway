class Api::V1::Admin::AuditLogsController < ApplicationController
  def index
    logs = AuditLog.order(created_at: :desc).limit(100)
    render json: logs, each_serializer: AuditLogSerializer
  end
end
