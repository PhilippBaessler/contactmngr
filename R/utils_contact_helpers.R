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

get_emails <- function(contact, types = c("business", "private")) {
    subset(purrr::list_rbind(contact[["email"]], names_to = "type"), type %in% types)
}

get_email <- function(contact, type = c("business", "private")) {
    .type <- match.arg(type)

    subset(get_emails(contact), type == .type & is_main)[["email"]]
}

get_phones <- function(contact, types = c("business", "private")) {
    subset(purrr::list_rbind(contact[["phone"]], names_to = "type"), type %in% types)
}

get_phone <- function(contact, type = c("business", "private")) {
    .type <- match.arg(type)

    subset(get_phones(contact), type == .type & is_main)[["phone"]]
}

get_functions <- function(contact, active_only = FALSE) {
    subset(contact[["function"]], active | !active_only)
}

get_employments <- function(contact, active_only = FALSE) {
    subset(contact[["employment"]], active | !active_only)
}

get_first_encounter <- function(contact) {
    contact[["first_encounter"]]
}

get_expertise <- function(contact) {
    contact[["expertise"]]
}

get_points <- function(contact) {
    contact[["points"]]
}

get_history <- function(contact, time_desc = TRUE) {
    dat <- contact[["history"]]

    dat[order(dat$date, decreasing = time_desc)]
}
