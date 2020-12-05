

get_app_and_user_info <-
  function(session,
           app_url,
           app_client_id,
           app_secret,
           Domain,
           storedData,
           DEBUG = T)
  {




    if(DEBUG) {print("In get_app_and_user_info \n")}


    #decrypt db credentials

    #decrypt management credentials

    #Store dB and management credentials

    #Update header bar


    #Start assuming login failed

    user <- "not logged in"

    tryCatch({

      #parse query string

      params <-
        shiny::parseQueryString(isolate(session$clientData$url_search))

      if (DEBUG)

         print(params$code)


      #Get Auth token


      t <-
        ShinyPlatform::get_authentication_token(app_url, app_client_id, app_secret, Domain, params$code)

      token <- httr::content(t)

      if (DEBUG){
        print("Token")
        print(str(token))
      }

      #Get user profile info

      profile <-
        ShinyPlatform::get_user_profile(token$access_token, token$id_token, Domain)

      if (DEBUG){
        print("User Profile")
        print(profile)
      }

      #Get App token



      api_tokens <-
        ShinyPlatform::get_app_api_token(app_client_id, app_secret, Domain)


      if (DEBUG)
        print(api_tokens)

      #Get app (client) metadata

      client <-
        ShinyPlatform::get_app_client_profile(api_tokens$access_token, app_client_id, Domain)

      if (DEBUG)
        print("client")

      if (DEBUG)
        print(client)

      if (DEBUG)
        print("creds")

      if (DEBUG)
        print(jsonlite::fromJSON(safer::decrypt_string(client$client_metadata$creds)))



      #build API credentials

      #   up <-jsonlite::fromJSON(safer::decrypt_string(client$client_metadata$creds))
      #    api <- safer::retrieve_object("api_info.bin",ascii = T)

      #   api$user <- up$user
      #  api$pwd <- up$password



      if (DEBUG)
        print(profile$user_metadata$barcode)



      #  return( profile$nickname)

    },
    error = function(cond) {
       return (paste("Login Error", cond))
    })

  print(token)


  }
