rm(list=ls())

#install.packages("devtools")
library("devtools")

#install.packages("roxygen2")
library(roxygen2)

parent_directory='~/PCN2022/Rpackage/'

setwd(parent_directory)
#create("PCN")

#If you look in your parent directory, you will now have a folder called cats, and in it you will have two folders (man and R) and one file called DESCRIPTION.

#You should edit the DESCRIPTION file to include all of your contact information, etc.

#Add functions
#add cat_function.R add documentation to it

setwd("./PCN")
document()

#This automatically adds in the .Rd files to the man directory, and adds a NAMESPACE file to the main directory. You can read up more about these, but in terms of steps you need to take, you really don’t have to do anything further.

#Step 5: Install!
#Now it is as simple as installing the package! You need to run this from the parent working directory that contains the cats folder.

setwd("..")
install("cats")

#Vignette
install.packages("rmarkdown")
setwd("./cats")
usethis::use_vignette("my-vignette") #this makes the folder and the Rmd file but puts you in Vim! Exit Vim using :q


#Tests
usethis::use_testthat()

#This will:
#    Create a tests/testthat directory.
#    Add testthat to the Suggests field in the DESCRIPTION.
#    Create a file tests/testthat.R that runs all your tests when R CMD check runs. (You’ll learn more about that in automated checking.)
devtools::test()


devtools::build()
devtools::install()

devtools::check()



