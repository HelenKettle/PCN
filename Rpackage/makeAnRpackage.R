rm(list=ls())

#install.packages("devtools")
library("devtools")

#install.packages("roxygen2")
library(roxygen2)

parent_directory='~/PCN2022/Rpackage/'

setwd(parent_directory)

devtools::document('PCN')

devtools::build('PCN')
devtools::install()

devtools::check('PCN')



#Tests
usethis::use_testthat()

#This will:
#    Create a tests/testthat directory.
#    Add testthat to the Suggests field in the DESCRIPTION.
#    Create a file tests/testthat.R that runs all your tests when R CMD check runs. (You’ll learn more about that in automated checking.)
devtools::test()






