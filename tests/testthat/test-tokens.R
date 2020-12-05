
context("Tests tokens")





test_that("get management token",
          {


            yml_path <- ("../../inst/ShinyPlatform_app/config.yml")


            domain <- config::get("domain",file = yml_path,config = "default")
            client_id <- config::get("client_id",file = yml_path)
            client_secret <-  config::get("client_secret",file = yml_path)
            DEBUG <- FALSE



            management_token <-
              ShinyPlatform::get_management_token(client_id,client_secret,domain,DEBUG)$management_token

           testthat::expect_equal(is.na(management_token), FALSE)

})


