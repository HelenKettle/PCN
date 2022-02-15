#' PCNmodel
#'
#' @param numYears Integer. Number of years to simulate
#' @param simStartDay Integer. Day of the year the simulation starts. Defaults to 0
#' @param initialEggsPerGram Scalar. Initial egg density. Defaults to 0.1 eggs per gram of soil
#' @param soil.density Scala. Soil density (g/cm^3). Defaults to 1.5 g/cm^3
#' @param plantingDOY Integer. Potatoes planted on this day of the year. Defaults to 90
#' @param harvestingDOY Integer. Potatoes harvested on this day of the year. Defaults to 216
#' @param noPotatoYearsList Defaults to list(c(start=2,fin=3)), Choose years not to plant potatoes. Can compare the different strategies by adding more to this list. For continuous planting use c(start=0,fin=0).
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
#' }
#' @param ode.compartments list of how many ODEs are needed for the different life stages
#' \itemize{
#' \item kE = 20, number of compartments in egg stage
#' \item kJ = 20, number of compartments in juvenile stage
#' \item kA = 50, number of compartments in adult stage
#' }
#' @param temperature.pars list
#' @param plant.pars list of factors relating to the potato plant
#' \itemize{
#' \item resistanceFactor = 0, resistance factor of potatoes
#' \item N.plants = 1, Number of potato plants
#' \item root.length = 500, maximum length of plant roots (cm) in healthy plant
#' \item oots.per.cm = 0.5, root length density of potato plants
#' }
#' 
#' @return matrix
#' 
#' @export
PCNmodel=function(

    numYears, 
    simStartDay, 
    initialEggsPerGram,
    soil.density = 1.5, # Soil density
    plantingDOY=90, # potatoes planted on this day of the year
    harvestingDOY=216, # potatoes harvested on this day of the year
    noPotatoYearsList=list(c(start=2,fin=3)), # Choose years not to plant potatoes. Can compare the different strategies by adding more to this list. For continuous planting use c(start=0,fin=0).

    lifecycle.pars=list(
        cyst.pause = 365, # length of obligatory diapause (days)
        eggs_per_cyst = 250, # number of eggs per cyst
        deathC = 0.0005, # mortality rate of cysts
        Copt = 0.88, # proportion of cysts which hatch under optimum conditions
        gen2 = 0, # proportion of cysts without a diapause requirement
        tauA.m = 21, # Duration of adult male stage
        tauA.f = 21, # Duration of adult female stage
        PA = 1, # Proportion of adults which survive
        dormancy = 0.0005 # cyst activation from dormancy
        ),
    
    ode.compartments=list(
        kE = 20, # number of compartments for each life stage
        kJ = 20,
        kA = 50
        ),

    
# For the temperature inputs below there are a few options:
# 1. provide a spline fitted to an observed temperature species, which must be passed to temperaturefile
# 2. specify a fixed temperature in degrees celsius to the fixTemp argument. If specifying a fixed temperature then a vector can be input to study multiple temperatures.  A single value will run the model once for that value.
# 3. if both temperaturefile and fixTemp are left NULL then a sinusoidal temperature function will be assumed.  The sinusoidal function assumes a mean of 13 celsius and amplitude of 2 degrees.  To change this the user must do so in the tempFunc.R file.
    temperature.pars=list(
        temperaturefile=NULL, # Can also input a spline through temperature datapoints
        fixTemp = 14,
        deltaT = 0 # apply this temperature change over the baseline.  
### Potato plant parameters
    ),
    plant.pars=list(
        resistanceFactor = 0, # resistance factor of potatoes
        N.plants = 1, # Number of potato plants
        root.length = 500, # maximum length of plant roots (cm) in healthy plant
        roots.per.cm = 0.5 # root length density of potato plants
    )
    ){

    
# Create vector with names of all life stages
stageNames=c('cysts','eggs','juveniles','females','males')

# Set start and finish times for years with no potatoes
noPotStart=as.numeric(unname(noPotatoYearsList[[1]]['start']))
noPotFinish=as.numeric(unname(noPotatoYearsList[[1]]['fin']))

# Create names for storing results for each life stage
Evec=paste('E',1:ode.compartments$kE,sep='')
Jvec=paste('J',1:ode.compartments$kJ,sep='')
Afvec=paste('A',1:ode.compartments$kA,'.f',sep='')
Amvec=paste('A',1:ode.compartments$kA,'.m',sep='')

parms = list(
    vitalRates=vitalRates,
    kE = ode.compartments$kE,
    kJ = ode.compartments$kJ,
    kA = ode.compartments$kA,
    tauA.m = lifecycle.pars$tauA.m,
    tauA.f = lifecycle.pars$tauA.f,
    PA = lifecycle.pars$PA,
    deathC = lifecycle.pars$deathC,
    dormancy = lifecycle.pars$dormancy,
    gen2 = lifecycle.pars$gen2,
    plantingDOY = plantingDOY,
    harvestingDOY = harvestingDOY,
    initialEggsPerGram = initialEggsPerGram,
    eggs_per_cyst = lifecycle.pars$eggs_per_cyst,
    Copt = lifecycle.pars$Copt,
    resistanceFactor = plant.pars$resistanceFactor,
    simStartDay = simStartDay,
    noPotatoYearsStart = noPotStart,
    noPotatoYearsFinish = noPotFinish,
    cyst.pause = lifecycle.pars$cyst.pause,
    soil.density = soil.density,
    root.length = plant.pars$root.length,
    roots.per.cm = plant.pars$roots.per.cm,
    N.plants = plant.pars$N.plants,
    deltaT = temperature.pars$deltaT,
    Evec = Evec,
    Jvec = Jvec,
    Afvec = Afvec,
    Amvec = Amvec
)

if (!is.null(temperature.pars$fixTemp)){
    parms$constantTemp=fixTemp+parms$deltaT
}else{
    parms$constantTemp=NA
}


#initial conditions
initial=initFunc(parms)
parms$tauE.init=as.numeric(unname(initial['tauE']))

#think about changing time step???
timeVec=seq(parms$simStartDay,numYears*365,by=0.5)

# Run the model

print('Start ODE solver')

#output <- pcn.function(parms,initial,timeVec)
output =  as.data.frame(dde(y=initial,times=timeVec,func=pcn.equations,parms=parms,hbsize=10000,tol=1e-5))


quickPlot(output,parms)

return(output)

}


