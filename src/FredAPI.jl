module FredAPI

using Compat

@compat public get_api_key, set_api_key

const API_KEY = Ref{String}("abcdefghijklmnopqrstuvwxyz123456")  # documentation default

# From https://fred.stlouisfed.org/docs/api/fred/category_series.html#Parameters
validate(api_key::AbstractString) = lowercase(ascii(api_key))

"""
    set_api_key(api_key)

Sets the global api-key constant to `api_key`
"""
function set_api_key(api_key::AbstractString)
    API_KEY[] = validate(api_key)
    return nothing  # otherwise this looks a lot like `get_api_key`...
end

"""
    get_api_key(api_key)

Obtains an `api_key` for use in HTTP requests

- If `api_key` is an instance of `AbstractString`, a `String` representation of `api_key` is returned.
- If `api_key` is `nothing`, the global API key is returned. (See `set(api_key)`(@ref))

This method serves as the default approach to obtaining an api_key in many
functions.
"""
get_api_key(::Nothing)::String = return API_KEY[]
get_api_key(api_key::AbstractString)::String = validate(api_key)

include("validation.jl")
include("responses.jl")

include("category.jl")
include("release.jl")
include("series.jl")
include("source.jl")
include("tags.jl")

# Need to be able to set the api key
@compat public APIKey

# Export response objects for users
using .Responses
export Category, CategoryResponse
export Observation, ObservationsResponse
export Release, ReleaseResponse, ReleasesResponse
export ReleaseDate, NamedReleaseDate, ReleaseDatesResponse
export Series, SeriesResponse, SingleSeriesResponse
export Source, SimpleSourcesResponse, SourcesResponse
export TableElement, TableResponse
export Tag, TagsResponse
export VintageDatesResponse

# Make fully-qualified endpoint functions available
@compat public category, release, releases, series, source, tags

end # module FredAPI
