using Pkg
Pkg.activate("")
Pkg.instantiate()

using HTTP
using JSON3
using Tidier
using RAGTools
using FlashRank

function codelist_from_json(url::String)
    response = HTTP.get(url)
    content = JSON3.read(response.body)

    # this line is fragile, as other codelists _might_
    # be structured differently? reflect...

    codelist = content.Codelist[1].items

    codes = []
    names = []

    for code in codelist
        push!(codes,code.id)
        push!(names,code.names[1].value)
    end

    return DataFrame(code = String.(codes), label = String.(names))

end

url = "https://stats-fwb.pacificdata.org/sdmx/v2/structure/codelist/SPC/CL_BP50_INDICATORS/latest/?format=fusion-json"

labels = codelist_from_json(url)


indicator_index = build_index(
    labels.label;
    chunker_kwargs = (;
    max_length = 400, # notice this, not magic: it comes from the maximum length of our codes!
    sources = labels.code
    )
)

answer = retrieve(indicator_index, "Proportion goals new buildings")
candidate_codes = answer.sources

ranker = RankerModel()

