tmp <- list(`test123` = list(
    name = "Baessler",
    name2 = "Philipp",
    nickname = NULL,
    emails = list(
        private = list(
            list(
                email = "test3",
                active = TRUE,
                created = Sys.Date()
            ),
            list(
                email = "test",
                active = TRUE,
                created = Sys.Date() + 1
            ),
            list(
                email = "test2",
                active = FALSE,
                created = Sys.Date() - 30
            )
        ),
        business = list(
            list(
                email = "test1",
                active = TRUE,
                created = Sys.Date()-3
            )
        )
    )
))

jsonlite::toJSON(tmp)



dev_contacts <- list(
    `FooFoo_Bob` = list(
        surname = list(current = "Foo", previous = list(name = "FooFoo", until = "2023-01-01")),
        forename = "Bob",
        middle_name = c("Robert", "Gerald"),
        used_name = "Bob",
        birthday = "1900-01-01",
        siezen = FALSE,
        email = list(
            business = parse_emails(list("a@a.com", "b@a.com")),
            private = parse_emails("hello@world.com")
        ),
        phone = list(
            business = parse_phones(list(01230123, 2222222)),
            private = parse_phones(01230123)
        ),
        `function` = tibble::tribble(
            ~`function`, ~active, ~created, ~modified,
            "engineer A", TRUE, Sys.time(), NA,
            "admin", FALSE, Sys.time() - 200, Sys.time()
        ),
        employment = tibble::tribble(
            ~company, ~department, ~role, ~active, ~created, ~modified,
            "companyA", "D1", NA, TRUE, Sys.time(), NA,
            "old_company", NA, "CEO", FALSE, Sys.time() - 200, Sys.time()
        ),
        first_encounter = parse_first_encounter(list(notes = "Met him on my first day at old_company", date = Sys.time() - 300)),
        expertise =tibble::tribble(
            ~competence, ~level, ~notes,
            "R", 3, "some stuff",
            "C", 2, NA
        ),
        points = 1,
        id = "FooFoo_Bob"
    ),
    `FooFoo_Bob_2` = list(
        surname = list(current = "FooFoo"),
        forename = "Bob",
        middle_name = c("Mike"),
        used_name = "Bob",
        birthday = "1950-01-01",
        siezen = FALSE,
        email = list(
            business = parse_emails(list("aa@a.com")),
            private = NULL
        ),
        phone = list(
            business = NULL,
            private = NULL
        ),
        `function` = parse_function(list(list(`function` = "assistant", active = TRUE))),
        employment = parse_employment(list(list(company = "companyA", department = "D2", active = TRUE))),
        first_encounter = list(notes = "another Bob FooFoo that I got to know", date = Sys.time() - 100),
        expertise = parse_expertise(list(list(competence = "Microsoft Word", level = 3, notes = "some stuff"),
                                         list(competence = "C", level = 2))),
        points = 0,
        id = "FooFoo_Bob_2"
    ),
    `Bar_Alice` = list(
        surname = list(current = "Bar"),
        forename = "Alice",
        middle_name = NULL,
        used_name = "Alice",
        birthday = "1980-01-01",
        siezen = FALSE,
        email = list(
            business = parse_emails(list("something@something.com"))
        ),
        phone = NULL,
        `function` = parse_function(list(list(`function` = "engineer", active = TRUE))),
        employment = parse_employment(list(list(company = "anotherCompany", active = TRUE))),
        first_encounter = NULL,
        expertise = NULL,
        points = -1,
        id = "Bar_Alice"
    )
)

