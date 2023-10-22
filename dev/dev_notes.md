# Things to consider

-   where to save persistent configuration (per windows user?), such that I can access contacts using the miniUI regardless of the current working directory

-   how to manage notes per contact?

    -   either save as text within the json

    -   or, create a unique id, save that in the json, and create one \*.md file per person in a subdirectory linked via this unique id

    -   rendered markdown can be displayed within the miniUI (using maybe `markdown` package and `includeHTML()`

        -   it should then be possible to edit this markdown (e.g. edit button and then display the raw md content in a large text box)

        -   it should be possible to open the underlying md file directly in Rstudio and jump to it (possibly also remembering the cursor position?)

        -   some search and highlight capabilities? (maybe some javascript libs?)

    -   use h1 headers for year, h2 headers for month, h3 headers for "yyyy-mm-dd - \<matter/topic\>"\
        or better: h1 for year ("yyyy"), h2 for month ("yyyy-mm"), and each entry is then a collapsible element using

        ``` markdown
        <details open>
        <summary><b>YYYY-MM-DD</b> (optional: matter/topic)</summary>

        notes etc.

        - Bullet
        - Points

        </details>
        ```

    -   maybe use rmd rather than md, as this could be rendered into html hat has some sort of accordion for headers or something else that can be expanded/collapsed?\
        or look at this: <https://gist.github.com/pierrejoubert73/902cc94d79424356a8d20be2b382e1ab>

    -   in a later version, these notes could be organized as objects, where each entry is one individual object

-   use flags and tags?

-   maybe use proper OOP rather than list+jsonlite?

-   the fields:

    | field                | example                                                                            | history |
    |----------------|-------------------------------------------------|--------|
    | surname              | {current: "Baessler", previous: {name: "...", until: "yyyy-mm-dd"}}                | yes     |
    | forename             | "Philipp"                                                                          | no      |
    | middle_name          | ["foo", "bar"]                                                                     | no      |
    | used_name            | "Philipp"                                                                          | no      |
    | birthday             | 01.09.1991                                                                         | no      |
    | siezen               | FALSE                                                                              | no      |
    | email                | \<nested\>                                                                         |         |
    | ⤷ private            | {email: ...., active: T, created: ...., is_main: T, modified: ...}                 | yes     |
    | ⤷ business           | {email: ...., active: T, created: ...., is_main: T, modified: ...}                 | yes     |
    | phone                | \<nested\>                                                                         |         |
    | ⤷ private            | {phone: ...., active: T, created: ...., is_main: T, modified: ...}                 | yes     |
    | ⤷ business           | {phone: ...., active: T, created: ...., is_main: T, modified: ...}                 | yes     |
    | function             | {function: ...., active: T, created: ...., modified: ...}                          | yes     |
    | employment           | {company: ..., department: ..., role: ..., active: T, created: ..., modified: ...} | yes     |
    | first_encounter      | {notes: ..., date: ...}                                                            | no      |
    | skills_and_expertise | {competence: ..., level: \<1-4\>, notes: ...}                                      | no      |
    | points               | -2...2                                                                             | no      |
    | ~~picture~~          | ~~base64~~                                                                         | ~~no~~  |
    | history              | {{what: [fields], date:...}, {what: "creation", date:...}}                         | yes     |

-   competencies should be selected from dropdown (no free text) in order to facilitate searching later on;\
    available competencies should be configurable in a menu, possibly hierarchical to introduce some sort of structure which allows finding people that do not exactly match the competency but have related skills

-   for search also implement fuzzy search (or basic smith-waterman

-   for adding contacts to database:

    -   check whether surname (including previous) and forename combination already is in database, if so, either cancel or force add depending on argument

        ``` R
        # check if contact exists already ####

            # check by (current) surname and forename | todo: mabye non-case-sensitive?
            same_names   <- purrr::keep(contact_database,
                                        ~ .x[["surname"]][["current"]] == surname &
                                            .x[["forename"]] == forename)
            id_same_names <- names(same_names)

            if (mode == "check")
                stopifnot(length(id_same_names) == 0)

            # also check if the constructed id is unique


            # look for surname and forename, if not found, add
            # if found, raise error if mode == "check", add with new unique id if "add" or replace if "overwrite"

            id <- ... # logic to be defined
        ```

    -   id by default is surname('current' at time of id creation)\_forename

    -   check if id already exists, if so either cancel or force overwrite depending on argument

# Implementation notes

-   the quick-and-dirty trick with `shiny::tabsetPanel` as hidden tabs to create some sort of dynamic GUI seems to be not working with `miniUI` if I want to have the page fully filled; I guess the reason is that the nesting of `miniContentPanel(tabsetPanel(tabPanelBody(fillCol(…` results in `fillCol` being the child of a *div* that has no explicit height.As here, the commented stuff does not work as intended - when using the uncommented part, the full height DT table works:

    ``` R
    ui <- miniUI::miniPage(
        miniUI::gadgetTitleBar(
            uiOutput("title"),
            right = miniUI::miniTitleBarButton("Close", "Close", primary = TRUE),
            left  = uiOutput("title_bar_left")
        ),
        # miniUI::miniContentPanel(
        #     tabsetPanel(
        #         id = "dynamic_ui_switcher",
        #         type = "hidden",
        #         tabPanelBody(
        #             "contacts_list",
        #             fillCol(
        #                 height = "100%",
        #                 flex = c(NA, 1),
        #                 div(
        #                     style = "margin-bottom: 15px;",
        #                     actionButton("open_advanced_search", "advanced search",
        #                                  style = "display: inline-block; margin-right: 10px;"),
        #                     actionButton("add_new_contact", "add contact",
        #                                  style = "display: inline-block;")
        #                 ),
        #                 # div(
        #                 #     style = "background: red; width:100%; min-height:25px;",
        #                 #     DT::DTOutput("contact_list", height = "100%")
        #                 # )
        #                 #DT::DTOutput("contact_list2", height = "100%")
        #                 DT::DTOutput("contact_list", height = "80vh")
        #             )
        #         ),
        #         tabPanelBody(
        #             "contact_details"
        #         )
        #     )
        # )

        miniUI::miniContentPanel(
            fillCol(
                flex = c(NA, 1),
                div(
                    style = "margin-bottom: 15px;",
                    actionButton("open_advanced_search", "advanced search",
                                 style = "display: inline-block; margin-right: 10px;"),
                    actionButton("add_new_contact", "add contact",
                                 style = "display: inline-block;")
                ),
                DT::DTOutput("contact_list", height = "100%")
            )
        )
    )

    ```

-   as for the DT server side, the plugin `scrollResize` does the trick to have the DT table fill the full available (remaining) page height (the commented part has some funny / buggy behavior):

    ``` R
    server <- function(input, output, session) {
        # output$contact_list <- DT::renderDT(
        #     mtcars,
        #     options = list(scrollResize = TRUE, scrollY = "100%", scroller = TRUE),
        #     extensions = c("Scroller"),
        #     plugins = c("scrollResize")
        # )
        output$contact_list <- DT::renderDT(
            mtcars,
            options = list(scrollResize = TRUE, scrollY = "200px", scroller = TRUE),
            extensions = c("Scroller"),
            plugins = c("scrollResize")
        )
    }
    ```
