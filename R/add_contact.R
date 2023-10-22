#' Title
#'
#' @param contact_database
#' @param contact
#' @param mode
#'
#' @return
#' @export
#'
#' @examples
add_contact <- function(contact_database, contact, mode = c("check", "add", "overwrite")) {
    mode <- match.arg(mode)

    # if mode is check, then check whether surname.current & forename combination is already present
    # in contact_database (including previous surnames); if so, stop
    # for robsutness, also check if contact's id

    #
}


# add_contact helpers -------------------------------------------------------------------------

# one function to  check whether surname.current & forename combination is already present
# in contact_database

# one to create id, that is: start with default id, and if present increment by 1 (or throw error)
