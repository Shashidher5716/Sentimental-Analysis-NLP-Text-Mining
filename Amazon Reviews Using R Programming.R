### TEXT MINING ###
########## AMAZON REVIEWS EXTRACTION ##########

# Loading the Libraries

install.packages('rvest')
install.packages('XML')
install.packages('magrittr')
install.packages('dplyr')
install.packages('xml2')
install.packages("swirl", repos="http://cran.rstudio.com/", dependencies=TRUE)



library(rvest)
library(XML)
library(magrittr)
library(dplyr)
library(xml2)
library(swirl)


########## AMAZON URL ##########

aurl<-read_html("https://www.amazon.in/OnePlus-Nord-Jade-128GB-Storage/product-reviews/B0B3CPQ5PF/ref=cm_cr_arp_d_paging_btm_next_2?ie=UTF8&reviewerType=all_reviews&pageNumber") 

amazon_reviews <- NULL

for (i in 1:20){
  murl<-read_html(as.character(paste(aurl,i,sep='=')))
  rev<-murl %>% html_nodes(".review-text") %>% html_text()
  amazon_reviews <-c(amazon_reviews,rev)
}

?html_nodes
?html_text

# Storing the Reviews

write.table(amazon_reviews, "OnePlusNode2T.txt")
#getcwd()


########### Sentimental Analysis ##########
### txt - Amazon Reviews

txt <- amazon_reviews

str(txt)

# tm - text mining

install.packages('tm')
library(tm)

# Convert the character data to corpus type
x <- Corpus(VectorSource(txt))

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
