# not yet defining this as a module
# so it will be easier to load and override during workhsop
# module SDMXragger

using HTTP
using JSON3
using Tidier
using RAGTools

export codelist_from_json, clean_label, build_indicator_index

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

function retrieve_similar_codes(user_query::String, labels_df, index)
    answer = retrieve(index, user_query)
    candidate_codes = answer.sources
    
    # format output
    output = @chain labels_df begin
        @filter(code in candidate_codes)

        @mutate(sort_key = indexin(code, candidate_codes))
        @arrange(sort_key)
        @select(-sort_key)
    end
    
    return output
end

function rag_result_to_json(output_from_rag)
    output = Dict(eachrow(output_from_rag))
    output = [key => output[key] for key in candidate_codes]
    output = JSON3.write(output)
    return output
end

function refresh_index(; target_structure = "CL_BP50_INDICATORS")

    this_url = "https://stats-fwb.pacificdata.org/sdmx/v2/structure/codelist/SPC/$structure/latest/?format=fusion-json"

    new_labels = codelist_from_json(this_url)

    new_index = build_index(
        labels.label;
        chunker_kwargs = (;
            max_length = 400, # notice this, not magic: it comes from the maximum length of our codes!
            sources = labels.code
        )
    )

    return (new_labels, new_index)
end

function build_indicator_index(labels_df; max_length = 400)

    indicator_index = build_index(
        labels_df.label;
        chunker_kwargs = (;
        max_length = max_length, # notice this, not magic: it comes from the maximum length of our codes!
        sources = labels_df.code
        )
    )

    return indicator_index

end

# end