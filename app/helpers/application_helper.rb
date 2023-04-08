module ApplicationHelper
    def set_selected_values_to_session(selected_values)
      session[:selected_values] = selected_values.map do |value|
        { id: value[:id], value: value[:value] }
      end
    end
  end
  
