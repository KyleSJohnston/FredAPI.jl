module category

using Compat
using Dates: Date, DateTime
using HTTP
using JSON

using ..FredAPI: get_api_key
using ..Responses: Category, CategoryResponse, SeriesResponse, TagsResponse
using ..Validation

@compat public get, children, related, series, tags, related_tags

"""
    get(category_id=0)

Get the category for `category_id`, defaulting to the root category

# Arguments
- `api_key`: overrides the globally configured API key for this request; see [`get_api_key`](@ref).

See [`fred/category`](https://fred.stlouisfed.org/docs/api/fred/category.html).
"""
function get(
    category_id::Integer=0;
    api_key::Union{Nothing,AbstractString}=nothing,
)
    query = Pair{String,Any}[
        "api_key" => get_api_key(api_key),
        "file_type" => "json",
        "category_id" => category_id,
    ]
    http_response = HTTP.get("https://api.stlouisfed.org/fred/category"; query)
    return JSON.parse(http_response.body, CategoryResponse)
end

"""
    children(category_id=0)

Get the children categories for the `category_id` category

# Arguments
- `api_key`: overrides the globally configured API key for this request; see [`get_api_key`](@ref).
- `realtime_start`: the first date of the real-time period over which the data is valid; defaults to today.
- `realtime_end`: the last date of the real-time period over which the data is valid; defaults to today.

See [`fred/category/children`](https://fred.stlouisfed.org/docs/api/fred/category_children.html).

See [Real-Time Periods](https://fred.stlouisfed.org/docs/api/fred/realtime_period.html).
"""
function children(
    category_id::Integer=0;
    api_key::Union{Nothing,AbstractString}=nothing,
    realtime_start::Union{Nothing,Date}=nothing,
    realtime_end::Union{Nothing,Date}=nothing,
)
    query = Pair{String,Any}[
        "api_key" => get_api_key(api_key),
        "file_type" => "json",
        "category_id" => category_id,
    ]
    if !isnothing(realtime_start)
        push!(query, "realtime_start" => string(realtime_start))
    end
    if !isnothing(realtime_end)
        push!(query, "realtime_end" => string(realtime_end))
    end
    http_response = HTTP.get("https://api.stlouisfed.org/fred/category/children"; query)
    return JSON.parse(http_response.body, CategoryResponse)
end

"""
    related(category_id)

Get categories related to the `category_id` category

# Arguments
- `api_key`: overrides the globally configured API key for this request; see [`get_api_key`](@ref).
- `realtime_start`: the first date of the real-time period over which the data is valid; defaults to today.
- `realtime_end`: the last date of the real-time period over which the data is valid; defaults to today.

See [`fred/category/related`](https://fred.stlouisfed.org/docs/api/fred/category_related.html).

See [Real-Time Periods](https://fred.stlouisfed.org/docs/api/fred/realtime_period.html).
"""
function related(
    category_id::Integer;
    api_key::Union{Nothing,AbstractString}=nothing,
    realtime_start::Union{Nothing,Date}=nothing,
    realtime_end::Union{Nothing,Date}=nothing,
)
    query = Pair{String,Any}[
        "api_key" => get_api_key(api_key),
        "file_type" => "json",
        "category_id" => category_id,
    ]
    if !isnothing(realtime_start)
        push!(query, "realtime_start" => string(realtime_start))
    end
    if !isnothing(realtime_end)
        push!(query, "realtime_end" => string(realtime_end))
    end
    http_response = HTTP.get("https://api.stlouisfed.org/fred/category/related"; query)
    return JSON.parse(http_response.body, CategoryResponse)
end


"""
    series(category_id)

Get the series available in the `category_id` category

# Arguments
- `api_key`: overrides the globally configured API key for this request; see [`get_api_key`](@ref).
- `realtime_start`: the first date of the real-time period over which the data is valid; defaults to today.
- `realtime_end`: the last date of the real-time period over which the data is valid; defaults to today.
- `limit`: the upper bound on the number of results to return.
- `offset`: the number of the first result to return, for paginating through results beyond `limit`.
- `order_by`: the field results are sorted by; one of `"series_id"`, `"title"`, `"units"`, `"frequency"`, `"seasonal_adjustment"`, `"realtime_start"`, `"realtime_end"`, `"last_updated"`, `"observation_start"`, `"observation_end"`, `"popularity"`, or `"group_popularity"`.
- `sort_order`: sort results in ascending (`"asc"`, the default) or descending (`"desc"`) order.
- `filter_variable`: the attribute that `filter_value` filters results by; see [`FredAPI.Validation.validate_filter_variable`](@ref) for accepted values.
- `filter_value`: the value to filter on for the attribute named by `filter_variable`; see [`FredAPI.Validation.validate_filter_variable`](@ref) for the attributes `filter_variable` may name.
- `tag_names`: results must match all of these tags; see [`FredAPI.tags.get_all`](@ref) for accepted tag values.
- `exclude_tag_names`: results must match none of these tags; see [`FredAPI.tags.get_all`](@ref) for accepted tag values.

See [`fred/category/series`](https://fred.stlouisfed.org/docs/api/fred/category_series.html).

See [Real-Time Periods](https://fred.stlouisfed.org/docs/api/fred/realtime_period.html).
"""
function series(
    category_id::Integer;
    api_key::Union{Nothing,AbstractString}=nothing,
    realtime_start::Union{Nothing,Date}=nothing,
    realtime_end::Union{Nothing,Date}=nothing,
    limit::Union{Nothing,Integer}=nothing,
    offset::Union{Nothing,Integer}=nothing,
    order_by::Union{Nothing,AbstractString}=nothing,
    sort_order::Union{Nothing,AbstractString}=nothing,
    filter_variable::Union{Nothing,AbstractString}=nothing,
    filter_value::Union{Nothing,AbstractString}=nothing,
    tag_names::AbstractVector{<:AbstractString}=String[],
    exclude_tag_names::AbstractVector{<:AbstractString}=String[],
)
    query = Pair{String,Any}[
        "api_key" => get_api_key(api_key),
        "file_type" => "json",
        "category_id" => category_id,
    ]
    if !isnothing(realtime_start)
        push!(query, "realtime_start" => string(realtime_start))
    end
    if !isnothing(realtime_end)
        push!(query, "realtime_end" => string(realtime_end))
    end
    if !isnothing(limit)
        push!(query, "limit" => validate_limit(limit))
    end
    if !isnothing(offset)
        push!(query, "offset" => validate_offset(offset))
    end
    if !isnothing(order_by)
        order_by in (
            "series_id",
            "title",
            "units",
            "frequency",
            "seasonal_adjustment",
            "realtime_start",
            "realtime_end",
            "last_updated",
            "observation_start",
            "observation_end",
            "popularity",
            "group_popularity",
        ) || throw(ArgumentError("invalid order_by $order_by"))
        push!(query, "order_by" => String(order_by))
    end
    if !isnothing(sort_order)
        push!(query, "sort_order" => validate_sort_order(sort_order))
    end
    if !isnothing(filter_variable)
        push!(query, "filter_variable" => validate_filter_variable(filter_variable))
    end
    if !isnothing(filter_value)
        push!(query, "filter_value" => String(filter_value))
    end
    if length(tag_names) > 0
        push!(query, "tag_names" => join(tag_names, ';'))  # TODO: maybe validate
    end
    if length(exclude_tag_names) > 0
        push!(query, "exclude_tag_names" => join(exclude_tag_names, ';'))  # TODO: maybe validate
    end
    http_response = HTTP.get("https://api.stlouisfed.org/fred/category/series"; query)
    return JSON.parse(http_response.body, SeriesResponse)
end

"""
    tags(category_id; <keyword arguments>)

Get the tags for the `category_id` category

# Arguments
- `api_key`: overrides the globally configured API key for this request; see [`get_api_key`](@ref).
- `realtime_start`: the first date of the real-time period over which the data is valid; defaults to today.
- `realtime_end`: the last date of the real-time period over which the data is valid; defaults to today.
- `tag_names`: results must match all of these tags; see [`FredAPI.tags.get_all`](@ref) for accepted tag values.
- `tag_group_id`: results must belong to this tag group; see [`FredAPI.Validation.validate_tag_group_id`](@ref) for accepted values.
- `search_text`: a search string to filter results
- `limit`: the upper bound on the number of results to return.
- `offset`: the number of the first result to return, for paginating through results beyond `limit`.
- `order_by`: the field results are sorted by; one of `"series_count"`, `"popularity"`, `"created"`, `"name"`, or `"group_id"`.
- `sort_order`: sort results in ascending (`"asc"`, the default) or descending (`"desc"`) order.

See [`fred/category/tags`](https://fred.stlouisfed.org/docs/api/fred/category_tags.html).

See [Real-Time Periods](https://fred.stlouisfed.org/docs/api/fred/realtime_period.html).
"""
function tags(
    category_id::Integer;
    api_key::Union{Nothing,AbstractString}=nothing,
    realtime_start::Union{Nothing,Date}=nothing,
    realtime_end::Union{Nothing,Date}=nothing,
    tag_names::AbstractVector{<:AbstractString}=String[],
    tag_group_id::Union{Nothing,AbstractString}=nothing,
    search_text::Union{Nothing,AbstractString}=nothing,
    limit::Union{Nothing,Integer}=nothing,
    offset::Union{Nothing,Integer}=nothing,
    order_by::Union{Nothing,AbstractString}=nothing,
    sort_order::Union{Nothing,AbstractString}=nothing,
)
    query = Pair{String,Any}[
        "api_key" => get_api_key(api_key),
        "file_type" => "json",
        "category_id" => category_id,
    ]
    if !isnothing(realtime_start)
        push!(query, "realtime_start" => string(realtime_start))
    end
    if !isnothing(realtime_end)
        push!(query, "realtime_end" => string(realtime_end))
    end
    if length(tag_names) > 0
        push!(query, "tag_names" => join(tag_names, ';'))  # TODO: maybe validate
    end
    if !isnothing(tag_group_id)
        push!(query, "tag_group_id" => validate_tag_group_id(tag_group_id))
    end
    if !isnothing(search_text)
        push!(query, "search_text" => search_text)
    end
    if !isnothing(limit)
        push!(query, "limit" => validate_limit(limit))
    end
    if !isnothing(offset)
        push!(query, "offset" => validate_offset(offset))
    end
    if !isnothing(order_by)
        order_by in (
            "series_count",
            "popularity",
            "created",
            "name",
            "group_id",
        ) || throw(ArgumentError("invalide order_by $order_by"))
        push!(query, "order_by" => String(order_by))
    end
    if !isnothing(sort_order)
        push!(query, "sort_order" => validate_sort_order(sort_order))
    end
    http_response = HTTP.get("https://api.stlouisfed.org/fred/category/tags"; query)
    return JSON.parse(http_response.body, TagsResponse)
end

"""
    related_tags(category_id, tag_names; <keyword arguments>)

Get the related tags for one or more tags within a category

# Arguments
- `api_key`: overrides the globally configured API key for this request; see [`get_api_key`](@ref).
- `realtime_start`: the first date of the real-time period over which the data is valid; defaults to today.
- `realtime_end`: the last date of the real-time period over which the data is valid; defaults to today.
- `exclude_tag_names`: results must match none of these tags; see [`FredAPI.tags.get_all`](@ref) for accepted tag values.
- `tag_group_id`: results must belong to this tag group; see [`FredAPI.Validation.validate_tag_group_id`](@ref) for accepted values.
- `search_text`: a search string to filter results
- `limit`: the upper bound on the number of results to return.
- `offset`: the number of the first result to return, for paginating through results beyond `limit`.
- `order_by`: the field results are sorted by; one of `"series_count"`, `"popularity"`, `"created"`, `"name"`, or `"group_id"`.
- `sort_order`: sort results in ascending (`"asc"`, the default) or descending (`"desc"`) order.

See [`fred/category/related_tags`](https://fred.stlouisfed.org/docs/api/fred/category_related_tags.html).

See [Real-Time Periods](https://fred.stlouisfed.org/docs/api/fred/realtime_period.html).
"""
function related_tags(
    category_id::Integer,
    tag_names::AbstractVector{<:AbstractString};
    api_key::Union{Nothing,AbstractString}=nothing,
    realtime_start::Union{Nothing,Date}=nothing,
    realtime_end::Union{Nothing,Date}=nothing,
    exclude_tag_names::AbstractVector{<:AbstractString}=String[],
    tag_group_id::Union{Nothing,AbstractString}=nothing,
    search_text::Union{Nothing,AbstractString}=nothing,
    limit::Union{Nothing,Integer}=nothing,
    offset::Union{Nothing,Integer}=nothing,
    order_by::Union{Nothing,AbstractString}=nothing,
    sort_order::Union{Nothing,AbstractString}=nothing,
)
    query = Pair{String,Any}[
        "api_key" => get_api_key(api_key),
        "file_type" => "json",
        "category_id" => category_id,
        "tag_names" => join(tag_names, ';'),
    ]
    if !isnothing(realtime_start)
        push!(query, "realtime_start" => string(realtime_start))
    end
    if !isnothing(realtime_end)
        push!(query, "realtime_end" => string(realtime_end))
    end
    if length(exclude_tag_names) > 0
        push!(query, "exclude_tag_names" => join(exclude_tag_names, ';'))  # TODO: maybe validate
    end
    if !isnothing(tag_group_id)
        push!(query, "tag_group_id" => validate_tag_group_id(tag_group_id))
    end
    if !isnothing(search_text)
        push!(query, "search_text" => search_text)
    end
    if !isnothing(limit)
        push!(query, "limit" => validate_limit(limit))
    end
    if !isnothing(offset)
        push!(query, "offset" => validate_offset(offset))
    end
    if !isnothing(order_by)
        order_by in (
            "series_count",
            "popularity",
            "created",
            "name",
            "group_id",
        ) || throw(ArgumentError("invalid order_by $order_by"))
        push!(query, "order_by" => String(order_by))
    end
    if !isnothing(sort_order)
        push!(query, "sort_order" => validate_sort_order(sort_order))
    end
    http_response = HTTP.get("https://api.stlouisfed.org/fred/category/related_tags"; query)
    return JSON.parse(http_response.body, TagsResponse)
end

# Allow Category objects to be used in place of category_id integers
for op in (:get, :children, :related, :series, :tags, :related_tags)
    @eval $op(c::Category; kwargs...) = $op(c.id; kwargs...)
end

end  # module
