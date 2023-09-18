class StatisticsController < ApplicationController
  before_action :require_admin, only: %i[index new edit update create]
    def index
        @visits_per_day = Ahoy::Visit.group_by_day(:started_at).distinct.count(:user_id)
        
        
        #@time_spent_per_visit = Ahoy::Event.where(name: '$view').average(:time)
        @most_visited_pages = Ahoy::Event.where(name: '$view').group(:properties).count
        @os_stats = Ahoy::Visit.group(:os).count
        @device_stats = Ahoy::Visit.group(:device_type).count
        @browsers = Ahoy::Visit.group(:browser).count       
      end
      def require_admin
        unless current_user && current_user.role == 1
          flash[:error] = "Only admins are allowed to access this page."
          redirect_to root_path
        end
      end
end
