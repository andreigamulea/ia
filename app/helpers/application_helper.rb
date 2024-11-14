module ApplicationHelper
  SECRET_KEY = "secretkey1"
    def set_selected_values_to_session(selected_values)
      session[:selected_values] = selected_values.map do |value|
        { id: value[:id], value: value[:value] }
      end
    end
    def generate_session_token
      payload = { exp: 30.minutes.from_now.to_i }
      JWT.encode(payload, SECRET_KEY, 'HS256')
    end
  end
  
