# This function expands a TPM to have all pitch entries from 0 to a specified maximum note
FillMatrix <- function(matrix, max.note){
  D = diag(nrow = max.note+1) # Create an Identity Matrix (need +1 to create a state for rests )
  numericlabels = seq(0,max.note) # Create numeric labels for the rows of D
  rownames(D) = as.character(numericlabels) # Turn the rows to strings so they match row names in input matrix
  colnames(D) = rownames(D)
  # Iterate over each matrix entry in the input matrix and add it to D
  for (row in rownames(matrix)){ 
    for (col in colnames(matrix)){
      #print(row,col)
      if (D[row,col] != matrix[row,col]){
        D[row,col] = matrix[row,col]
      }
    }
  }
  return(D)
}


#Function to Normalize Matrix
Normalize = function(M){
  newM = M
  for (r in rownames(M)){
    if(sum(M[r,])==0){
      newM[r,] = rep(1/length(M[r,]),length(M[r,]))
    }
    else{
      newM[r,] = M[r,]/sum(M[r,])
    }
    
  }
  return(newM)
}