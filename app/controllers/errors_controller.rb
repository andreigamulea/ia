class ErrorsController < ApplicationController
    def not_found
      redirect_to 'https://ayushcell.ro', status: :moved_permanently
    end
  end
  