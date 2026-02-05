"Global management of the required Fred API key"
module APIKey

using Compat

@compat public get, set

const API_KEY = Ref{String}("abcdefghijklmnopqrstuvwxyz123456")  # documentation default

# From https://fred.stlouisfed.org/docs/api/fred/category_series.html#Parameters
validate(api_key::AbstractString) = lowercase(ascii(api_key))

"""
    set(api_key)

Sets the global api-key constant to `api_key`
"""
function set(api_key::AbstractString)
    API_KEY[] = validate(api_key)
end

"""
    get(api_key)

Obtains an `api_key` for use in HTTP requests

- If `api_key` is an instance of `AbstractString`, a `String` representation of `api_key` is returned.
- If `api_key` is `nothing`, the global API key is returned. (See `set(api_key)`(@ref))

This method serves as the default approach to obtaining an api_key in many
functions.
"""
get(::Nothing)::String = return API_KEY[]
get(api_key::AbstractString)::String = validate(api_key)

end  # module
