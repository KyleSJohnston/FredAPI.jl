using Documenter
using FredAPI

makedocs(
    sitename="FredAPI.jl",
    modules=[FredAPI],
    checkdocs = :public,
)

# deploydocs(
#     repo = "github.com/KyleSJohnston/FredAPI.jl.git",
# )
