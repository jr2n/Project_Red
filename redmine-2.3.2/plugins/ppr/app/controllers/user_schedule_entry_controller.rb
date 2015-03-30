class UserScheduleEntryController < ApplicationController

    def CreateScheduleEntries
        parsed_json= ActiveSupport::JSON.decode(params[:entries])

        UserScheduleEntry.where(:user_id=> params[:id]).delete_all
    
        parsed_json.each do |d, h|
            user_schedule= UserScheduleEntry.new()

            user_schedule.hours= h
            user_schedule.days_of_week= d
            user_schedule.user_id= params[:id]		  

            user_schedule.save
        end

        render :json=> { :success=> true }
    end
end

