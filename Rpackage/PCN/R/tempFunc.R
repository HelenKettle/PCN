#' tempFunc
#'
#' Use this function if temperature is not constant
#' 
#' @param t is model time
#' @param deltaT increase or decrease to temperature (oC)
#' @param simStartDay is the day of the year that the simulation starts (when t=0)
#' @param temperatureSpline output from smooth.spline fitted through temperature data. Default is NULL
#'
#' @import stats
#'
#' @export
tempFunc <- function(t,deltaT,simStartDay,temperatureSpline=NULL){

    
    if (is.null(temperatureSpline)){
        
        dayOfYear = (t+simStartDay)%%365
        
        offSet=100
        
        meanTemp=13
        
        amplitude=2
        
        if(t >= 0){
            Temp = meanTemp + amplitude*sin(2*pi*(dayOfYear-offSet)/365) + deltaT
        } else {
            Temp = meanTemp + amplitude*sin(2*pi*(simStartDay-offSet)/365) + deltaT
        }
        
    } else {
        
        if(t > 0){
            Temp = stats::predict(temperatureSpline,t)$y+deltaT
        } else {
            Temp = stats::median(predict(temperatureSpline,0:14)$y)+deltaT
        }
        
    }
    
    
    
    return(Temp)
}
