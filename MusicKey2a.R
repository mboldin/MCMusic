## Markov Chain Music Key analysis  ---
##   code from S Berger Nov 20222
## title: "Creating Standard Matrix"   RMD html_notebook

library(markovchain)
library(igraph)
library(DiagrammeR)
library(ggplot2)

###########################################

# Function to Expand a Matrix to have Correct Number Rows/Cols
ExpandMatrix <- function(matrix, matrixsize){
  init.matrix = matrix
  existingrows = row.names(init.matrix)
  nrowsfinal = matrixsize
  allrows = c(0:(nrowsfinal-1))
  onepos = 1
  Xentries = c()
  pos = 1
  for (rname in allrows){
    if (rname %in% existingrows){
      newXcol = c(rep(0, times = length(existingrows)))
      newXcol[pos] = 1
      Xentries = c(Xentries,newXcol)
      pos = pos+1
    }
    else{
      newXcol = c(rep(0, times = length(existingrows)))
      Xentries = c(Xentries,newXcol)
    }
    
  }
  Xrownames = existingrows
  Xcolnames = as.character(c(0:(nrowsfinal-1)))
  X = matrix(data= Xentries, ncol = nrowsfinal, nrow = length(existingrows),dimnames = list(Xrownames, Xcolnames))
  XT = t(X)
  #print(XT)
  #print(X)
  E = XT %*% init.matrix %*% X
  #Need to add in 1 in all rows that have just 0s to make a valid TPM
  colsums = colSums(E)
  count = 1
  for( c in colsums){
    if (c == 0){
      E[count,count] = 1
    }
    count = count+1
  }
  return(E)
}
###############################################

#Creating Shifting Matrix for Up 1 Half Step
##  TODO  turn into a function
MaxNote = 88
MinNote = 52
D = MaxNote-MinNote +2  #Add plus 1 for Zero Row and Plus 1 to make sure both Pitch 52 and 88 have a row
#This means that each MC will have a 36x36 TPM

S1 = c(1,rep(0,times = D-1),rep(0,times = D-1),1)
S2 = S1
for (k in 1:(D-2)){
  newrow = c(rep(0,times = k),1,rep(0,D-k-1))
  S2 = c(S2,newrow)
}
ShiftUp = matrix(data = S2,nrow = D, byrow = T)
#ShiftUp
dim(ShiftUp)

S = ShiftUp

#################################################
# Read in Song1 from csv File

setwd('C:/Users/mdbol/Desktop/GIT/MyProjects/MCMusic')

Song1a = read.csv("Beauty_and_Beast_melody.csv") 
names(Song1a) = c("Pitch_Num","MIDI_Pitch")
head(Song1a)

## Clean up
#Notes = drop_na(Notes)
#a = which(Notes == NA)
a <-  is.na(Song1a$Pitch_Num)
a <-  is.na(Song1a$MIDI_Pitch)
Song1a[a,]

#Reading in Some Songs in G Major
Bach1Notes = read.csv("BWV-1087-05.midiChan1.csv",col.names = c("Pitch_Num","MIDI_Pitch"))
head(Bach1Notes)
#Bach1Notes = drop_na(Bach1Notes)
#Bach1Notes = c(Bach1Notes$MIDI_Pitch)
B1L = length(Bach1Notes)

#From Jesu bleibet meine Freude
Bach2Notes = c(0,67,69,71,74,72,72,76,74,74,79,78,79,74,71,67,69,71,72,74,76,74,72,71,69,71,67,66,67,69,62,66,69,72,71,69,71,67,69,71,74,72,72,76,74,74,79,78,79,74,71,67,69,71,64,74,72,71,69,67,62,67,66,67,71,74,79,74,71,67,71,74,71,72,74,74,72,71,69,69,0,71,72,74,71,69,71,72,71,69,67,0)

#Happy Birthday
HBNotesG = c(62,62,64,62,67,66,62,62,64,62,69,67,62,62,74,71,67,66,64,72,72,71,67,69,67)

#Yankee Doodle
YDNotesG = c(67,67,69,71,67,71,69,62,67,67,69,71,67,66,67,67,69,71,72,71,69,67,66,62,64,66,67,67,64,66,64,62,64,66,67,62,64,62,60,59,62,64,66,64,62,64,66,67,64,62,67,66,69,67,67)

###########################################
## Key Change Analysis

# Creating Standard Matrix in G Major
Matrix_Bach1 = markovchainFit(data = Bach1Notes, method = "mle")
Matrix_Bach1 = ExpandMatrix(Matrix_Bach1$estimate@transitionMatrix,MaxNote+1) #MaxNote defined Above
Matrix_Bach1 = Matrix_Bach1[-2:-MinNote,-2:-MinNote]
dim(Matrix_Bach1)

Matrix_Bach2 = markovchainFit(data = Bach2Notes, method = "mle")
Matrix_Bach2 = ExpandMatrix(Matrix_Bach2$estimate@transitionMatrix,MaxNote+1) #MaxNote defined Above
Matrix_Bach2 = Matrix_Bach2[-2:-MinNote,-2:-MinNote]
dim(Matrix_Bach2)

Matrix_HB = markovchainFit(data = HBNotesG, method = "mle")
Matrix_HB = ExpandMatrix(Matrix_HB$estimate@transitionMatrix,MaxNote+1) #MaxNote defined Above
Matrix_HB = Matrix_HB[-2:-MinNote,-2:-MinNote]
dim(Matrix_HB)

Matrix_YD = markovchainFit(data = YDNotesG, method = "mle")
Matrix_YD = ExpandMatrix(Matrix_YD$estimate@transitionMatrix,MaxNote+1) #MaxNote defined Above
Matrix_YD = Matrix_YD[-2:-MinNote,-2:-MinNote]
dim(Matrix_YD)

## Combine Markov transitions to
###  Create Master Standard Matrix in G Major
B2L= length(Bach2Notes)
HBL = length(HBNotesG)
YDL = length(YDNotesG)
sum = B1L + B2L + HBL + YDL
G = ((B1L/sum)*Matrix_Bach1) + ((B2L/sum)*Matrix_Bach2) + ((HBL/sum)*Matrix_HB) + ((YDL/sum)*Matrix_YD)

## Test code logic

## Use 3 keys  G A Eb

KG = G

K = G
K = S %*% K  %*% t(S)
KAb = K
K = S %*% K  %*% t(S)
KA = K

K = S %*% K  %*% t(S)
K = S %*% K  %*% t(S)
K = S %*% K  %*% t(S)
K = S %*% K  %*% t(S)
K = S %*% K  %*% t(S)
K = S %*% K  %*% t(S)
KEb = K

## Song notes to test
Song = Song1a
Song= YDNotesG

## Need to keep 0 rest numbers if key shift is appplied 
a = which(Song == 0)
shift = 0 
Song = Song + shift
#Song[a] = 0

## Keys and key for song
keys = c('G','Ab', 'A', 'Bb', 'B', 'C', 'Db', 'D', 'Eb', 'F', 'F#', 'G' )
Skey = keys[shift+1]
Skey = 'Eb'

## Song transition matrix
M = markovchainFit(data = Song, method = "mle")
M = ExpandMatrix(M$estimate@transitionMatrix,MaxNote+1) #MaxNote defined Above
M = M[-2:-MinNote,-2:-MinNote]
dim(M)

## Best key match for Beauy adn Beast song shoud be Eb 
V1 = sum((M - KG)^2)
V2 = sum((M - KAb)^2)
V3 = sum((M - KA)^2)
V4 = sum((M - KEb)^2)
c(V1,V2,V3,V4)


## Run loop to find best key

## Starting with Master Key (G)
K = G
vx = sum((M - K)^2)
v = c(vx)
#c(dim(K), dim(M))

## loop over all keys to measure fit measure of each Key Matrix to Test song
for (k in seq(1,11)) {
    #print(k)    
    ## Adjust Master Key up one half step to compare to test song
    ##  Need to pre and post multiple by Shift matrix to move up one-half  
    K = S %*% K  %*% t(S)
    ## Evalute fit and add to vector of fits
    vx = sum((M - K)^2)
    v = c(v,vx)
}

## Results for comparing test song transition matrix to all keys
print('Song-Key test stats -- low is better')
v = round(v,4)
print( v )

best = min(v)
b = which(v == best)
print('Best key and shift key')
print(c(b,keys[b],Skey,shift,best,mean(v)))

plot(x = seq(1,12), y=v) ## xlab=keys)

