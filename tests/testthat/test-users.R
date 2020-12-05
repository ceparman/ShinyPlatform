
context("Tests for user management")

yml_path <- ("../../inst/ShinyPlatform_app/config.yml")

domain <- config::get("domain",file = yml_path)
client_id <- config::get("client_id",file = yml_path)
client_secret <-  config::get("client_secret",file = yml_path)
DEBUG <- TRUE


user_info <- list( email =  "testmail@ngsanalytics.com",
                   connection = "Username-Password-Authentication",
                   password ="1234",
                   app_metadata = list(role = "admin")
                   )

test_that("Create",
          {






            print(client_id)

user <- create_user(client_id,client_secret,domain,user_info,DEBUG)$user

print(user$user_id)



user_id <- user$user_id



users <- list_users(client_id,client_secret,domain,DEBUG)$users


status <- delete_user(client_id,client_secret,domain,user_id,DEBUG)$status

print(status)

})
