class ResourcesController < ApplicationController
    unloadable

    def show
        if params[:year] and params[:year].to_i >= Date.today.year
            @year = params[:year].to_i

            if params[:month] and params[:month].to_i > 0 and params[:month].to_i < 13
                @month = params[:month].to_i
            end
        end

        @year||= Date.today.year
        @month||= Date.today.month

        @calendar = Redmine::Helpers::Calendar.new(Date.civil(@year, @month, 1), current_language, :month)

        @resources= {}
        User.select("id, firstname, lastname").where("type = 'User'").order("id").each do |u|
            @resources[u.id]= { :name=> ("#{u.firstname} #{u.lastname}"), :selected=> false }
        end

        events= []
        if params[:resources]
            params[:resources].sort.each_with_index do |r, i|
                @resources[r.to_i][:colour]= rand_hex_colour i
                @resources[r.to_i][:selected]= true

                @resources[r.to_i][:schedule]= {}
                UserScheduleEntry.where(:user_id=> r.to_i).each do |s|
                    days= s.days_of_week.to_s(2)
                    days= ("0" * (7 - days.length)) + days

                    ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"].each_with_index do |d, j|
                        @resources[r.to_i][:schedule][d]= (days[j] == "1") ? s.hours : 0
                    end
                end

                Issue.select("start_date, due_date, sum(estimated_hours) as estimated_hours").where("assigned_to_id = ? and ((start_date between ? and ?) or (due_date between ? and ?))", r.to_i, @calendar.startdt, @calendar.enddt, @calendar.startdt, @calendar.enddt).group("start_date, due_date").each do |i|
                    events << PPR::Events::ResourceScheduleEvent.new(r.to_i, i.estimated_hours, i.start_date, i.due_date)
                end
            end
        end

        @calendar.events= events
    end

    private
        def rand_hex_colour(index)
            ["#f3a779","#8379f3","#92f379","#f379b6","#79d9f3","#f3e979","#c579f3","#79f3a2","#f37e79","#7998f3","#bbf379","#f379df","#79f3e3","#f3c079","#9c79f3","#79f379","#f3799d","#79c0f3","#e4f379","#de79f3","#79f3bb","#f39779","#797ef3","#a2f379","#f379c5","#79e9f3","#f3d979","#b679f3","#79f392","#f37984","#79a7f3","#cbf379","#f379ee","#79f3d4","#f3b079","#8d79f3","#89f379","#f379ac","#79d0f3","#f3f279","#cf79f3","#79f3ab","#f38879","#798ef3","#b1f379","#f379d5","#79f3ed","#f3c979","#a679f3","#79f383","#f37993","#79b7f3","#daf379","#e879f3","#79f3c4","#f3a179","#7d79f3","#98f379","#f379bc","#79dff3","#f3e379","#bf79f3","#79f39c","#f3797a","#799ef3","#c1f379","#f379e4","#79f3dd","#f3ba79","#9679f3","#7ff379","#f379a3","#79c6f3","#eaf379","#d879f3","#79f3b5","#f39179","#7984f3","#a8f379","#f379cb","#79eff3","#f3d379","#b079f3","#79f38c","#f3798a","#79adf3","#d1f379","#f179f3","#79f3ce","#f3aa79","#8779f3","#8ff379","#f379b2","#79d6f3","#f3ec79","#c979f3","#79f3a5","#f38279","#7994f3","#b7f379"][index]
        end
end
