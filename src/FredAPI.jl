module FredAPI

using Compat

include("api_key.jl")
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
