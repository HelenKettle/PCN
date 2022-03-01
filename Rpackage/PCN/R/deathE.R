#' deathE
#' Function to calculate egg "mortality", where mortality is actually those individuals which will never hatch or will enter a diapausing state
#' Eq 12-13 Ewing et al 2021
#' 
#' @param Temp current temperature (oC)
#' @param tauE duration of egg stage (d)
#' @param Copt Egg hatch proportion under optimum conditions (h_opt in Ewing et al 2021) 

deathE <- function(Temp,tauE,Copt){
  Topt <- 18.4
  w <- 11.7
  if(1-((Temp-Topt)/w)^2 < 0){
    deathE <- 1
  } else {
    deathE <- (-1/tauE)*log(Copt*(1-((Temp-Topt)/w)^2))
  }
  return(deathE)
}
