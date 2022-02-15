female.prop <- function(N.Juv,resistanceFactor=0,fixedGenderRatio=NULL,root.length){
  # Function to determine the proportion of adults which will be female given juvenile density.
  
    sex.ratio <- (0.424458+0.084064*(N.Juv/root.length))
    female.prop.max <- 1-(sex.ratio/(sex.ratio+1))
    female.prop <- (1-resistanceFactor)*female.prop.max
    return(female.prop)
    
}
