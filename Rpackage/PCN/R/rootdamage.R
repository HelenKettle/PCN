#' rootdamage
#'
#' returns root length based on damage caused by PCN. Eqs 18-19 Ewing et al. 2021
#' based on Phillips et al. 1991
#'
#' @param max.root.length max root length in cm
#' @param P.i density of eggs per gram of soil at start of growing season
#'
#' @return the root length
#' 
rootdamage <- function(max.root.length, P.i){
    
    rootdamage <- max.root.length*(1-(0.835*P.i)/(32.01+P.i))

    return(rootdamage)
}
