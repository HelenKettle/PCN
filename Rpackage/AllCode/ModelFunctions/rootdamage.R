rootdamage <- function(max.root.length, P.i){
  rootdamage <- max.root.length*(1-(0.835*P.i)/(32.01+P.i))
  return(rootdamage)
}