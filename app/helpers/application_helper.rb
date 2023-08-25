module ApplicationHelper
  def set_number_to_delimited(value, delimiter: ',')
    ActiveSupport::NumberHelper.number_to_delimited(value, delimiter: delimiter)
  end
end
