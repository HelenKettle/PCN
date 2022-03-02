#' growthE
#'
#' growth rate of eggs (/d) See Eq 11 in Ewing et al 2021
#' Based on Kaczmarek et al 2014
#'
#' @param Temp current temperature (oC)
#' 
growthE <- function(Temp){
    
    Hopt <- 9.6 #(e_opt) mean duration of egg development (d) at optimum temp
    Topt <- 18.7 #optimum temp for egg development (oC)
    w <- 3.4 #shape factor
    
    growthE = 1/(Hopt + ((Temp-Topt)/w)^2)

    return(max(0.001,growthE))

}
