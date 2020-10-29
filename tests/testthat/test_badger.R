# unit tests for make_participant
context("badgeR")

test_that("make_participant",{
  minimal_test <- make_participant("Jon")
  expect_equal(minimal_test, "\\confpin{Jon}{}{}{}")
  some_fields <- make_participant("Jon", "Snow", "organiser")
  expect_equal(some_fields, "\\confpin{Jon}{Snow}{organiser}{}")
  all_fields <- make_participant("Jon", "Snow", "organiser", "she/her")
  expect_equal(all_fields, "\\confpin{Jon}{Snow}{organiser}{she/her}")

})

test_that("make_participant",{
  default_template <- read_template()
  expect_type(default_template, "character")
  # expect error when wrong path is given
  expect_error(read_template("costom/template/path.tex"))
})

