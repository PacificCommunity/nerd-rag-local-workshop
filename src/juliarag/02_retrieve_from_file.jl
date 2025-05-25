using Pkg
Pkg.activate("")
Pkg.instantiate()

using Tidier
using RAGTools

labels = read_csv("./Data/Out/Labels_clean.csv")

indicator_index = build_index(
    labels.full_label;
    chunker_kwargs = (; sources = code_in_stat)
)

answer = retrieve(indicator_index, "Proportion project goals new buildings")
candidates = labels[answer.reranked_candidates.positions,:]

print(candidates[1,2])