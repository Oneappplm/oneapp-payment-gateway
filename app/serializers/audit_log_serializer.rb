# app/serializers/audit_log_serializer.rb
class AuditLogSerializer < ActiveModel::Serializer
  attributes :created_at, :action, :action_type, :details
end
