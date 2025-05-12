
using Pkg
Pkg.activate("")
Pkg.instantiate()

using PromptingTools



PromptingTools.set_preferences!("PROMPT_SCHEMA" => "OllamaSchema", "MODEL_CHAT"=>"qwen3:0.6b")
PromptingTools.set_preferences!("PROMPT_SCHEMA" => "OllamaSchema", "MODEL_EMBEDDING"=>"nomic-embed-text")