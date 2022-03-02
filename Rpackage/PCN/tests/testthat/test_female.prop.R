#Note that resistance factor is different to resistance rating (see Table 1 in Ewing et al 2021)

N.Juv=10
resistanceFactor=0 #value between 0 an 1
fixedGenderRatio=NULL
root.length=20

test_that("female prop 1", {
    expect_equal(female.prop(N.Juv,root.length,resistanceFactor,fixedGenderRatio=0.5),0.5)
})

test_that("female prop lte 1", {
    expect_lte(female.prop(N.Juv,root.length,resistanceFactor=1,fixedGenderRatio),1)
})

test_that("female prop gte 0", {
    expect_gte(female.prop(N.Juv,root.length,resistanceFactor=0,fixedGenderRatio),0)
})

test_that("female prop gives error", {
    expect_error(female.prop(N.Juv,root.length,resistanceFactor=2,fixedGenderRatio))
})

test_that("female prop decreases with resistance", {
    expect_lte(female.prop(N.Juv,root.length,resistanceFactor=1,fixedGenderRatio),female.prop(N.Juv,root.length,resistanceFactor=0,fixedGenderRatio))
})



