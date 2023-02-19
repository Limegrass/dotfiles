local date_function_node = function(date_format)
    return f(function()
        return os.date(date_format)
    end)
end

return {
    snippet("datetime", {
        choice_node(
            1,
            {
                date_function_node("!%Y-%m-%dT%TZ"),
                date_function_node("!%D %T"),
                date_function_node("%Y-%m-%dT%T%z"),
                date_function_node("%D %T %Z"),
            }
        )
    }),
    snippet("date", {
        date_function_node("%D"),
    })
}
