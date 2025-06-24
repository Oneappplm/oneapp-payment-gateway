class Admin::AuditLogsController < ApplicationController
  # before_action :authenticate_admin!

  def index
    @logs = AuditLog.order(created_at: :desc).limit(100)
  end
end
