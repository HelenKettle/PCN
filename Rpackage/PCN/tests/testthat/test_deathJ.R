tauJ=30


test_that("deathJ 1", {
    expect_equal(deathJ(Temp=100,PE=0.1,tauJ,potato.presence=1),1)
})

test_that("deathJ 2", {
    expect_equal(deathJ(Temp=10,PE=0.1,tauJ,potato.presence=0),10)
})

test_that("deathJ 3", {
    expect_equal(deathJ(Temp=0,PE=0.1,tauJ,potato.presence=0),10)
})

Temp=10
PE=0.5
potato.presence=1

test_that("deathJ: test that death rate decreases with tauJ", {
    expect_lt(deathJ(Temp,PE,tauJ=30,potato.presence),deathJ(Temp,PE,tauJ=10,potato.presence))
})

test_that("deathJ: test that death rate increases with PE", {
    expect_gt(deathJ(Temp,PE=0.5,tauJ,potato.presence),deathJ(Temp,PE=0.1,tauJ,potato.presence))
})

