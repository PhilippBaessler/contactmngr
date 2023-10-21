get_surname <- function(contact, previous = NULL) {
    if (!is.null(previous))
        stop("not yet implemented")

    contact[["surname"]][["current"]]
}

get_forename <- function(contact) {
    contact[["forename"]]
}

get_middle_names <- function(contact) {
    contact[["middle_name"]]
}

get_used_name <- function(contact) {
    contact[["used_name"]]
}

get_birthday <- function(contact) {
    contact[["birthday"]]
}

get_siezen <- function(contact) {
    contact[["siezen"]]
}

get_points <- function(contact) {
    contact[["points"]]
}

get_emails <- function(contact, business = TRUE, private = TRUE) {
    if (!business || !private)
        stop("not yet implemented")

    do.call(rbind, contact[["email"]]) # solve issue with rownames and add column "type" = c("business", "private")
}
