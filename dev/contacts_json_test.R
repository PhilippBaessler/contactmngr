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
    `FooFoo-Bob` = list(
        surname = list(current = "Foo", previous = list(name = "FooFoo", until = "2023-01-01")),
        forename = "Bob",
        middle_name = c("Robert", "Gerald"),
        used_name = "Bob",
        birthday = "1900-01-01",
        siezen = FALSE,
        email = list(
            business = structure_emails(list("a@a.com", "b@a.com")),
            private = structure_emails("hello@world.com")
        ),
        phone = list(
            business = structure_phones(list(01230123, 2222222)),
            private = structure_phones(01230123)
        ),
        occupation = list(list(occupation = "engineer A", active = TRUE, created = Sys.time(), modified = NULL),
                          list(occupation = "admin", active = FALSE, created = Sys.time() - 200, modified = Sys.time())),
        employment = list(list(company = "companyA", department = "D1", role = NULL, active = TRUE, created = Sys.time(), modified = NULL),
                          list(company = "old_company", department = NULL, role = "CEO", active = FALSE, created = Sys.time() - 200, modified = Sys.time())),
        first_encounter = list(notes = "Met him on my first day at old_company", date = Sys.time() - 300),
        expertise = list(list(competence = "R", level = 3, notes = "some stuff"),
                         list(competence = "C", level = 2, notes = NULL)),
        points = 1,
        id = "FooFoo-Bob"
    ),
    `FooFoo-Bob-2` = list(
        surname = list(current = "FooFoo"),
        forename = "Bob",
        middle_name = c("Mike"),
        used_name = "Bob",
        birthday = "1950-01-01",
        siezen = FALSE,
        email = list(
            business = structure_emails(list("aa@a.com")),
            private = NULL
        ),
        phone = list(
            business = NULL,
            private = NULL
        ),
        occupation = list(list(occupation = "assistant", active = TRUE, created = Sys.time(), modified = NULL)),
        employment = list(list(company = "companyA", department = "D2", role = NULL, active = TRUE, created = Sys.time(), modified = NULL)),
        first_encounter = list(notes = "another Bob FooFoo that I got to know", date = Sys.time() - 100),
        expertise = list(list(competence = "Microsoft Word", level = 3, notes = "some stuff"),
                         list(competence = "C", level = 2, notes = NULL)),
        points = 0,
        id = "FooFoo-Bob-2"
    ),
    `Bar-Alice` = list(
        surname = list(current = "Bar"),
        forename = "Alice",
        middle_name = NULL,
        used_name = "Alice",
        birthday = "1980-01-01",
        siezen = FALSE,
        email = list(
            business = structure_emails(list("something@something.com"))
        ),
        phone = NULL,
        occupation = list(list(occupation = "engineer", active = TRUE, created = Sys.time(), modified = NULL)),
        employment = list(list(company = "anotherCompany", department = NULL, role = NULL, active = TRUE, created = Sys.time(), modified = NULL)),
        first_encounter = NULL,
        expertise = NULL,
        points = -1,
        id = "Bar-Alice"
    )
)

