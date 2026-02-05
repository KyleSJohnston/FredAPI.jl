using FredAPI
using Test

FredAPI.APIKey.set(PASS["fred/apikey"])

@testset "Categories" begin
    cr = FredAPI.category.get(125)
    @test cr isa CategoryResponse
    c = only(cr.categories)
    @test c isa Category
    new_cr = FredAPI.category.get(c)
    @test only(new_cr.categories) == c

    cr = FredAPI.category.children(13)
    @test cr isa CategoryResponse
    @test length(cr.categories) == 6
    @test eltype(cr.categories) === Category
    parent_cr = FredAPI.category.get(13)
    new_children = FredAPI.category.children(only(parent_cr.categories))
    @test all(new_children.categories .== cr.categories)

    cr = FredAPI.category.related(32073)
    @test cr isa CategoryResponse
    related = cr.categories
    @test length(related) == 7
    @test all(x -> x.parent_id == 27281, related)

    series_response = FredAPI.category.series(125)
    @test series_response.count < 1000
    @test series_response.count == length(series_response.seriess)
    for s in series_response.seriess
        @testset "$(s.title) $(s.id)" begin
            @test startswith(s.id, "BOP") || startswith(s.id, "IEAB") || startswith(s.id, "AITG")
        end
    end

    tags_response = FredAPI.category.tags(125)
    @test tags_response.count < 1000
    @test tags_response.count == length(tags_response.tags)

    tags_response = FredAPI.category.related_tags(125, ["services", "quarterly"])
    @test tags_response.count < 1000
    @test tags_response.count == length(tags_response.tags)
end

@testset "Releases" begin
    releases_response = FredAPI.releases.get_all()
    @test releases_response.count < 1000
    @test releases_response.count == length(releases_response.releases)

    release_dates_response = FredAPI.releases.dates()
    @test release_dates_response.count < 1000
    @test release_dates_response.count == length(release_dates_response.release_dates)

    release_response = FredAPI.release.get(53)
    @test release_response isa ReleaseResponse
    @test length(release_response.releases) == 1
    @test release_response.releases[1].name == "Gross Domestic Product"

    release_dates_response = FredAPI.release.dates(82)
    @test release_dates_response.count < 10000
    @test release_dates_response.count == length(release_dates_response.release_dates)

    release_series_response = FredAPI.release.series(51)
    @test release_series_response.count < 1000
    @test release_series_response.count == length(release_series_response.seriess)

    sources_response = FredAPI.release.sources(51)
    @test length(sources_response.sources) == 2
    @test all(x -> contains(x.name, "Bureau"), sources_response.sources)

    tags_response = FredAPI.release.tags(86)
    @test tags_response.count < 1000
    @test tags_response.count == length(tags_response.tags)

    related_tags_reponse = FredAPI.release.related_tags(86, ["sa", "foreign"])
    @test related_tags_reponse.count < 1000
    @test related_tags_reponse.count == length(related_tags_reponse.tags)

    tables_response = FredAPI.release.tables(53)
    @test tables_response isa TableResponse
end

@testset "Series Endpoints" begin
    sr = FredAPI.series.get("GNPCA")
    @test sr isa SingleSeriesResponse
    s = only(sr.seriess)
    @test s isa Series
    @test s.id == "GNPCA"

    cr = FredAPI.series.categories("EXJPUS")
    @test cr isa CategoryResponse
    @test length(cr.categories) < 10

    or = FredAPI.series.observations("GNPCA")
    @test or isa ObservationsResponse
    @test or.count < 100_000
    @test or.count == length(or.observations)
    for o in or.observations
        @test o.realtime_start == or.realtime_start
        @test o.realtime_end == or.realtime_end
    end

    rr = FredAPI.series.release("IRA")
    @test rr isa ReleaseResponse
    for r in rr.releases
        @test r.realtime_start == rr.realtime_start
        @test r.realtime_end == rr.realtime_end
    end

    sr = FredAPI.series.search("monetary service index")
    @test sr isa SeriesResponse
    @test sr.count < 1000
    @test sr.count == length(sr.seriess)
    for s in sr.seriess
        @test s.realtime_start == sr.realtime_start
        @test s.realtime_end == sr.realtime_end
    end

    tr = FredAPI.series.search_tags("monetary+service+index")
    @test tr isa TagsResponse
    @test tr.count < 1000
    @test tr.count == length(tr.tags)

    tr = FredAPI.series.search_related_tags("mortgage+rate", ["30-year", "frb"])
    @test tr isa TagsResponse
    @test tr.count < 1000
    @test tr.count == length(tr.tags)

    tr = FredAPI.series.tags("STLFSI")
    @test tr isa TagsResponse
    @test tr.count == length(tr.tags)

    sr = FredAPI.series.updates()
    @test sr isa SeriesResponse
    @test sr.count > 100
    @test sr.limit == 1000
    @test length(sr.seriess) == 1000

    vdr = FredAPI.series.vintagedates("GNPCA")
    @test vdr isa VintageDatesResponse
    @test vdr.count == length(vdr.vintage_dates)
end

@testset "Sources Endpoints" begin
    sr = FredAPI.source.get_all()
    @test sr isa SourcesResponse
    @test sr.count < 1000
    @test sr.offset == 0
    @test sr.count == length(sr.sources)

    ssr = FredAPI.source.get(1)
    @test ssr isa SimpleSourcesResponse
    @test length(ssr.sources) == 1

    rr = FredAPI.source.releases(1)
    @test rr isa ReleasesResponse
    @test rr.count < 1000
    @test rr.limit == 1000
    @test rr.count == length(rr.releases)
end

@testset "Tags Endpoints" begin
    tr = FredAPI.tags.get_all()
    @test tr isa TagsResponse
    @test tr.count > tr.limit
    @test tr.limit == length(tr.tags)

    tr = FredAPI.tags.related_tags(["monetary aggregates", "weekly"])
    @test tr isa TagsResponse
    @test tr.count < tr.limit
    @test tr.count == length(tr.tags)

    sr = FredAPI.tags.series(["slovenia", "food", "oecd"])
    @test sr isa SeriesResponse
    @test sr.count < sr.limit
    @test sr.count == length(sr.seriess)
end

nothing
