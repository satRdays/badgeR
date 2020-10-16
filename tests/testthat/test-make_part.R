# unit tests for make_participant
context("badgeR")
test_that("make_participant",{
  test_data <- make_participant("Jon", "Snow", "organiser")
  expect_equal(test_data, "\\confpin{Jon}{Snow}{organiser}")
})

