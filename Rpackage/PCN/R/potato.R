#' potato
#'
#' returns 0 if no potatoes present at time t, returns 1 if potatoes are present
#' 
#' @param t is model time (d)
#' @param simStartDay is the day of the year the simulation starts (where t=0)
#' @param plantingDOY is day of year potatoes are planted
#' @param harvestingDOY is day of year potatoes are harvested
#' @param noPotatoYearsStart start of fallow period 
#' @param noPotatoYearsFinish end of fallow period

potato <- function(t,simStartDay,plantingDOY,harvestingDOY,noPotatoYearsStart,noPotatoYearsFinish){
    
    dayOfYear=(t+simStartDay)%%365

    year=1+((t+simStartDay)%/%365) 
    
    # Add this line to run things on a six year rotation with potatoes in year 1,7,13,...
    year = ((year-1) %% 6)+1

    potatoPresent = 1
    
    if (year>=noPotatoYearsStart & year<=noPotatoYearsFinish){
        potatoPresent = 0
    }

    if (dayOfYear > harvestingDOY | dayOfYear < plantingDOY){
        potatoPresent = 0
    }
    
    return(potatoPresent)
}

