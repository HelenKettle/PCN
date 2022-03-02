#' deathJ
#'
#' death rate of juveniles
#' Eq 15 Ewing et al 2021
#'
#' @param Temp current temperature (oC) 
#' @param PE proportion of eggs becoming Juvs
#' @param tauJ length of juvenile stage (d)
#' @param potato.presence 0 or 1 indicating whether potatoes are in the soil
#' 
deathJ <- function(Temp,PE,tauJ,potato.presence){

    af <- 0.25 # (S_opt) optimal larval survival proportion (phillips et al 1991)
    bf <- 17.26803 #(T_PJ) Temp of optimum combined egg and juv survival (oC) (Skelsey et al 2018)
    cf <- 7.51460 #(w) shape of E and J temperatuer-survival distribution  (Skelsey et al 201

    if (potato.presence==1){
        
        if (1-((Temp-bf)/cf)^2 < 0){

            deathJ <- 1

        }else{
            
            survEJ <- af*(1-((Temp-bf)/cf)^2)
            survJ <- survEJ/PE
            deathJ <- (-1/tauJ)*log(survJ)
        }
    

    }else{

        deathJ <- 10
        
    }
    
    
    return(deathJ)
}
