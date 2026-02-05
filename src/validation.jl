module Validation

export validate_limit, validate_offset, validate_sort_order, validate_tag_group_id

function validate_limit(limit::Integer; lbound=1, ubound=1_000)
    lbound <= limit <= ubound || throw(ArgumentError("limit of $limit not between $lbound and $ubound"))
    return limit
end

function validate_offset(offset::Integer)
    offset >= 0 || throw(ArgumentError("offset must be non-negative"))
    return offset
end

# validate_order_by appears to deviate based on the return type of the function
# order_by must be one of the fields in the element type of the response, but
# not all fields are permitted.
# TODO: consider whether this logic can sit in responses.jl

function validate_sort_order(sort_order::AbstractString)
    sort_order == "asc" || sort_order == "desc" || throw(ArgumentError("invalid sort_order $sort_order"))
    return String(sort_order)
end

function validate_filter_variable(filter_variable::AbstractString)
    filter_variable == "frequency" ||
        filter_variable == "units" ||
        filter_variable == "seasonal_adjustment" ||
        throw(ArgumentError("invalid filter_variable $filter_variable"))
    return String(filter_variable)
end

function validate_tag_group_id(tag_group_id::AbstractString)
    tag_group_id in (
        "freq",  # frequency
        "gen",   # general or concept
        "geo",   # geography
        "geot",  # geography type
        "rls",   # release
        "seas",  # seasonal adjustment
        "src",   # source
    ) || throw(ArgumentError("invalid tag_group_id $tag_group_id"))
    return String(tag_group_id)
end

end  # module
