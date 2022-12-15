library(rvest)
library(XML)
library(magrittr)
library(tm)
library(wordcloud)
library(syuzhet)
library(lubridate)
library(ggplot2)
library(scales)
library(reshape2)
library(dplyr)

# IMDBReviews #############################
aurl <- "https://www.imdb.com/title/tt1477834/reviews?ref_=tt_ov_rt"
IMDB_reviews <- NULL
for (i in 1:10){
  murl <- read_html(as.character(paste(aurl,i,sep="=")))
  rev <- murl %>%
    html_nodes(".show-more__control") %>%
    html_text()
  IMDB_reviews <- c(IMDB_reviews,rev)
}
length(IMDB_reviews)


# Storing the Reviews

write.table(IMDB_reviews, "IMDB.txt")
#getcwd()


########### Sentimental Analysis ##########
### txt - Movies Reviews

txt1 <- IMDB_reviews

str(txt1)


# tm - text mining

install.packages('tm')
library(tm)


# Convert the character data to corpus type
x <- Corpus(VectorSource(txt1))

inspect(x[1])


# Converting to utf8 format
x <- tm_map(x, function(x) iconv(enc2utf8(x), sub = 'byte'))
?tm_map

# Data Cleaning
x1 <- tm_map(x, tolower)
inspect(x1[1])

x1 <- tm_map(x1, removePunctuation)
inspect(x1[1])

x1 <- tm_map(x1, removeNumbers)
inspect(x1[1])

x1 <- tm_map(x1, removeWords, stopwords('english'))
inspect(x1[1])

# striping white spaces
x1 <- tm_map(x1, stripWhitespace)
inspect(x1[1])

#Term Document Matrix
# converting unstructured data to structured format using TDM

tdm <- TermDocumentMatrix(x1)
tdm

dtm <- DocumentTermMatrix(x1)
dtm

tdm <- as.matrix(tdm)
dim(tdm)

tdm[1:10, 1:10]


##### Word Cloud #####
install.packages('wordcloud')
library(wordcloud)

w_sub1 <- sort(rowSums(tdm), decreasing = TRUE)
head(w_sub1)

wordcloud(words = names(w_sub1), freq = w_sub1) # all 

# better Visualization
?wordcloud
wordcloud(words = names(w_sub1), freq = w_sub1, random.order = F, colors=rainbow(30), scale=c(2,1), rot.per=0.4)

windows()
wordcloud(words = names(w_sub1), freq = w_sub1, random.order = F, colors=rainbow(30), scale=c(2,1), rot.per=0.4)

w <- rowSums(tdm)
w_sub2 <- subset(w, w >= 25)
windows()
wordcloud(words = names(w_sub1), freq = w_sub1, random.order = F, colors=rainbow(30), scale=c(2,1), rot.per=0.4)

install.packages('wordcloud2')
library(wordcloud2)
?wordcloud2

w1 <- data.frame(names(w_sub2), w_sub2)
colnames(w1) <- c('word', 'freq')

wordcloud2(w1, size=0.3, shape='circle')

wordcloud2(w1, size=0.3, shape='triangle')

wordcloud2(w1, size=0.3, shape='star')
