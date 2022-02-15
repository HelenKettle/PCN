growthJ <- function(Temp,tauE){

    a0 <- 41.628
    b0 <- 20.675
    c0 <- 1.845
  
    recip.growthJ <- a0 + ((Temp-b0)/c0)^2 - tauE
    growthJ <- 1/recip.growthJ
    return(max(0.001,growthJ))
}
