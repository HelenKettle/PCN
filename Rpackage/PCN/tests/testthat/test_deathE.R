Temp=10
tauE=20
Copt=0.9
Topt=18.4
w=11.7


H=Copt*(1-((Temp-Topt)/w)^2)
hatch=-(1/tauE)*log(H)

test_that("deathE T=10", {
    expect_equal(deathE(Temp=10,tauE,Copt),hatch)
})


test_that("deathE T=100", {
    expect_equal(deathE(Temp=100,tauE,Copt),1)
})

test_that("deathE T=0", {
    expect_equal(deathE(Temp=-10,tauE,Copt),1)
})
