# Resistance: Note, no known potato varieties have complete resistance to pallida
resistanceFactor=c(rosto=0,'pallida'=0)

#fraction that hatch at the optimum temperature
optHatch=c('pallida'=0.88,'rosto'=0.65)

eggs_per_cyst=300

adultStageDuration=50 #days

cystDeathRate = 0.0005

#specify stage compartments
#in future write function to get k from mean time delay and std for each stage
kEvec=c('pallida'=4,'rosto'=3)
kJ = 6
kA = 4

