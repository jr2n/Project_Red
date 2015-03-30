module PPR
    module Events
        class ResourceScheduleEvent
            attr_reader :id, :hours, :start_date, :due_date

            def initialize(id, hours, start_date, due_date)
                @id= id
                @hours= hours
                @due_date= due_date
                @start_date= start_date
            end
        end
    end
end
