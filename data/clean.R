##Cleaning Latin characters
odd_clean <- function(x){
    x <- iconv(x, "latin1", "ASCII", sub = "")
    return(x)
}

##Remove unwanted elements
remove_clean <- function(x){
    x <- replace_contraction(x)
    x <- str_replace_all(x, " www(.+) ", "")
    x <- str_replace_all(x, " ?(f|ht)tp(s?)://(.*)[.][a-z]+", "")
    x <- replace_abbreviation(x)
    x <- str_replace_all(x, "\\. |\\.$"," <EOS> ")
    x <- removePunctuation(x)
    x <- str_replace_all(x, "EOS","<EOS>")
    x <- removeWords(x, bad_words)
    x <- stripWhitespace(x)
    return(x)
}

bad_words <- readLines("./bad_words.txt")

##Transform all to text 
replace_clean <- function(x){
    x <- replace_ordinal(x)
    x <- removeNumbers(x)
    x <- replace_symbol(x)
    x <- tolower(x)
    return(x)
}