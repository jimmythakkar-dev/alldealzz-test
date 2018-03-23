class AddDisplayTimingsAndAppointmentMandatoryToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :display_timings, :boolean, default: false
    add_column :deals, :appointment_mandatory, :boolean, default: false
  end
end
