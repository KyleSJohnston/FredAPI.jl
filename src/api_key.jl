"Global management of the required Fred API key"
module APIKey

public get, set

const API_KEY = Ref{String}("abcdefghijklmnopqrstuvwxyz123456")  # documentation default

"""
    set(api_key)

Sets the global api-key constant to `api_key`
"""
function set(api_key::AbstractString)
    API_KEY[] = String(api_key)
    return nothing
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
get(api_key::AbstractString)::String = String(api_key)
get(api_key::String) = api_key

end  # module
