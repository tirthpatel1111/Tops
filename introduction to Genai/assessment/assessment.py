import os
os.environ["TRANSFORMERS_NO_TF"] = "1"
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "3"
os.environ["KERAS_BACKEND"] = "torch"
import streamlit as st
from transformers import pipeline

st.set_page_config(page_title="Multi-Task NLP Assistant", layout="centered")


@st.cache_resource
def load_qa_model():
    return pipeline("question-answering", model="distilbert-base-cased-distilled-squad")

@st.cache_resource
def load_ner_model():
    return pipeline("ner", model="dslim/bert-base-NER", grouped_entities=True)

def load_summarization_model():
    return pipeline("summarization", model="sshleifer/distilbart-cnn-12-6")



def load_translation_model(model_name: str):
    return pipeline("translation", model=model_name)


st.sidebar.title("Choose NLP task")
task = st.sidebar.radio("Task", (
    "Text Summarization",
    "Question Answering",
    "Named Entity Recognition",
    "Translation (English → FR/ES/DE/HI)"
))

st.title("Multi-Task NLP Assistant")
st.markdown("Use the sidebar to pick a task. Enter text in the box below and run the task. Models run inside a loading spinner.")


if task == "Question Answering":
    st.header("Question Answering")
    context = st.text_area("Context paragraph", height=250)
    question = st.text_input("Question")
    if st.button("Run QA"):
        if not context.strip():
            st.error("Please provide a context paragraph.")
        elif not question.strip():
            st.error("Please type a question.")
        else:
            qa_model = load_qa_model()
            with st.spinner("Finding the answer..."):
                try:
                    result = qa_model({"question": question, "context": context})
                    st.markdown("**Answer:**")
                    st.write(result.get("answer", "(no answer returned)"))
                    st.write(f"**Score:** {result.get('score', None)}")
                except Exception as e:
                    st.error(f"Model error: {e}")

elif task == "Named Entity Recognition":
    st.header("Named Entity Recognition (NER)")
    text = st.text_area("Text to analyze", height=300)
    if st.button("Run NER"):
        if not text.strip():
            st.error("Please provide text for NER.")
        else:
            ner_model = load_ner_model()
            with st.spinner("Detecting entities..."):
                try:
                    entities = ner_model(text)
                    if not entities:
                        st.info("No entities found.")
                    else:
     
                        st.markdown("### Entities detected")
                        for ent in entities:
                            label = ent.get("entity_group", ent.get("entity", ""))
                            word = ent.get("word")
                            score = ent.get("score")
                            start = ent.get("start")
                            end = ent.get("end")
                            st.write(f"- **{label}**: `{word}` (score: {score:.3f}, span: {start}-{end})")
                except Exception as e:
                    st.error(f"Model error: {e}")

elif task == "Text Summarization":
    st.header("Text Summarization")
    text = st.text_area("Paste article or paragraph to summarize", height=350)
    max_len = st.slider("Maximum length (summary tokens)", min_value=20, max_value=300, value=120)
    min_len = st.slider("Minimum length (summary tokens)", min_value=5, max_value=200, value=30)
    if st.button("Summarize"):
        if not text.strip():
            st.error("Please provide text to summarize.")
        else:
            summarizer = load_summarization_model()
            with st.spinner("Generating summary..."):
                try:
                    summary = summarizer(
                        text,
                        max_length=max_len,
                        min_length=min_len,
                   
                        do_sample=False
                    )
                    if isinstance(summary, list) and len(summary) > 0:
                        summary_text = summary[0].get("summary_text") or str(summary[0])
                    else:
                        summary_text = str(summary)
                    st.markdown("### Summary")
                    st.write(summary_text)
                except Exception as e:
                    st.error(f"Model error: {e}")

elif task.startswith("Translation"):
    st.header("Translation (English → FR / ES / DE / HI)")
    src_text = st.text_area("English text to translate", height=250)
    target = st.selectbox("Target language", ("French (fr)", "Spanish (es)", "German (de)", "Hindi (hi)"))


    model_map = {
        "French (fr)": "Helsinki-NLP/opus-mt-en-fr",
        "Spanish (es)": "Helsinki-NLP/opus-mt-en-es",
        "German (de)": "Helsinki-NLP/opus-mt-en-de",
        "Hindi (hi)": "Helsinki-NLP/opus-mt-en-hi",  
    }
    selected_model = model_map[target]

    if st.button("Translate"):
        if not src_text.strip():
            st.error("Please provide English text to translate.")
        else:
       
            try:
                with st.spinner(f"Loading translation model ({selected_model})..."):
                    translator = load_translation_model(selected_model)
                with st.spinner("Translating..."):
                    translated = translator(src_text)
             
                    if isinstance(translated, list) and len(translated) > 0:
                        out = translated[0].get("translation_text", str(translated[0]))
                    else:
                        out = str(translated)
                    st.markdown("### Translation")
                    st.write(out)
            except Exception as e:
                st.error(f"Translation error: {e}")


st.markdown("---")
st.caption("Models from Hugging Face Transformers. Use responsibly and be aware of model biases and limits.")
