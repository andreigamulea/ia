class StatisticsController < ApplicationController
    def index
        @visits_per_day = Ahoy::Visit.group_by_day(:started_at).distinct.count(:user_id)
        #@time_spent_per_visit = Ahoy::Event.where(name: '$view').average(:time)
        @most_visited_pages = Ahoy::Event.where(name: '$view').group(:properties).count
        @os_stats = Ahoy::Visit.group(:os).count
        @device_stats = Ahoy::Visit.group(:device_type).count
        @browsers = Ahoy::Visit.group(:browser).count


        
       
       @user_page_visit_times_by_date = Ahoy::Event
      .where(user_id: current_user.id)
      .group_by { |event| event.time.to_date }
      .transform_values do |events_on_same_date|
        events_on_same_date.group_by { |event| event.properties["page"] }
          .transform_values do |events_on_same_page|
            load_events = events_on_same_page.select { |event| event.name == "$page_load" }
            unload_events = events_on_same_page.select { |event| event.name == "$page_unload" }

            total_time = 0
            load_events.zip(unload_events).each do |load_event, unload_event|
              if load_event && unload_event
                # Conversia în minute și secunde
                total_seconds = (unload_event.time - load_event.time)
                minutes = total_seconds / 60
                seconds = total_seconds % 60
                total_time += minutes * 60 + seconds
              end
            end
            total_time
          end
      end

      @valori_nutritionale_page_visit_times_by_date = @user_page_visit_times_by_date.transform_values do |pages|
        total_seconds = pages["/valori-nutritionale"] || 0
        minutes = (total_seconds / 60).floor
        seconds = (total_seconds % 60).floor
        "#{minutes} minute, #{seconds} secunde"
      end
      
      
      


      end
end
