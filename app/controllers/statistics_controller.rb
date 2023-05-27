class StatisticsController < ApplicationController
    def index
        @visits_per_day = Ahoy::Visit.group_by_day(:started_at).distinct.count(:user_id)
        
        @unique_visitors_per_day = Ahoy::Visit.where("user_id IS NOT NULL").group_by_day(:started_at).distinct.count(:user_id)


        
        #@time_spent_per_visit = Ahoy::Event.where(name: '$view').average(:time)
        @most_visited_pages = Ahoy::Event.where(name: '$view').group(:properties).count
        @os_stats = Ahoy::Visit.group(:os).count
        @device_stats = Ahoy::Visit.group(:device_type).count
        @browsers = Ahoy::Visit.group(:browser).count       
      end
end
