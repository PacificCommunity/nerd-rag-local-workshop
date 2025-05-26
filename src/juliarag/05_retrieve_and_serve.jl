using Pkg
Pkg.activate("")
#Pkg.instantiate()

using HTTP
using JSON3
using Tidier
using RAGTools
using Oxygen

include("99_functions.jl")

bp50_url = "https://stats-fwb.pacificdata.org/sdmx/v2/structure/codelist/SPC/CL_BP50_INDICATORS/latest/?format=fusion-json"

global labels = codelist_from_json(bp50_url)

global indicator_index = build_indicator_index(labels)

function refresh_index(;structure = "CL_BP50_INDICATORS")
    this_url = "https://stats-fwb.pacificdata.org/sdmx/v2/structure/codelist/SPC/$structure/latest/?format=fusion-json"
    global labels = codelist_from_json(this_url)
    global indicator_index = build_indicator_index(labels)

    return "labels and vector index refreshed"
end

### Define endpoints

@get "/" function(req::HTTP.Request)
    return "I am alive!"
end

@get "/refresh/{structure}" function(req::HTTP.Request, structure::String)
    return refresh_index(structure = structure)
end

@get "/search" function(req::HTTP.Request, this_query::String="Proportion of successfull things")
    result = retrieve_similar_codes(this_query, labels, indicator_index)
    return rag_result_to_json(result)
end

serve(host="0.0.0.0", port=8080)