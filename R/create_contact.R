#' Title
#'
#' @param contact_database
#' @param surname
#' @param forename
#' @param middle_name
#' @param used_name
#' @param birthday
#' @param siezen
#' @param business_emails
#' @param private_emails
#' @param business_phone
#' @param private_phone
#' @param occupation
#' @param employment
#' @param first_encounter
#' @param expertise
#' @param points
#' @param mode
#'
#' @return
#' @export
#'
#' @examples
create_contact <- function(id = paste(surname, forename, sep = "_"),
                           surname,
                           forename,
                           middle_name = NULL,
                           used_name = forename,
                           birthday = NULL,
                           siezen = NULL,
                           business_emails, # can be character vector of mail addresses, first is main
                           private_emails = NULL, # can be character vector of mail addresses, first is main
                           business_phone = NULL, # can be character vector, first is main
                           private_phone = NULL, # can be character vector, first is main
                           `function` = NULL, # list(list(`function`:.., active=..))
                           employment = NULL, # list(company=.., department=.., active=..)
                           first_encounter = NULL, # list(notes:.., date:...)
                           expertise = NULL, # list(list(competence:.., level = 1:4, notes: ...))
                           points = 0,
                           mode = c("check", "add", "overwrite"))
{

    # handle input ####
    mode <- match.arg(mode)

    stopifnot(purrr::is_scalar_character(surname))
    stopifnot(purrr::is_scalar_character(forename))
    stopifnot(is.null(middle_name) || is.character(middle_name))
    stopifnot(is.null(business_emails) || is.character(business_mails))
    stopifnot(is.null(private_emails)  || is.character(private_emails))
    stopifnot(is.null(business_phone)  || is.character(business_phone))
    stopifnot(is.null(private_phone)   || is.character(private_phone))
    stopifnot(is.null(occupation)      || is.list(occupation))
    stopifnot(is.null(employment)      || is.list(employment))
    stopifnot(is.null(first_encounter) || is.list(first_encounter))
    stopifnot(is.null(expertise)       || is.list(expertise))

    # maybe check here that
    # - emails are actual emails
    # - phone numbers are acceptable
    # - all date fields are actually of type date



    # create list ####
    new_contact <- list(
        list(
            surname     = list(current = surname, previous = NULL),
            forename    = forename,
            middle_name = middle_name,
            used_name   = used_name,
            birthday    = birthday,
            siezen      = siezen,
            email = list(
                business = parse_emails(business_emails),
                private  = parse_emails(private_emails)
            ),
            phone = list(
                business = parse_phones(business_phone),
                private  = parse_phones(private_phone)
            ),
            `function`      = parse_function(`function`),
            employment      = parse_employment(employment),
            first_encounter = parse_first_encounter(first_encounter),
            expertise       = parse_expertise(expertise),
            points          = points,
            history         = tibble(what = "creation", date = Sys.time()),
            id              = id
        )
    )
    names(new_contact) <- id

    new_contact
}




# create_contact helpers ----------------------------------------------------------------------

parse_function <- function(definition) {
    if (is.null(definition))
        return(NULL)

    stopifnot(is.list(definition))
    stopifnot(purrr::vec_depth(definition) %in% c(2, 3))

    if (purrr::vec_depth(definition) == 2)
        definition <- list(definition)

    stopifnot(all(purrr::map_lgl(definition, ~ length(names(.x)) > 0)))
    stopifnot(all(purrr::map_lgl(definition, ~ any(grepl("^func$|^function$", names(.x))))))

    definition <- purrr::map(definition, ~ `names<-`(.x, sub("^func$", "function", names(.x))))

    .function <- purrr::map_depth(definition, 1, as_tibble)
    .function <- purrr::list_rbind(.function)

    .function <- .function[, names(.function) %in% c("function", "active")] # ignore any other input fields

    if (!("active" %in% names(.function)))
        .function$active <- NA

    .function$created  <- Sys.time()
    .function$modified <- NA

    .function
}

parse_employment <- function(definition) {
    if (is.null(definition))
        return(NULL)

    stopifnot(is.list(definition))
    stopifnot(purrr::vec_depth(definition) %in% c(2, 3))

    if (purrr::vec_depth(definition) == 2)
        definition <- list(definition)

    stopifnot(all(purrr::map_lgl(definition, ~ length(names(.x)) > 0)))
    stopifnot(all(purrr::map_lgl(definition, ~ c("company") %in% names(.x))))

    employment <- purrr::map_depth(definition, 1, as_tibble)
    employment <- purrr::list_rbind(employment)

    employment <- employment[, names(employment) %in% c("company", "department", "role", "active")] # ignore any other input fields

    if (!("department" %in% names(employment)))
        employment$department <- NA

    if (!("role" %in% names(employment)))
        employment$role <- NA

    if (!("active" %in% names(employment)))
        employment$active <- NA


    employment$created  <- Sys.time()
    employment$modified <- NA

    employment
}

parse_first_encounter <- function(definition) {
    if (is.null(definition))
        return(NULL)

    stopifnot(is.list(definition))
    stopifnot(purrr::vec_depth(definition) == 2)

    if (!("notes" %in% names(definition)))
        definition$notes <- NULL

    if (!("date" %in% names(definition))) {
        definition$date <- NULL
    } else if (!inherits(definition$date, "POSIXct")) {
        stop("wrong date format provided, use POSIXct")
    }

    definition[c("notes", "date")] # ignore any other fields
}

parse_expertise <- function(definition) {
    if (is.null(definition))
        return(NULL)

    stopifnot(is.list(definition))
    stopifnot(purrr::vec_depth(definition) %in% c(2, 3))

    if (purrr::vec_depth(definition) == 2)
        definition <- list(definition)

    stopifnot(all(purrr::map_lgl(definition, ~ length(names(.x)) > 0)))
    stopifnot(all(purrr::map_lgl(definition, ~ c("competence") %in% names(.x))))

    expertise <- purrr::map_depth(definition, 1, as_tibble)
    expertise <- purrr::list_rbind(expertise)

    expertise <- expertise[, names(expertise) %in% c("competence", "level", "notes")] # ignore any other input fields

    if (!("level" %in% names(expertise)))
        expertise$level <- NA

    if (!("notes" %in% names(expertise)))
        expertise$notes <- NA

    expertise
}

parse_emails <- function(email_list) {
    if (is.null(email_list))
        return(NULL)

    email_list <- lapply(email_list,
                         function(x) tibble(email = x,
                                            active = TRUE,
                                            is_main = FALSE,
                                            modified = Sys.time(),
                                            stringsAsFactors = FALSE))

    email_list[[1]]$is_main <- TRUE

    do.call(rbind, email_list)
}

parse_phones <- function(phone_list) {
    if (is.null(phone_list))
        return(NULL)

    phone_list <- lapply(phone_list, function(x) tibble(phone = x,
                                                        active = TRUE,
                                                        is_main = FALSE,
                                                        modified = Sys.time(),
                                                        stringsAsFactors = FALSE))
    phone_list[[1]]$is_main <- TRUE

    do.call(rbind, phone_list)
}
