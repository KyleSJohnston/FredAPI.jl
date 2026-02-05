using FredAPI
using FredAPI.Validation
using FredAPI: FredAPI as fred
using Test

# Unit Tests are run without an API key, and tests should *not* send requests
# to any of the API endpoints.

@testset "Validation Tests" begin
    @testset "Validation Functions" begin
        @test validate_limit(123) == 123
        @test_throws ArgumentError validate_limit(123; ubound=100)
        @test_throws ArgumentError validate_limit(-123)

        @test validate_offset(123) == 123
        @test validate_offset(0) == 0
        @test_throws ArgumentError validate_offset(-123)

        @test validate_sort_order("asc") == "asc"
        @test validate_sort_order("desc") == "desc"
        @test_throws ArgumentError validate_sort_order("other")

        @test validate_filter_variable("frequency") == "frequency"
        @test validate_filter_variable("units") == "units"
        @test validate_filter_variable("seasonal_adjustment") == "seasonal_adjustment"
        @test_throws ArgumentError validate_filter_variable("other")

        @test validate_tag_group_id("freq") == "freq"
        @test validate_tag_group_id("gen") == "gen"
        @test validate_tag_group_id("geo") == "geo"
        @test validate_tag_group_id("geot") == "geot"
        @test validate_tag_group_id("rls") == "rls"
        @test validate_tag_group_id("seas") == "seas"
        @test validate_tag_group_id("src") == "src"
        @test_throws ArgumentError validate_tag_group_id("other")

        @test validate_units("lin") == "lin"
        @test validate_units("chg") == "chg"
        @test validate_units("ch1") == "ch1"
        @test validate_units("pch") == "pch"
        @test validate_units("pc1") == "pc1"
        @test validate_units("pca") == "pca"
        @test validate_units("cch") == "cch"
        @test validate_units("cca") == "cca"
        @test validate_units("log") == "log"
        @test_throws ArgumentError validate_units("other")

        @test validate_frequency("d") == "d"
        @test validate_frequency("w") == "w"
        @test validate_frequency("bw") == "bw"
        @test validate_frequency("m") == "m"
        @test validate_frequency("q") == "q"
        @test validate_frequency("sa") == "sa"
        @test validate_frequency("a") == "a"

        @test validate_frequency("wef") == "wef"
        @test validate_frequency("weth") == "weth"
        @test validate_frequency("wew") == "wew"
        @test validate_frequency("wetu") == "wetu"
        @test validate_frequency("wem") == "wem"
        @test validate_frequency("wesu") == "wesu"
        @test validate_frequency("wesa") == "wesa"

        @test validate_frequency("bwew") == "bwew"
        @test validate_frequency("bwem") == "bwem"
        @test_throws ArgumentError validate_frequency("other")

        @test validate_aggregation_method("avg") == "avg"
        @test validate_aggregation_method("sum") == "sum"
        @test validate_aggregation_method("eop") == "eop"
        @test_throws ArgumentError validate_aggregation_method("other")

        @test validate_search_type("full_text") == "full_text"
        @test validate_search_type("series_id") == "series_id"
        @test_throws ArgumentError validate_search_type("other")

        @test validate_filter_value("macro") == "macro"
        @test validate_filter_value("regional") == "regional"
        @test validate_filter_value("all") == "all"
        @test_throws ArgumentError validate_filter_value("other")
    end

    @testset "Limit Validation" begin
        @test_throws ArgumentError fred.category.series(1; limit=-1)
        @test_throws ArgumentError fred.category.tags(1; limit=-1)
        @test_throws ArgumentError fred.category.related_tags(1, ["some tag"]; limit=-1)
        @test_throws ArgumentError fred.releases.get_all(limit=-1)
        @test_throws ArgumentError fred.releases.dates(limit=-1)
        @test_throws ArgumentError fred.release.dates(1; limit=-1)
        @test_throws ArgumentError fred.release.series(1; limit=-1)
        @test_throws ArgumentError fred.release.tags(1; limit=-1)
        @test_throws ArgumentError fred.release.related_tags(1, ["some", "tags"]; limit=-1)
        @test_throws ArgumentError fred.series.observations("SERIES"; limit=-1)
        @test_throws ArgumentError fred.series.search("search text"; limit=-1)
        @test_throws ArgumentError fred.series.search_tags("search text"; limit=-1)
        @test_throws ArgumentError fred.series.search_related_tags("search text", ["tag", "names"]; limit=-1)
        @test_throws ArgumentError fred.series.updates(limit=-1)
        @test_throws ArgumentError fred.series.vintagedates("SERIES"; limit=-1)
        @test_throws ArgumentError fred.source.get_all(limit=-1)
        @test_throws ArgumentError fred.source.releases(1; limit=-1)
        @test_throws ArgumentError fred.tags.get_all(limit=-1)
        @test_throws ArgumentError fred.tags.related_tags(["tag", "names"]; limit=-1)
        @test_throws ArgumentError fred.tags.series(["tag", "names"]; limit=-1)
    end

    @testset "Offset Validation" begin
        @test_throws ArgumentError fred.category.series(1; offset=-1)
        @test_throws ArgumentError fred.category.tags(1; offset=-1)
        @test_throws ArgumentError fred.category.related_tags(1, ["some tag"]; offset=-1)
        @test_throws ArgumentError fred.releases.get_all(offset=-1)
        @test_throws ArgumentError fred.releases.dates(offset=-1)
        @test_throws ArgumentError fred.release.dates(1; offset=-1)
        @test_throws ArgumentError fred.release.series(1; offset=-1)
        @test_throws ArgumentError fred.release.tags(1; offset=-1)
        @test_throws ArgumentError fred.release.related_tags(1, ["some", "tags"]; offset=-1)
        @test_throws ArgumentError fred.series.observations("SERIES"; offset=-1)
        @test_throws ArgumentError fred.series.search("search text"; offset=-1)
        @test_throws ArgumentError fred.series.search_tags("search text"; offset=-1)
        @test_throws ArgumentError fred.series.search_related_tags("search text", ["tag", "names"]; offset=-1)
        @test_throws ArgumentError fred.series.updates(offset=-1)
        @test_throws ArgumentError fred.series.vintagedates("SERIES"; offset=-1)
        @test_throws ArgumentError fred.source.get_all(offset=-1)
        @test_throws ArgumentError fred.source.releases(1; offset=-1)
        @test_throws ArgumentError fred.tags.get_all(offset=-1)
        @test_throws ArgumentError fred.tags.related_tags(["tag", "names"]; offset=-1)
        @test_throws ArgumentError fred.tags.series(["tag", "names"]; offset=-1)
    end
end