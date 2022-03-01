#' deathJ
#'
#' death rate of juveniles
#'
#' @param Temp current temperature (oC) 
#' @param PE ???
#' @param tauJ length of juvenile stage (d?)
#' @param potato.presence 0 or 1 indicating whether potatoes are in the soil
#' 
deathJ <- function(Temp,PE,tauJ,potato.presence){

    af <- 0.25
    bf <- 17.26803
    cf <- 7.51460

    if(1-((Temp-bf)/cf)^2 < 0){
      deathJ <- 1
    } else {
      survEJ <- af*(1-((Temp-bf)/cf)^2)
      survJ <- survEJ/PE
      deathJ <- (-1/tauJ)*log(survJ)
    }
    if(potato.presence == 0){
      deathJ <- 10
    }
    return(deathJ)
}
