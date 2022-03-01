#' tempFunc
#'
#' @param t is model time
#' @param simStartDay is the day of the year that the simulation starts (when t=0)
#' @param deltaT increase or decrease to temperature (oC)
#' @param constantTemp scalar value for fixed temperature (oC). Default is NA.
#' @param temperaturefile string for name of file to get temperature from. Default is NULL
#' @param init.temp scalar for initial temperature value. Default is 14.5 oC.

#' @import stats

tempFunc <- function(t,deltaT,simStartDay,constantTemp=NA,temperaturefile=NULL,init.temp=14.5){

    if (is.na(constantTemp)){
    
      if(is.null(temperaturefile)){
        
        dayOfYear=(t+simStartDay)%%365
        if(t >= 0){
            Temp = 13 + 2*(1-cos(2*pi*(t-182.5)/365))+deltaT
        } else {
            Temp = 13 + 2*(1-cos(2*pi*(0-182.5)/365))+deltaT
        }
      } else {
        
        if(t > 0){
            Temp = stats::predict(temperaturefile,t)$y+deltaT
        } else {
            Temp = stats::median(predict(temperaturefile,0:14)$y)+deltaT
        }
        
      }
        
    }else{
        Temp = constantTemp
    }
    return(Temp)
}
