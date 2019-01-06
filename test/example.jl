"docstring"
function function_name(arg)
    for value in 0:arg
        if value > 3
            return true
        elseif value < 4
            return nothing
        else
            return false
        end
    end
end
