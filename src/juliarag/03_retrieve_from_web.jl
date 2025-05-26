using Pkg
Pkg.activate("")
Pkg.instantiate()

using HTTP
using JSON3
using Tidier
using RAGTools

include("99_functions.jl")

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

    return DataFrame(code = String.(codes), label = clean_label.(String.(names)))

end

function clean_label(label::String)
    # Define the pattern: \n followed by one or more whitespace characters
    pattern = r"\n\s+"
    # Replace the pattern with a single space
    cleaned_label = replace(label, pattern => " ")
    return cleaned_label
end

url = "https://stats-fwb.pacificdata.org/sdmx/v2/structure/codelist/SPC/CL_BP50_INDICATORS/latest/?format=fusion-json"

labels = codelist_from_json(url)


indicator_index = build_indicator_index(labels_df)

answer = retrieve(indicator_index, "Proportion goals new buildings")

candidate_codes = answer.sources

