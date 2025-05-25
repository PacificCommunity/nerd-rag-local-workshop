
using Pkg
Pkg.activate("")
Pkg.instantiate()

using PromptingTools

models_to_pull = [
    "qwen3:0.6b",
    "nomic-embed-text"
]

for model in models_to_pull
    run(`ollama pull $model`)
end

PromptingTools.set_preferences!("PROMPT_SCHEMA" => "OllamaSchema", "MODEL_CHAT"=>"qwen3:0.6b")
PromptingTools.set_preferences!("PROMPT_SCHEMA" => "OllamaSchema", "MODEL_EMBEDDING"=>"nomic-embed-text")