#' PCNmodel
#'
#' @param numYears Integer. Number of years to simulate
#' @param simStartDay Integer. Day of the year the simulation starts. Defaults to 0
#' @param initialEggsPerGram Scalar. Initial egg density. Defaults to 0.1 eggs per gram of soil
#' @param soil.density Scalar. Soil density (g/cm^3). Defaults to 1.5 g/cm^3
#' @param plantingDOY Integer. Potatoes planted on this day of the year. Defaults to 90
#' @param harvestingDOY Integer. Potatoes harvested on this day of the year. Defaults to 216
#' @param plantingYears Vector of integers which are the years potatoes are planted. Default is 1:1000
#' @param lifecycle.pars list containing parameters controlling the PCN lifecycle
#' \itemize{
#' \item cyst.pause = 365 length of obligatory diapause (days)
#' \item eggs_per_cyst = 250  number of eggs per cyst
#' \item deathC = 0.0005 mortality rate of cysts
#' \item Copt = 0.88 proportion of cysts which hatch under optimum conditions
#' \item gen2 = 0 proportion of cysts without a diapause requirement
#' \item tauA.m = 21 Duration of adult male stage
#' \item tauA.f = 21 Duration of adult female stage
#' \item PA = 1 Proportion of adults which survive
#' \item dormancy = 0.0005 cyst activation from dormancy
#' \item fixedGenderRatio = NULL value of adult gender ratio
#' }
#' @param ode.compartments list of how many ODEs are needed for the different life stages
#' \itemize{
#' \item kE = 20, number of compartments in egg stage
#' \item kJ = 20, number of compartments in juvenile stage
#' \item kA = 50, number of compartments in adult stage
#' }
#' 
#' @param temperature.pars list
#' @param plant.pars list of factors relating to the potato plant
#' \itemize{
#' \item resistanceFactor = 0, resistance factor of potatoes. Number between 0 and 1 (see Table 1 Ewing et al 2021)
#' \item N.plants = 1, Number of potato plants
#' \item root.length = 500, maximum length of plant roots (cm) in healthy plant
#' \item roots.per.cm = 0.5, root length density of potato plants (cm/cm^3) (see Table 2 Ewing et al 2021)
#' }
#' 
#' @return a list with the solution matrix and a list of parameters
#'
#' @importFrom PBSddesolve dde
#' 
#' @export
PCNmodel=function(

    numYears, 
    simStartDay, 
    initialEggsPerGram,
    soil.density = 1.5, # Soil density
    plantingDOY=90, # potatoes planted on this day of the year
    harvestingDOY=216, # potatoes harvested on this day of the year
    plantingYears=seq(1,1000), #years potatoes are planted
    
    lifecycle.pars=list(
        cyst.pause = 365, # length of obligatory diapause (days)
        eggs_per_cyst = 250, # number of eggs per cyst
        deathC = 0.0005, # mortality rate of cysts
        Copt = 0.88, # proportion of cysts which hatch under optimum conditions
        gen2 = 0, # proportion of cysts without a diapause requirement
        tauA.m = 21, # Duration of adult male stage
        tauA.f = 21, # Duration of adult female stage
        PA = 1, # Proportion of adults which survive
        dormancy = 0.0005, # cyst activation from dormancy
        fixedGenderRatio=NULL
        ),
    
    ode.compartments=list(
        kE = 20, # number of compartments for each life stage
        kJ = 20,
        kA = 50
        ),

    temperature.pars=list(
        temperatureSpline=NULL, #output of smooth.spline() through temperature measurements
        fixTemp = 14, #constant temperature thoughout simulation
        deltaT = 0 # apply this temperature change 
    ),
    
### Potato plant parameters
    plant.pars=list(
        resistanceFactor = 0, # resistance factor of potatoes
        N.plants = 1, # Number of potato plants
        root.length = 500, # maximum length of plant roots (cm) in healthy plant
        roots.per.cm = 0.5 # root length density of potato plants
    )
    ){

    
# Create vector with names of all life stages
stageNames=c('cysts','eggs','juveniles','females','males')


# Create names for storing results for each life stage
Evec=paste('E',1:ode.compartments$kE,sep='')
Jvec=paste('J',1:ode.compartments$kJ,sep='')
Afvec=paste('A',1:ode.compartments$kA,'.f',sep='')
Amvec=paste('A',1:ode.compartments$kA,'.m',sep='')



parms = list(
    #put vital rates functions into one list
    vitalRates=list(deathE=deathE,deathJ=deathJ,growthE=growthE,growthJ=growthJ,female.prop=female.prop),    
    kE = ode.compartments$kE,
    kJ = ode.compartments$kJ,
    kA = ode.compartments$kA,
    tauA.m = lifecycle.pars$tauA.m,
    tauA.f = lifecycle.pars$tauA.f,
    PA = lifecycle.pars$PA,
    deathC = lifecycle.pars$deathC,
    dormancy = lifecycle.pars$dormancy,
    fixedGenderRatio = lifecycle.pars$fixedGenderRatio,
    gen2 = lifecycle.pars$gen2,
    plantingDOY = plantingDOY,
    harvestingDOY = harvestingDOY,
    initialEggsPerGram = initialEggsPerGram,
    eggs_per_cyst = lifecycle.pars$eggs_per_cyst,
    Copt = lifecycle.pars$Copt,
    resistanceFactor = plant.pars$resistanceFactor,
    simStartDay = simStartDay,
    plantingYears=plantingYears,
    cyst.pause = lifecycle.pars$cyst.pause,
    soil.density = soil.density,
    root.length = plant.pars$root.length,
    roots.per.cm = plant.pars$roots.per.cm,
    N.plants = plant.pars$N.plants,
    deltaT = temperature.pars$deltaT,
    temperatureSpline = temperature.pars$temperatureSpline,
    Evec = Evec,
    Jvec = Jvec,
    Afvec = Afvec,
    Amvec = Amvec
)


#Add deltaT for new constantTemp
if (is.finite(temperature.pars$fixTemp)){
    parms$constantTemp=temperature.pars$fixTemp+parms$deltaT
}else{
    parms$constantTemp=NA
}


#initial conditions
initial=initialConditions(parms)
parms$tauE.init=as.numeric(unname(initial['tauE']))

#think about changing time step???
timeVec=seq(0,numYears*365,by=0.5)

# Run the model

print('Start ODE solver')

#output <- pcn.function(parms,initial,timeVec)
output =  as.data.frame(dde(y=initial,times=timeVec,func=pcn.equations,parms=parms,hbsize=10000,tol=1e-5))


return(list(solutions=output,parms=parms))

}


