### Potato plant parameters
resistanceFactor = 0 # resistance factor of potatoes
N.plants = 1 # Number of potato plants
root.length = 500 # maximum length of plant roots (cm) in healthy plant
roots.per.cm = 0.5 # root length density of potato plants

### PCN parameters
cyst.pause = 365 # length of obligatory diapause (days)
eggs_per_cyst = 250 # number of eggs per cyst
deathC = 0.0005 # mortality rate of cysts
Copt = 0.88 # proportion of cysts which hatch under optimum conditions
gen2 = 0 # proportion of cysts without a diapause requirement
tauA.m = 21 # Duration of adult male stage
tauA.f = 21 # Duration of adult female stage
PA = 1 # Proportion of adults which survive
dormancy = 0.0005 # cyst activation from dormancy
kE = 20 # number of compartments for each life stage
kJ = 20
kA = 50

### Model settings
initialEggsPerGram = 0.1 # Initial egg density
soil.density = 1.5 # Soil density
plantingDOY=90 # potatoes planted on this day of the year
harvestingDOY=216 # potatoes harvested on this day of the year
noPotatoYearsList=list(c(start=2,fin=3)) # Choose years not to plant potatoes. Can compare the different strategies by adding more to this list. For continuous planting use c(start=0,fin=0).
numYears=1 #number of years to simulate
simStartDay=0 #day of the year the simulation starts
# For the temperature inputs below there are a few options:
# 1. provide a spline fitted to an observed temperature species, which must be passed to temperaturefile
# 2. specify a fixed temperature in degrees celsius to the fixTemp argument. If specifying a fixed temperature then a vector can be input to study multiple temperatures.  A single value will run the model once for that value.
# 3. if both temperaturefile and fixTemp are left NULL then a sinusoidal temperature function will be assumed.  The sinusoidal function assumes a mean of 13 celsius and amplitude of 2 degrees.  To change this the user must do so in the tempFunc.R file.
temperaturefile=NULL # Can also input a spline through temperature datapoints
fixTemp = 14
deltaT = 0 # apply this temperature change over the baseline.  
