# NLP_Coursera_Capstone
### Coursera Data Science Capstone

This repository contains the code for the Coursera Data Science Capstone project. N-grams is the model of choice. The goal is to take a dataset provided by SwiftKey and create an NLP (natural language processing) model that is able to predict subsequent words.

### Dataset

The data includes over 3 millions documents from twitter, blogs and news in the US. After cleaning up, a sample is taken from the data to build ngrams dictionary. Initial models use roughly 30k to 50k observations which produces acceptable dictionaries. However, as a proof of concept, the final model uses over 200k observations which results in a comprehensive bigram, trigram and quadgram dictionary.

Some main ideas for cleaning:

- The order of cleaning functions matters greatly. (ex: replace contraction must be before remove punctuation,...).
- Include the end of sentence tag (<EOS>) and then remove it from the dictionary will reduce the dictionary size by about 10% - 20%.
- Do not remove stop words but one should remove ([badwords](https://github.com/LDNOOBW/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words/blob/master/en)). 

### Model Overview
- N-gram model with "Katz Backoff" ([Bill MacCartney, 2005](https://nlp.stanford.edu/~wcmac/papers/20050421-smoothing-tutorial.pdf))
- Clean the input to the same format used in the ngram models.
- Checks if highest-order (in this case, n = 4) n-gram has been seen. If not "degrades" to a lower-order model (n = 3, 2).
- There are multiple implementation of the model from using only 1 dictionary to using only bigram dictionary.
- The final model uses a huge dictionary thus it is quite accurate. However, it suffers from slow prediction time. Other models are also included in the reposite.

### Runtime Issues

With a huge dataset, creating and storing ngrams dictionary should be the main priority. Traditional methods from the tm package is very slow and requires enormous amount of RAM to run. Since tm requires documents in the corpus form, it also requires an additional steps to build our dictionaries. Luckily, the new ngram package by Hadley Wickham solves this issue quite nicely. It bypass the whole corpus process and create an ngram object with just a fraction of a time. Moreover, it can creates a whole dictionary in 3 steps: concatenate, ngram and get.phrasetable.

Storing dictionaries as .RDS seems to be the optimal choice. Using Hashmap/Hashtable is a good alternative but the algorithm have to change significantly. The size of bigrams + trigrams + quadgrams dictionary are less than 100 MB.

Note that we can bypass creating 3 dictionaries by using only quadgrams model. This is because quadgrams includes all structures from bigrams and trigrams. However, this will slows down the algorithm by 20 - 30% which is undesirable. (and some accuracy)

### Shiny Application
The app is hosted [here]("https://j-wang.shinyapps.io/ngram_predictor/").

- You input a string. 
- The algorithm will return the top 10 possibilities.

### Pros and Cons
- The algorithm is very powerful and can predict with high accuracy. However, it tradeoffs speed. 
- Katz Smoothing method is simple to implemented and works most of the time. Nevertheless, it is still limited by the amount of dictionary.
- More sophisticated algorithm with context would increase both speed, accuracy and decrease datasize. However, implementing this will takes much more time.
