# General plan of workshop, python section
# we start as simple as possible, and build in complexity.

# For the R part (retrieval)
# we need the following ingredients:
# a collection of texts
# an embedding function
# a place where to store vectors (embedded text)
# a retrieval function (that is, a similarity or distance function)

# take zero, a few sentences, in memory, random function, whatever distance

from langchain_core.vectorstores import InMemoryVectorStore
vectorstore = InMemoryVectorStore.from_documents(
    documents=docs_list,
    embedding=embeddings
)

# take one, documents from the web
from langchain_community.document_loaders import WebBaseLoader

# need to find a chunker not based on cloud
# from langchain.text_splitter import RecursiveCharacterTextSplitter
urls = [   
    "https://www.spc.int/updates/blog/did-you-know/2025/03/stat-of-the-week-continuing-our-international-womens-day",
    "https://www.spc.int/updates/blog/did-you-know/2025/03/stat-of-the-week-kiribati-76-population-has-access-to-safely-managed-drinking-water",
    "https://www.spc.int/updates/blog/2025/03/stat-of-the-week-french-is-spoken-in-four-pacific-community-members-french",
]

## Load documents from the URLs
docs = [WebBaseLoader(url).load() for url in urls]
docs_list = [item for sublist in docs for item in sublist]
##text_splitter = RecursiveCharacterTextSplitter.from_tiktoken_encoder(
##    chunk_size=250, chunk_overlap=0
##)
## Split the documents into chunks
##doc_splits = text_splitter.split_documents(docs_list)

# take two, using a real embedder (from ollama/huggingface)
from langchain_ollama import OllamaEmbeddings
embeddings = OllamaEmbeddings(model = "snowflake-arctic-embed2")

# take three, using a proper vector database (on disk)
from langchain_chroma import Chroma
vector_store = Chroma(
    collection_name="sdd_collection",
    embedding_function=embeddings,
    persist_directory="./chroma_sdd_db",  # Where to save data locally, remove if not necessary
)
retriever = vectorstore.as_retriever()
retrieved_documents = retriever.invoke("What is Kiribati population access to safe water?")
retrieved_documents[0].page_content
