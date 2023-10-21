create_contact <- function(contact_database,
                           surname,
                           forename,
                           middle_name = NULL,
                           used_name = forename,
                           birthday = NULL,
                           siezen = NULL,
                           business_emails, # can be list of mail addresses, first is main
                           private_emails = NULL, # can be list of mail addresses, first is main
                           business_phone = NULL, # can be list, first is main
                           private_phone = NULL, # can be list, first is main
                           occupation = NULL, # list(list(occupation:.., active=..))
                           employment = NULL, # list(company=.., department=.., active=..)
                           first_encounter = NULL, # list(notes:.., date:...)
                           expertise = NULL, # list(list(competence:.., level = 1:4, notes: ...))
                           points = 0,
                           mode = c("check", "add", "overwrite"))
{

    # handle input ####
    stopifnot(is.null(business_emails) || is.list(business_mails))
    stopifnot(is.null(private_emails) || is.list(private_emails))
    stopifnot(is.null(business_phone) || is.list(business_phone))
    stopifnot(is.null(private_phone) || is.list(private_phone))
    stopifnot(is.null(occupation) || is.list(occupation))
    stopifnot(is.null(employment) || is.list(employment))
    stopifnot(is.null(first_encounter) || is.list(first_encounter))
    stopifnot(is.null(expertise) || is.list(expertise))

    if (is_not_list(business_emails))
        business_emails <- list(business_emails)

    if (is_not_list(private_emails))
        private_emails <- list(private_emails)

    if (is_not_list(business_phone))
        business_phone <- list(business_phone)

    if (is_not_list(private_phone))
        private_phone <- list(private_phone)


    # maybe assert that
    # - occupation is two level list
    # - expertise is two level list
    # - occupation, employment, expertise, first_encounter have the expected structure and fields


    # check if contact exists already ####

    # look for surname and forename, if not found, add
    # if found, raise error if mode == "check", add with new unique id if "add" or replace if "overwrite"

    id <- ... # logic to be defined

    # create list ####
    new_contact <- list(
        list(
            surname = list(current = surname, previous = NULL),
            forename = forename,
            middle_name = middle_name,
            used_name = used_name,
            birthday = birthday,
            siezen = siezen,
            business_emails = structure_emails(business_emails),
            private_emails = structure_emails(private_emails),
            business_phone = structure_phones(business_phone),
            private_phone = structure_phones(private_phone),
            occupation = occupation,
            employment = employment,
            first_encounter = first_encounter,
            expertise = expertise,
            points = points,
            id = id
        )
    )
    names(new_contact) <- id

    contact_database
}


is_not_list <- function(arg) {
    !is.null(arg) && !is.list(arg)
}

structure_emails <- function(email_list) {
    email_list <- lapply(email_list, function(x) list(email = x,
                                                      active = TRUE,
                                                      is_main = FALSE,
                                                      modified = Sys.time()))
    email_list[[1]]$is_main <- TRUE
}

structure_phones <- function(phone_list) {
    phone_list <- lapply(phone_list, function(x) list(email = x,
                                                      active = TRUE,
                                                      is_main = FALSE,
                                                      modified = Sys.time()))
    phone_list[[1]]$is_main <- TRUE
}
