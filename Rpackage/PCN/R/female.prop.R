#' female.prop
#' 
#' Function to determine the proportion of adults which will be female based on juvenile density.
#' @param N.Juv Number of juveniles
#' @param resistanceFactor plant resistance - this determines proportion of J that become A
#' @param fixedGenderRatio fixed gender ratio - default is NULL
#' @param root.length root length (cm)
#'
#' @return proportion of adults which are female
#' 
female.prop <- function(N.Juv,resistanceFactor=0,fixedGenderRatio=NULL,root.length){

  
    sex.ratio <- (0.424458+0.084064*(N.Juv/root.length))
    female.prop.max <- 1-(sex.ratio/(sex.ratio+1))
    female.prop <- (1-resistanceFactor)*female.prop.max
    return(female.prop)
    
}
