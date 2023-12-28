# Create Function to Label MIDI Pitches with Notes

label.Notes = function(pitch.list){
  Chart = read.csv("Pitches_Freq.csv")
  #print(Chart)
  labels = c()
  for (p in pitch.list){
    #print(p)
    row = Chart %>% filter_all(any_vars(. %in% c(p)))
    #print(row)
    Pitch = as.character(row[2])
    labels = c(labels,Pitch)
  }
  return(labels)
}

# Create Function to Group Labeled Pitches by Note Name
group.Notes = function(pitches){
  Gcount = 0
  Gscount = 0
  Acount = 0
  Bfcount = 0
  Bcount = 0
  Ccount = 0
  Cscount = 0
  Dcount =0
  Dscount = 0
  Ecount = 0
  Fcount =0
  Fscount = 0
  for (p in pitches){
    s = substr(p,1,2) #Use substring function to extract just pitch name
    if (s == "Gn"){
      Gcount = Gcount + 1
    }
    if (s== "G#"){
      Gscount = Gscount+1
    }
    if (s== "Ab"){
      Gscount = Gscount+1
    }
    if (s== "An"){
      Acount = Acount+1
    }
    if (s== "A#"){
      Bfcount = Bfcount+1
    }
    if (s== "Bb"){
      Bfcount = Bfcount+1
    }
    if (s== "Bn"){
      Bcount = Bcount+1
    }
    if (s== "Cn"){
      Ccount = Ccount+1
    }
    if (s== "C#"){
      Cscount = Cscount+1
    }
    if (s== "Db"){
      Cscount = Cscount+1
    }
    if (s== "Dn"){
      Dcount = Dcount+1
    }
    if (s== "D#"){
      Dscount = Dscount+1
    }
    if (s== "Eb"){
      Dscount = Dscount+1
    }
    if (s== "En"){
      Ecount = Ecount+1
    }
    if (s== "Fn"){
      Fcount = Fcount+1
    }
    if (s== "F#"){
      Fscount = Fscount+1
    }
    if (s== "Gb"){
      Fscount = Fscount+1
    }
  }
  vector = c(Gcount, Gscount, Acount, Bfcount, Bcount, Ccount,Cscount,Dcount,Dscount,Ecount,Fcount,Fscount)
  return(vector/sum(vector))
}

# This function creates a matrix which counts the proportion of each pitch class in every transposition of the song
# NOTE SONGS SHOULD BE IN G MAJOR BEFORE USING THIS FUNCTION 
transpose.Song = function(Notes){
  l = Notes[which(Notes !=0)]
  L = label.Notes(l)
  G = group.Notes(L)
  G = round(G,digits=3)
  percent.list = c("GN",G)
  names = c('Ab', 'AN', 'Bb', 'BN', 'CN', 'Db', 'DN', 'Eb','EN', 'FN', 'FS' )
  for (s in 1:11){
    l = l+1
    L = label.Notes(l)
    G = group.Notes(L)
    G = round(G,digits=3)
    percent.list = c(percent.list,names[s],G)
    s = s+1
  }
  M = matrix(percent.list,nrow = 12,ncol = 13,byrow = T)
  names = c('Abcount', 'ANcount', 'Bbcount', 'BNcount', 'CNcount', 'Dbcount', 'DNcount', 'Ebcount','ENcount', 'FNcount', 'FScount' )
  colnames = c('Key','GNcount',names)
  colnames(M) = colnames
  return(M)
  
}
