using Pkg
Pkg.activate("")
Pkg.instantiate()

using HTTP
using JSON3
using Tidier
using RAGTools
using FlashRank

include("99_functions.jl")

url = "https://stats-fwb.pacificdata.org/sdmx/v2/structure/codelist/SPC/CL_BP50_INDICATORS/latest/?format=fusion-json"

labels = codelist_from_json(url)


indicator_index = build_indicator_index(labels)

user_query = "Proportion goals new buildings"

answer = retrieve(indicator_index, user_query)

candidate_codes = answer.sources

ranker = RankerModel(:mini)

result = rank(ranker, user_query, )