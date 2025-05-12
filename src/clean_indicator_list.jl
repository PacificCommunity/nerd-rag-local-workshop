using Pkg
Pkg.activate("")
Pkg.instantiate()

using Tidier
using RAGTools

indicators = read_csv("./Data/In/indicator_list.csv")
labels = @chain indicators begin
    @clean_names
    @filter(! ismissing(code_in_stat))
    @mutate(full_label = string(indicator))
    @select(code_in_stat, full_label)
end

write_csv(labels,"./Data/Out/Labels_clean.csv")


indicator_index = build_index(
    labels.full_label;
    chunker_kwargs = (; sources = map(i -> labels.code_in_stat[i], 1:length(labels.code_in_stat)))
)

answer = retrieve(indicator_index, "Proportion project goals new buildings")

labels[answer.reranked_candidates.positions,:]
generate!(answer,indicator_index)