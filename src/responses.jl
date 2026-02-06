module Responses

# Custom pretty-printing
# https://docs.julialang.org/en/v1/manual/types/#man-custom-pretty-printing

using Dates: Date, @dateformat_str, DateTime
using StructUtils
using TimeZones

export Category, CategoryResponse
export Observation, ObservationsResponse
export Release, ReleaseResponse, ReleasesResponse
export ReleaseDate, NamedReleaseDate, ReleaseDatesResponse
export Series, SeriesResponse, SingleSeriesResponse
export Source, SimpleSourcesResponse, SourcesResponse
export TableElement, TableResponse
export Tag, TagsResponse
export VintageDatesResponse

const DATETIME_FORMAT = dateformat"yyyy-mm-dd HH:MM:SSzz"

struct Category
    id::Int
    name::String
    parent_id::Int
end

function Base.show(io::IO, category::Category)
    if get(io, :compact, false)::Bool
        # compact single-line print
        if get(io, :typeinfo, Nothing) == Category
            print(io, category.name)
        else
            print(io, "Category(", category.id, ")")
        end
    else
        # single-line print
        print(
            io,
            "Category(",
            category.id, ", ",
            category.name, ", ",
            category.parent_id, ")"
        )
    end
end

"""

# Returned By:
- `category`
- `category/children`
- `category/related`
- `series/categories`
"""
struct CategoryResponse
    categories::Vector{Category}
end

function Base.show(io::IO, cr::CategoryResponse)
    if get(io, :compact, false)::Bool
        # compact single-line print
        print(io, "CategoryResponse(<", length(cr.categories), " categories>]")
    else
        # single-line print
        print(io, "CategoryResponse(")
        print(IOContext(io, :compact => true), cr.categories)
        print(io, ")")
    end
end

struct Observation
    realtime_start::Date
    realtime_end::Date
    date::Date
    value::String
end

function Base.show(io::IO, observation::FredAPI.Responses.Observation)
    if get(io, :compact, false)::Bool
        # compact single-line print
        if get(io, :typeinfo, Nothing) == FredAPI.Responses.Observation
            print(io, "(", observation.date, ", ", observation.value, ")")
        else
            print(io, "Observation(", observation.date, ", ", observation.value, ")")
        end
    else
        # single-line print
        print(
            io,
            "Observation(",
            observation.realtime_start, ", ",
            observation.realtime_end, ", ",
            observation.date, ", ",
            observation.value, ")"
        )
    end
end

function Base.show(io::IO, ::MIME"text/plain", observation::FredAPI.Responses.Observation)
    # multi-line print
    println(io, "Observation")
    println(io, "  realtime_start: ", observation.realtime_start)
    println(io, "    realtime_end: ", observation.realtime_end)
    println(io, "            date: ", observation.date)
    println(io, "           value: ", observation.value)
end

struct ObservationsResponse
    realtime_start::Date
    realtime_end::Date
    observation_start::Date
    observation_end::Date
    units::String
    output_type::Int
    file_type::String
    order_by::String
    sort_order::String
    count::Int
    offset::Int
    limit::Int
    observations::Vector{Observation}
end

function Base.show(io::IO, or::ObservationsResponse)
    if get(io, :compact, false)::Bool
        # compact single-line print
        print(io, "ObservationsResponse(<", length(or.observations), " observations>]")
    else
        # single-line print
        print(
            io,
            "ObservationsResponse(",
            or.realtime_start, ", ",
            or.realtime_end, ", ",
            or.observation_start, ", ",
            or.observation_end, ", <",
            length(or.observations), " observations>)"
        )
    end
end

function Base.show(io::IO, ::MIME"text/plain", or::ObservationsResponse)
    # multi-line print
    println(io, "ObservationsResponse")
    println(io, "       realtime_start: ", or.realtime_start)
    println(io, "         realtime_end: ", or.realtime_end)
    println(io, "    observation_start: ", or.observation_start)
    println(io, "      observation_end: ", or.observation_end)
    println(io, "                units: ", or.units)
    println(io, "          output_type: ", or.output_type)
    println(io, "            file_type: ", or.file_type)
    println(io, "             order_by: ", or.order_by)
    println(io, "           sort_order: ", or.sort_order)
    println(io, "                count: ", or.count)
    println(io, "               offset: ", or.offset)
    println(io, "                limit: ", or.limit)
    print(io, "         observations: ")
    print(IOContext(io, :compact => true), or.observations)
end

struct Release
    id::Int
    realtime_start::Date
    realtime_end::Date
    name::String
    press_release::Bool
    link::Union{Nothing,String}
end

function Base.show(io::IO, release::Release)
    if get(io, :compact, false)::Bool
        # compact single-line print
        if get(io, :typeinfo, Nothing) == Release
            print(io, release.id)
        else
            print(io, "Release(", release.id, ")")
        end
    else
        # single-line print
        print(
            io,
            "Release(",
            release.id, ", ",
            release.realtime_start, ", ",
            release.realtime_end, ", ",
            release.name, ", ",
            release.press_release, ",",
            release.link, ")",
        )
    end
end

function Base.show(io::IO, ::MIME"text/plain", release::Release)
    # multi-line print
    println(io, "Release")
    println(io, "              id: ", release.id)
    println(io, "  realtime_start: ", release.realtime_start)
    println(io, "    realtime_end: ", release.realtime_end)
    println(io, "            name: ", release.name)
    println(io, "   press_release: ", release.press_release)
    println(io, "            link: ", release.link)
end

"""

# Returned By:
- `releases`
"""
struct ReleasesResponse
    realtime_start::Date
    realtime_end::Date
    order_by::String
    sort_order::String
    count::Int
    offset::Int
    limit::Int
    releases::Vector{Release}
end

struct ReleaseDate
    release_id::Int
    date::Date
end

struct NamedReleaseDate
    release_id::Int
    release_name::String
    date::Date
end

struct ReleaseDatesResponse{T}
    realtime_start::Date
    realtime_end::Date
    order_by::String
    sort_order::String
    count::Int
    offset::Int
    limit::Int
    release_dates::Vector{T}
end

struct ReleaseResponse
    realtime_start::Date
    realtime_end::Date
    releases::Vector{Release}
end


@defaults struct Series
    id::String
    realtime_start::Date
    realtime_end::Date
    title::String
    observation_start::Date
    observation_end::Date
    frequency::String
    frequency_short::String
    units::String
    units_short::String
    seasonal_adjustment::String
    seasonal_adjustment_short::String
    last_updated::DateTime &(json=(dateformat=DATETIME_FORMAT,),)
    popularity::Int
    group_popularity::Union{Nothing,Int} = nothing
    notes::Union{Nothing,String} = nothing
end

function Base.show(io::IO, series::Series)
    if get(io, :compact, false)::Bool
        # compact single-line print
        if get(io, :typeinfo, Nothing) == Series
            print(io, series.id)
        else
            print(io, "Series[", series.id, "]")
        end
    else
        # single-line print
        print(io, "Series(", series.id, ", ", series.title, ", ", series.frequency, ", ", series.units, ")")
    end
end

function Base.show(io::IO, ::MIME"text/plain", series::Series)
    # multi-line print
    println(io, "Series")
    println(io, "                   id: ", series.id)
    println(io, "       realtime_start: ", series.realtime_start)
    println(io, "         realtime_end: ", series.realtime_end)
    println(io, "                title: ", series.title)
    println(io, "    observation_start: ", series.observation_start)
    println(io, "      observation_end: ", series.observation_end)
    println(io, "            frequency: ", series.frequency, " [", series.frequency_short, "]")
    println(io, "                units: ", series.units, " [", series.units_short, "]")
    println(io, "  seasonal_adjustment: ", series.seasonal_adjustment, " [", series.seasonal_adjustment_short, "]")
    println(io, "         last_updated: ", series.last_updated)
    println(io, "           popularity: ", series.popularity)
    println(io, "     group_popularity: ", series.group_popularity)
    println(io, "                notes:")
    print(io, series.notes)
end

struct SeriesResponse
    realtime_start::Date
    realtime_end::Date
    order_by::String
    sort_order::String
    count::Int
    offset::Int
    limit::Int
    seriess::Vector{Series}
end

struct SingleSeriesResponse
    realtime_start::Date
    realtime_end::Date
    seriess::Vector{Series}
end

function Base.show(io::IO, ssr::SingleSeriesResponse)
    if get(io, :compact, false)::Bool
        # compact single-line print
        print(io, "SingleSeriesResponse(<", length(ssr.seriess), " series>]")
    else
        # single-line print
        print(io, "SingleSeriesResponse(", ssr.realtime_start, ", ", ssr.realtime_end, ", ", ssr.seriess[1].id, ")")
    end
end

function Base.show(io::IO, ::MIME"text/plain", ssr::SingleSeriesResponse)
    # multi-line print
    println(io, "SingleSeriesResponse")
    println(io, "  realtime_start: ", ssr.realtime_start)
    println(io, "    realtime_end: ", ssr.realtime_end)
    print(io, "         seriess: ")
    print(IOContext(io, :compact => true), ssr.seriess)
end

@defaults struct Source
    id::Int
    realtime_start::Date
    realtime_end::Date
    name::String
    link::Union{Nothing,String} = nothing
    notes::Union{Nothing,String} = nothing
end

struct SourcesResponse
    realtime_start::Date
    realtime_end::Date
    order_by::String
    sort_order::String
    count::Int
    offset::Int
    limit::Int
    sources::Vector{Source}
end

struct SimpleSourcesResponse
    realtime_start::Date
    realtime_end::Date
    sources::Vector{Source}
end

struct TableElement
    element_id::Int
    release_id::Int
    series_id::Union{Nothing,String}
    parent_id::Union{Nothing,Int}
    line::Union{Nothing,String}  # integer as string?
    type::String
    name::String
    level::String  # integer as string?
    children::Vector{TableElement}
end

struct TableResponse
    name::Union{Nothing,String}
    element_id::Union{Nothing,Int}
    release_id::String  # integer as string?
    elements::Dict{String,TableElement}
end

@tags struct Tag
    name::String
    group_id::String
    notes::Union{Nothing,String}
    created::DateTime &(json=(dateformat=DATETIME_FORMAT,),)
    popularity::Int
    series_count::Int
end

struct TagsResponse
    realtime_start::Date
    realtime_end::Date
    order_by::String
    sort_order::String
    count::Int
    offset::Int
    limit::Int
    tags::Vector{Tag}
end

struct VintageDatesResponse
    realtime_start::Date
    realtime_end::Date
    order_by::String
    sort_order::String
    count::Int
    offset::Int
    limit::Int
    vintage_dates::Vector{Date}
end

end  # module
