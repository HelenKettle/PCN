#' growthJ
#'
#' specific growth rate of juveniles (Eq. 14 Ewing et al. 2021)
#'
#' @param Temp current temperature (oC)
#' @param tauE mean time until hatching (d)
#'
#' @return juvenile growth rate (/d)

growthJ <- function(Temp,tauE){

    a0 <- 41.628 #(j_opt) mean duration of egg and juv development at optimum temp
    b0 <- 20.675 #(Tgj) optimum temp
    c0 <- 1.845 #(wgj) shape factor
  
    recip.growthJ <- a0 + ((Temp-b0)/c0)^2 - tauE
    growthJ <- 1/recip.growthJ

    return(max(0.001,growthJ))
}
