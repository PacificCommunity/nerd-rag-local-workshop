DRAFT WP

# A RAG of one's own

Material for a _Nerd Lazy Morning_ workshop in which we'll build and deploy a local operated RAG.

## Introduction

There's a bazillion tutorials online. And many are great, and I've based this notes on many of those. Without any prentese that this take is unique, my approach is: build a fully _local_ system with Ollama and ChromaDB (or in memory solution for small scale models); spend some time on demystifying jargon and math behind it; do it in two different languages, as the ideas and tools are pretty universal nowadays (and I love an opportunity to showcase Julia).

## Party plan

The two hour plan is:

1) let's do a first quick run in Julia, using RAGTools.jl to solve a real-world problem (research of relevant indicators in a SDMX .Stat based dashboard). This will introduce the ingredients we need (corpus of text, embedding, retrieval, generation). (< 30 minutes, no coding required)
2) spend a couple of minutes to explain what the stuff is: what's a vector? what's a similarity? what does _retrieval_ do? what does _generate!_ do? (< 30 minutes, scary maths will be tamed)
3) go through a couple of examples in python, using LangChain, with increasing complexity (or, closer to a production ready solution). (< 1 hour, live-coding, hands-on)
4) (maybe) if we got time, we might even wrap it up as a server endpoint (flas? LangsServe?) and/or talk about LangSmith to monitor control.

## Setup

A bunch of things are needed for running it all. And it would be amazing if people could run them before coming to the workshop, so we don' need to spend too much time on environment setup. THAT SAID, envinroment setup IS the hardest part, probably, and it's where all the magic goes on.

What do you need if you want to code along me:
- a code editor (I use VS Code)
- a terminal (linux, mac, and Windows come with different choices, they should all do the trick)
- Ollama
- ChromeDB
- (optional) Julia with dependencies
- Python with dependencies

If you just want to watch me/your workshop buddy to code, you don't need anything.

### Ollama

For Windows
- Download and install from official website: https://ollama.com/download
  - when done, you should have a little llama living in your application bar, can you find it?
  - if so, open a terminal and let's start to collect some models
  - run `ollama pull qwen3:0.6b`  
  - run `ollama pull nomic-embed-text`  
  - run `ollama pull snowflake-arctic-embed2`
- to run an AI model in the terminal (we won't need this, but it's a way to check everything is installed):
  - in a terminal, run `ollama run qwen3:0.6b`
  - chat!
  - when you are happy, run `/bye` to quit
  
In Linux/macOS. You might be more experience than me in your system setup, so take the following as unrequested suggestions.
If you are using a package manager, you should be able to install ollama without further ado.
If you try to pull a model and you get an error message, it might be the case that the ollama daemon is not working.
- try running `ollama serve` and pull a model again. did it work?
- if not, you might need to start the ollama service, try runing `systemctl start ollama`(type them and press enter)
- to install AI models in your computer so they will be available for us, you need to "pull" them:
  - open another terminal WITHOUT closing the one where you are running `ollama serve`
  - in this terminal, run `ollama pull qwen3:0.6b`  
  - run `ollama pull nomic-embed-text`  
  - run `ollama pull snowflake-arctic-embed2`
- to run an AI model in the terminal (we won't need this, but it's a way to check everything is installed):
  - open another terminal WITHOUT closing the one where you are running `ollama serve`
  - in this terminal, run `ollama run qwen3:0.6b`
  - chat!
  - when you are happy, run `/bye`

## ChromeDB

It will be taken care for you by Python

## Julia

For Windows/Linux/macOS:
- use `juliaup`.
  - in Windows use this link: https://www.microsoft.com/store/apps/9NJNWW8PVKMN
  - in Linux/macOS use either this command `curl -fsSL https://install.julialang.org | sh` or your favourite package manager (by the way, I `paru -S juliaup`)

When JuliaUp installs, it will bring with it a fully functional Julia installation.

### Julia dependency

As long as you follow the code written here, all the dependency are taken care off by the code (the magic is done by those two files ending in `.toml` and the first three rows of each the two Julia scripts).

## Python

IF you never installed python, and this is your first rodeo, read the following. If you have already shed many a tear in the valley of Python versions management, in the hope of finding a light at the end of the valley of package sorrows, I don't have any word of wisdom, but my shoulder is yours to cry on (we use Python 3.13 but I don't see why we should not be back compatible with whatever Python 3.*, and we have a requirements.txt file).

For Windows:
- click on https://www.python.org/ftp/python/3.13.3/python-3.13.3-amd64.exe
- go ahead, download the file
- double click on what you downloaded and follow instructions
  - remember to tick `Add python.exe to PATH`

### Python dependencies

All the requirements are contained in the file called `requirements.txt`

If you know how to handle the situation, you don't need to read.

If you don't:
You _should_ be able to install everything following these steps:
- in the folder where `requirements.txt` 
  - run `pip install -r requirements.txt`

### Trouble shooting

If you are using Windows, with a bash terminal (e.g., git-bash)
WIP