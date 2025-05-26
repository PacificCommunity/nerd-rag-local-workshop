using Pkg
Pkg.activate("")
Pkg.instantiate()

using Tidier

indicators = read_csv("./Data/In/indicator_list.csv")

labels = @chain indicators begin
    @clean_names
    @filter(! ismissing(code_in_stat))
    @mutate(full_label = string(indicator))
    @select(code = code_in_stat, label = full_label)
end

write_csv(labels,"./Data/Out/Labels_clean.csv")
