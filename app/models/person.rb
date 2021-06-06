class Person < ActiveRecord::Base
  attr_accessor :has_error, :error_message

	validates :first_name, presence: true
	validates :last_name, presence: true
	validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, :message => "should be valid"
	validates_format_of :phone, with: /\A\+\d+\Z/, :message => "should be numbers and prefixed with +"

	after_validation :set_errors

	private
	def set_errors
		self.has_error = true
		self.error_message = self.errors.full_messages
	end
end
