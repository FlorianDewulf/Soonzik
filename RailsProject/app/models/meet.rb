# The model of the object Meet
class Meet < ActiveRecord::Base
	belongs_to :user

	validates :email, presence: true, format: { with: /\A(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Z‌​a-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6}\z/i }

  # The strong parameters to save or update object
  def self.meet_params(parameters)
    parameters.require(:meet).permit(:location, :query, :profession, :what, :fromDate, :toDate, :email)
  end
end
