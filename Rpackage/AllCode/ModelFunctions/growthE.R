growthE <- function(Temp){
    
  Hopt <- 9.6
  Topt <- 18.7
  w <- 3.4
  growthE = 1/(Hopt + ((Temp-Topt)/w)^2)
  return(max(0.001,growthE))
}
