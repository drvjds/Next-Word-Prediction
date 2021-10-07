#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny); library(stringr); library(tm)

# Loading bigram, trigram and quadgram frequencies words matrix frequencies
bg <- readRDS("bigram_data.RData"); tg <- readRDS("trigram_data.RData"); qd <- readRDS("quadgram_data.RData")

names(bg)[names(bg) == 'word1'] <- 'w1'; names(bg)[names(bg) == 'word2'] <- 'w2';
names(tg)[names(tg) == 'word1'] <- 'w1'; names(tg)[names(tg) == 'word2'] <- 'w2'; names(tg)[names(tg) == 'word3'] <- 'w3';
names(qd)[names(qd) == 'word1'] <- 'w1'; names(qd)[names(qd) == 'word2'] <- 'w2'; names(qd)[names(qd) == 'word3'] <- 'w3'
names(qd)[names(qd) == 'word4'] <- 'w4';
message <- "" ## cleaning message

## Function predicting the next word
predictWord <- function(the_word) {
    word_add <- stripWhitespace(removeNumbers(removePunctuation(tolower(the_word),preserve_intra_word_dashes = TRUE)))
    the_word <- strsplit(word_add, " ")[[1]]
    n <- length(the_word)

    #check Bigram
    if (n == 1) {the_word <- as.character(tail(the_word,1)); functionBigram(the_word)}
    
    #check trigram
    else if (n == 2) {the_word <- as.character(tail(the_word,2)); functionTrigram(the_word)}
    
    #check quadgram
    else if (n >= 3) {the_word <- as.character(tail(the_word,3)); functionQuadgram(the_word)}
}
########################################################################
functionBigram <- function(the_word) {
    if (identical(character(0),as.character(head(bg[bg$w1 == the_word[1], 2], 1)))) {
        message<<-"If no word found the most used pronoun 'it' in English will be returned" 
        as.character(head("it",1))
    }
    else {
        message <<- "Trying to Predict the Word using Bigram Freqeuncy Matrix  "
        as.character(head(bg[bg$w1 == the_word[1],2], 1))
    }
}

functionTrigram <- function(the_word) {
    if (identical(character(0),as.character(head(tg[tg$w1 == the_word[1]
                                                    & tg$w2 == the_word[2], 3], 1)))) {
        as.character(predictWord(the_word[2]))
    }
    else {
        message<<- "Trying to Predict the Word using Trigram Fruequency Matrix "
        as.character(head(tg[tg$w1 == the_word[1]
                             & tg$w2 == the_word[2], 3], 1))
    }
}

functionQuadgram <- function(the_word) {
    if (identical(character(0),as.character(head(qd[qd$w1 == the_word[1]
                                                    & qd$w2 == the_word[2]
                                                    & qd$w3 == the_word[3], 4], 1)))) {
        as.character(predictWord(paste(the_word[2],the_word[3],sep=" ")))
    }
    else {
        message <<- "Trying to Predict the Word using Quadgram Frequency Matrix"
        as.character(head(qd[qd$w1 == the_word[1] 
                             & qd$w2 == the_word[2]
                             & qd$w3 == the_word[3], 4], 1))
    }       
}

## ShineServer code to call the function predictWord
shinyServer(function(input, output) {
    output$prediction <- renderPrint({
        result <- predictWord(input$inputText)
        output$sentence2 <- renderText({message})
        result
    });
    output$sentence1 <- renderText({
        input$inputText});
}
)