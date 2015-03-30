module ResourcesHelper

    def previous_month(year, month)
        if month == 1
            [year - 1, 12]
        else
            [year, month - 1]
        end
    end
    def next_month(year, month)
        if month == 12
            [year + 1, 1]
        else
            [year, month + 1]
        end
    end

    def previous_month_name(year, month)
        if month == 12
            "#{month_name(month)} #{year}"
        else
            "#{month_name(month)}"
        end
    end
    def next_month_name(year, month)
        if month == 1
            "#{month_name(month)} #{year}"
        else
            "#{month_name(month)}"
        end
    end

    def link_to_month(year, month, resources, which= :next)
        target_year, target_month=  case which
                                        when :next
                                            next_month(year, month)
                                        when :previous
                                            previous_month(year, month)
                                    end
        name=  case which
                    when :next
                        next_month_name(target_year, target_month)
                    when :previous
                        previous_month_name(target_year, target_month)
                    end

        link_to name, resources_path(:year=> target_year, :month=> target_month, :resources=> resources), id: "#{target_year}-#{target_month}"
    end
end
