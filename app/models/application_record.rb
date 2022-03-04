class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def errors_details
    errors.details.map do |field, error_code|
      {
        field: field,
        code: error_code.first[:error],
        message: errors.full_messages_for(field).first
      }
    end
  end
end
