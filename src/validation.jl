module Validation

export validate_limit, validate_offset, validate_sort_order,
    validate_filter_variable, validate_tag_group_id, validate_units,
    validate_frequency, validate_aggregation_method, validate_search_type,
    validate_filter_value

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

"""
    validate_sort_order(sort_order)

Validate `sort_order`, the direction results are sorted in.

# Accepted values
- `"asc"`: ascending order (the default).
- `"desc"`: descending order.
"""
function validate_sort_order(sort_order::AbstractString)
    sort_order == "asc" || sort_order == "desc" || throw(ArgumentError("invalid sort_order $sort_order"))
    return String(sort_order)
end

"""
    validate_filter_variable(filter_variable)

Validate `filter_variable`, the attribute that a paired `filter_value` filters results by.
The corresponding `filter_value` must be a valid value for the chosen attribute, e.g. one of
the codes accepted by [`validate_frequency`](@ref) when `filter_variable` is `"frequency"`.

# Accepted values
- `"frequency"`
- `"units"`
- `"seasonal_adjustment"`
"""
function validate_filter_variable(filter_variable::AbstractString)
    filter_variable == "frequency" ||
        filter_variable == "units" ||
        filter_variable == "seasonal_adjustment" ||
        throw(ArgumentError("invalid filter_variable $filter_variable"))
    return String(filter_variable)
end

"""
    validate_tag_group_id(tag_group_id)

Validate `tag_group_id`, the tag group used to filter or group tags.

# Accepted values
- `"freq"`: frequency
- `"gen"`: general or concept
- `"geo"`: geography
- `"geot"`: geography type
- `"rls"`: release
- `"seas"`: seasonal adjustment
- `"src"`: source
"""
function validate_tag_group_id(tag_group_id::AbstractString)
    tag_group_id in (
        "freq",
        "gen",
        "geo",
        "geot",
        "rls",
        "seas",
        "src",
    ) || throw(ArgumentError("invalid tag_group_id $tag_group_id"))
    return String(tag_group_id)
end

"""
    validate_units(units)

Validate `units`, the data value transformation applied to a series' observations.

# Accepted values
- `"lin"`: levels (no transformation)
- `"chg"`: change
- `"ch1"`: change from prior year
- `"pch"`: percentage change
- `"pc1"`: percentage change from prior year
- `"pca"`: compounded annual rate of change
- `"cch"`: continuously compounded rate of change
- `"cca"`: continuously compounded annual rate of change
- `"log"`: natural log
"""
function validate_units(units::AbstractString)
    units in (
        "lin",
        "chg",
        "ch1",
        "pch",
        "pc1",
        "pca",
        "cch",
        "cca",
        "log",
    ) || throw(ArgumentError("invalid units $units"))
    return String(units)
end

"""
    validate_frequency(frequency)

Validate `frequency`, the frequency to which observations are aggregated.

# Accepted values
- `"d"`: daily
- `"w"`: weekly
- `"bw"`: biweekly
- `"m"`: monthly
- `"q"`: quarterly
- `"sa"`: semiannual
- `"a"`: annual
- `"wef"`: weekly, ending Friday
- `"weth"`: weekly, ending Thursday
- `"wew"`: weekly, ending Wednesday
- `"wetu"`: weekly, ending Tuesday
- `"wem"`: weekly, ending Monday
- `"wesu"`: weekly, ending Sunday
- `"wesa"`: weekly, ending Saturday
- `"bwew"`: biweekly, ending Wednesday
- `"bwem"`: biweekly, ending Monday
"""
function validate_frequency(frequency::AbstractString)
    frequency in (
        "d",
        "w",
        "bw",
        "m",
        "q",
        "sa",
        "a",
        "wef",
        "weth",
        "wew",
        "wetu",
        "wem",
        "wesu",
        "wesa",
        "bwew",
        "bwem",
    ) || throw(ArgumentError("invalid frequency $frequency"))
    return String(frequency)
end

"""
    validate_aggregation_method(aggregation_method)

Validate `aggregation_method`, how observations are aggregated when `frequency` downsamples
a series to a lower frequency.

# Accepted values
- `"avg"`: average
- `"sum"`: sum
- `"eop"`: end-of-period
"""
function validate_aggregation_method(aggregation_method::AbstractString)
    aggregation_method in (
        "avg",
        "sum",
        "eop",
    ) || throw(ArgumentError("invalid aggregation_method $aggregation_method"))
    return String(aggregation_method)
end

"""
    validate_search_type(search_type)

Validate `search_type`, which selects how search text is matched against series.

# Accepted values
- `"full_text"`: search series attributes (title, units, frequency, seasonal adjustment,
  tags, notes) using a full text search.
- `"series_id"`: search only within series IDs.
"""
function validate_search_type(search_type::AbstractString)
    search_type == "full_text" ||
        search_type == "series_id" ||
        throw(ArgumentError("invalid search_type $search_type"))
    return String(search_type)
end

"""
    validate_filter_value(filter_value)

Validate `filter_value` as used by [`FredAPI.series.updates`](@ref) to restrict results by
series type. This is unrelated to the `filter_value` accepted by other endpoints, which
instead pairs with `filter_variable` (see [`validate_filter_variable`](@ref)) and is not
restricted to this set.

# Accepted values
- `"macro"`: macroeconomic data series
- `"regional"`: series for parts of the U.S. (e.g. states, counties, MSAs)
- `"all"`: no filter
"""
function validate_filter_value(filter_value::AbstractString)
    filter_value in (
        "macro",
        "regional",
        "all",
    ) || throw(ArgumentError("invalid filter_value $filter_value"))
    return String(filter_value)
end

end  # module
