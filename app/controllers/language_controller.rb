class LanguageController < ApplicationController
    def set
      session[:locale] = params[:locale]  # Salvează limba selectată în sesiune
      redirect_back(fallback_location: root_path)
    end
  end
  