a <- list(`pb-20231021123123` = list(
    name = "Baessler",
    name2 = "Philipp",
    nickname = NULL,
    emails = list(
        private = list(
            list(
                email = "philipp.baessler@me.com",
                active = TRUE,
                created = Sys.Date()
            ),
            list(
                email = "info@philippbaessler.de",
                active = TRUE,
                created = Sys.Date() + 1
            ),
            list(
                email = "no-reply@philippbaessler.de",
                active = FALSE,
                created = Sys.Date() - 30
            )
        ),
        business = list(
            list(
                email = "philipp.baessler@infineon.com",
                active = TRUE,
                created = Sys.Date()-3
            )
        )
    )
))

jsonlite::toJSON(a)
