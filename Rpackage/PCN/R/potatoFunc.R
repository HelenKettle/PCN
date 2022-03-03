#' potatoFunc
#'
#' returns 0 if no potatoes present at time t, returns 1 if potatoes are present
#' 
#' @param t is model time (d)
#' @param simStartDay is the day of the year the simulation starts (where t=0)
#' @param plantingDOY is day of year potatoes are planted
#' @param harvestingDOY is day of year potatoes are harvested
#' @param plantingYears end of fallow period

potatoFunc <- function(t,simStartDay,plantingDOY,harvestingDOY,plantingYears=seq(1,1000)){
    
    dayOfYear=(t+simStartDay)%%365
    
    year=1+((t+simStartDay)%/%365) 
    
    potatoPresent = 0
    
    if (year%in%plantingYears){

        if (dayOfYear>=plantingDOY  & dayOfYear<=harvestingDOY){
            potatoPresent = 1
        }

    }

    
    return(potatoPresent)
}

