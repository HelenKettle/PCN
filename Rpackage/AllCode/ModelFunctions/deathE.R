deathE <- function(Temp,tauE,Copt){
  # Function to calculate egg "mortality", where mortality is actually those individuals which will never hatch or will enter a diapausing state
  Topt <- 18.4
  w <- 11.7
  if(1-((Temp-Topt)/w)^2 < 0){
    deathE <- 1
  } else {
    deathE <- (-1/tauE)*log(Copt*(1-((Temp-Topt)/w)^2))
  }
  return(deathE)
}
