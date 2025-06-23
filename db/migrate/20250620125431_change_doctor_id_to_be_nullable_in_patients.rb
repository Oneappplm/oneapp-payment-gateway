class ChangeDoctorIdToBeNullableInPatients < ActiveRecord::Migration[7.1]
  def change
    change_column_null :patients, :doctor_id, true
  end
end
