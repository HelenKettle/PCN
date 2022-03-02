#' female.prop
#' 
#' Function to determine the proportion of adults which will be female based on juvenile density.
#' @param N.Juv Number of juveniles
#' @param root.length root length (cm)
#' @param resistanceFactor plant resistance factor - this determines proportion of J that become A (see Table 1 Ewing et al 2021) Note this is different to resistance rating
#' @param fixedGenderRatio fixed gender ratio - default is NULL
#'
#' @return proportion of adults which are female
#' 
female.prop <- function(N.Juv,root.length,resistanceFactor=0,fixedGenderRatio=NULL){

    #HK made changes 01/03/22 (resistanceFactor error and fixedGenderRatio assignment)

    if (resistanceFactor>1 | resistanceFactor<0){
        stop('resistanceFactor must be between 0 and 1. See Table in Ewing et al 2021')
    }
    
    if (is.null(fixedGenderRatio)){
        
        sex.ratio <- (0.424458+0.084064*(N.Juv/root.length))
        female.prop.max <- 1-(sex.ratio/(sex.ratio+1))
        fprop <- (1-resistanceFactor)*female.prop.max

    }else{

        fprop=fixedGenderRatio
    }

    
    
    return(fprop)
    
}
