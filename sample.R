library(httr)
library(jsonlite)

#' OAUTH2 Token
#'
#' Get the OAUTH2 token with httr.
#'
icd_token <- function(client_id = NULL, client_secret = NULL) {

  if (is.null(client_id)) client_id <- readline("Enter client id: ")
  if (is.null(client_secret)) client_secret <- readline("Enter client secret: ")

  httr::init_oauth2.0(
    endpoint = httr::oauth_endpoint(
      authorize = NULL,
      access = "https://icdaccessmanagement.who.int/connect/token"
      ),
    app = httr::oauth_app(
      appname = "icd",
      key = client_id,
      secret = client_secret
      ),
    scope = "icdapi_access",
    client_credentials = TRUE
  )
}

#' Token as a Header
#'
#' Prepare the header for the GET request with httr.
#'
token_as_header <- function(token) {
  httr::add_headers(
    Authorization = paste(token$token_type, token$access_token),
    Accept = "application/ld+json",
    "Accept-Language" = "en",
    "API-Version" = "v2"
  )
}

# Get a token
token <- icd_token()

# Send the request
result <- GET(
  url = "https://id.who.int/icd/entity",
  token_as_header(token)
)

# Print result
result

# Print result content
fromJSON(content(result, as = "text", encoding = "UTF-8"))
