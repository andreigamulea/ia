class TranslationsController < ApplicationController
    def edit
      @translation = Translation.find(params[:id])
    end
  
    def update
      @translation = Translation.find(params[:id])
      if @translation.update(manual_text: params[:translation][:manual_text])
        redirect_to translations_path, notice: "✅ Traducerea manuală a fost salvată!"
      else
        render :edit
      end
    end
  end
  