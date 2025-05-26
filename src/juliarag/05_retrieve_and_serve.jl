using Pkg
Pkg.activate("")
#Pkg.instantiate()

using HTTP
using JSON3
using Tidier
using RAGTools
using Oxygen

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

function retrieve_similar_codes(user_query::String)
    answer = retrieve(indicator_index, user_query)
    candidate_codes = answer.sources
    return candidate_codes
end



### Define endpoints

@get "/" function(req::HTTP.Request)
    return "I am alive!"
end

@get "/search" function(req::HTTP.Request, this_query::String="Proportion of successfull things")
    return retrieve_similar_codes(this_query)
end

serve(host="0.0.0.0", port=8080)