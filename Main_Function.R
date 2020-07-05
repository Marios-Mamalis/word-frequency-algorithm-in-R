# Package
library(rvest)
library(tm)
library(stringr)
library(quanteda)

# Main Function
MainFunction = function(text, stoppoint) {
  # Get Working dir
  getwd()

  # Init Dataframe
  dataframe_ = data.frame(content = character(), stringsAsFactors = FALSE)
  
  # Getting Content
  corpus = VCorpus(VectorSource(text))
  editedCorpus = tm_map(corpus, tolower)
  editedCorpus = tm_map(editedCorpus, removePunctuation)
  editedCorpus = tm_map(editedCorpus, removeNumbers)
  editedCorpus = tm_map(editedCorpus, removeWords, stopwords("english"))
  FinalText = tm_map(editedCorpus, stripWhitespace)[[1]][1]
  dataframe_[1, 1] = c(FinalText)
  
  # Words of Content
  dataframe_$Words[1] = list(c(strsplit(dataframe_[1, 1], " ")))
  
  # Filter
  Fi = read.csv(paste0(getwd(), "/Fi.csv"), header = F, stringsAsFactors = F)
  names(Fi) = c("Words", "Pos")
  
  # Filtering
  # Shrink dictionary to correct PoS
  verbdict = subset(Fi, Pos %in% c("VB", "VBD", "VBG", "VBN", "VBP", "VBZ"))
  
  JJdict = subset(Fi, Pos == "JJ")
  JJRdict = subset(Fi, Pos == "JJR")
  JJSdict = subset(Fi, Pos == "JJS")
  
  noundict = subset(Fi, Pos %in% c("NN", "NNS", "NNP", "NNPS"))
  
  # Word exists in dictionary
  containedverbs = subset(dataframe_$Words[[1]][[1]], ((dataframe_$Words[[1]][[1]] %in% verbdict$Words) == T))
  containednouns = subset(dataframe_$Words[[1]][[1]], ((dataframe_$Words[[1]][[1]] %in% noundict$Words) == T))
  containedJJ = subset(dataframe_$Words[[1]][[1]], ((dataframe_$Words[[1]][[1]] %in% JJdict$Words) == T))
  containedJJR = subset(dataframe_$Words[[1]][[1]], ((dataframe_$Words[[1]][[1]] %in% JJRdict$Words) == T))
  containedJJS = subset(dataframe_$Words[[1]][[1]], ((dataframe_$Words[[1]][[1]] %in% JJSdict$Words) == T))
  
  
  # Filtered Verbs
  dataframe_$FilteredVerbs[1] = list(c(containedverbs))
  
  # Stemmed Verbs
  text1 = paste(dataframe_$FilteredVerbs[[1]], collapse = ' ')
  corpus = VCorpus(VectorSource(text1))
  corpus = tm_map(corpus, removeWords, stopwords("english"))
  StemmedText = tm_map(corpus, stemDocument, language = "english")[[1]][1]
  dataframe_$StemmedVerbs[1] = list(c(strsplit(as.character(StemmedText), " ")))
  
  # Filter for nouns
  FiN = read.csv(paste0(getwd(), "/FiN.csv"), header = F, stringsAsFactors = F)
  names(FiN) = c("Words", "Pos", "Singular")
  
  # Nouns to Singular
  matchedids = match(c(unlist(containednouns)), unlist(FiN$Words))
  FilteredNouns = c()
  for(i in matchedids) {
    if(FiN$Singular[i] != "False") {
      FilteredNouns = append(FilteredNouns, FiN$Singular[i])
    } else {
      FilteredNouns = append(FilteredNouns, FiN$Words[i])
    }
  }
  dataframe_$SingNouns[1] = list(FilteredNouns)
  
  # Superlative Adjectives to comparative
  # Example Irregular Structure "best"
  k = 1
  for(word in containedJJS) {
    if(word!="best") {
      if(str_sub(word, start= -2)=="st") {
        containedJJS[k] = paste0(str_sub(containedJJS[k], end= -3), "r")
        k = k + 1
      } else {
        k = k + 1
      }
    } else {
      containedJJS[k] = "better"
      k = k + 1
    }
  }
  
  # Positive to Comparative
  # Example Irregular Structure "good"
  vowels = c("a", "e", "i", "o", "u", "y")
  "%!in%" <- function(x,y)!("%in%"(x,y))
  k = 1
  for(word in containedJJ) {
    if(word!="good" & nsyllable(word)<3) {
      if(str_sub(str_sub(containedJJ[k], start= -2), end=-2) %!in% vowels & str_sub(containedJJ[k], start= -1) %!in% vowels) {
        containedJJ[k] = paste0(containedJJ[k], "er")
        k = k + 1
      } else if(str_sub(containedJJ[k], start= -1)=="y") {
        containedJJ[k] = paste0(str_sub(containedJJ[k], end = -2), "ier")
        k = k + 1
      } else if(str_sub(containedJJ[k], start= -1) %in% vowels) {
        containedJJ[k] = paste0(containedJJ[k], "r")
        k = k + 1
      } else if(str_sub(str_sub(containedJJ[k], start= -2), end=-2) %in% vowels & str_sub(containedJJ[k], start= -1) %!in% vowels) {
        containedJJ[k] = paste0(containedJJ[k], str_sub(containedJJ[k], start = -1), "er")
        k = k + 1
      } else {
        k = k + 1
      }
    } else if(word=="good") {
      containedJJ[k] = "better"
      k = k + 1
    } else {
      k = k + 1
    }
  }
  
  # Combine all parts: 
  adjectives = c(containedJJ, containedJJR, containedJJS)
  verbs = dataframe_$StemmedVerbs[[1]][[1]]
  nouns = dataframe_$SingNouns[[1]]
  WordCount = c(adjectives, verbs, nouns)
  WordCount = subset(WordCount, nchar(WordCount)>2)
  
  # Top Word Frequency
  allfrequency = sort(table(WordCount), decreasing = T)
  return(allfrequency[1:stoppoint])
}
