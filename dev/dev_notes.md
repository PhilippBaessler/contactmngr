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
    |---------------|-------------------------------------------|---------------|
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

        ``` r
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

# To Do

-   message "nothing to compact"? where does it come from & how to remove it?\
    it was introduced when implementing the DEBUG button for triggering the scroller resize. So it might have something to do with this:

    ``` r
    # server.R
    observeEvent(input$DEBUG_trigger_scroller_measure, {
        session$sendCustomMessage("triggerScrollerMeasure",
                                  "contact_list")
    })
    ```

    ``` javascript
    Shiny.addCustomMessageHandler('triggerScrollerMeasure', function(shinyId) {
                const dataTable = document.getElementById(shinyId);
                console.log(dataTable);
                const dataTableWrapper  = dataTable.getElementsByClassName('dataTables_wrapper')[0];
                console.log(dataTableWrapper);
                const dataTableId = dataTableWrapper.id.replace('_wrapper', '');
                console.log(dataTableId);
                $('#' + dataTableId).DataTable().scroller.measure();
            })
    ```

# Implementation notes

-   the quick-and-dirty trick with `shiny::tabsetPanel` as hidden tabs to create some sort of dynamic GUI seems to be not working with `miniUI` if I want to have the page fully filled; I guess the reason is that the nesting of `miniContentPanel(tabsetPanel(tabPanelBody(fillCol(…` results in `fillCol` being the child of a *div* that has no explicit height.As here, the commented stuff does not work as intended - when using the uncommented part, the full height DT table works:

    ``` r
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

-   as for the DT server side, the plugin `scrollResize` does the trick to have the DT table fill the full available (remaining) page height (the commented part has some funny / buggy behavior):\
    <https://datatables.net/blog/2017-12-31>

    ``` r
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

    however, `scrollResize` and `scroller` together seem to result in an odd bug: after initializing, the infotext below the datatable shows the wrong numbers "Showing x to y of z ...", where especially y seems to be off. As soon as the window has been resized once this is fixed and from there on the numbers are correct. I did no thorough investigation, but I assume this might have something to do with how `scroller` calculates the number of displayed rows, where probably the fixed pixel-value that is used when initializing is used - however this value may not be the actual one due to interaction with `scrollResize`. I.e. in the server function the datatable is rendered like this:

    ``` r
    DT::renderDT(
            mtcars,
            options = list(scrollResize = TRUE, scrollY = "200px", scroller = TRUE),
            extensions = c("Scroller"),
            plugins = c("scrollResize")
        )
    ```

    However, this 200px are overruled (or rather updated) by `scrollResize`. As a first fix, I tried this

    ``` r
    DT::renderDT(
            mtcars,
            options = list(scrollResize = TRUE, 
                           scrollY = input$windowSize[1], 
                           scroller = TRUE),
            extensions = c("Scroller"),
            plugins = c("scrollResize")
        )
    ```

    where I use the window size (i.e. the height) after connecting to shiny by client side javascript. ui.R:

    ``` r
    tags$head(tags$script(
            "
            var windowSize = [0, 0];
            $(document).on('shiny:connected', function(e) {
                windowSize[0] = window.innerWidth;
                windowSize[1] = window.innerHeight;
                Shiny.onInputChange('windowSize', windowSize);
            });
            $(window).resize(function(e) {
                windowSize[0] = window.innerWidth;
                windowSize[1] = window.innerHeight;
                Shiny.onInputChange('windowSize', windowSize);
            });
            "
        ))
    ```

    Worth noting, that `Shiny.onInputChange` is superseded by `Shiny.setInputChange`. Since this is only required once after initializing, the update function on resize is not really required. This of course does not work as I need the actual height of the datatable's scrollBody. So i need to do something like this

    ``` {.javascript .R}
    const contactList = document.getElementById('contact_list');
    const scrollBody = contactList.getElementsByClassName('dataTables_scrollBody')[0];
    ```

    But the question is when to do this. Using `(document).ready()` and `(window).on('load', …)` did not work, as the `dataTables_scrollBody` could not yet be derived - but when I do the same thing manually in the console it works. Maybe I need to wait until some code from `scrollResize` has been executed after startup?

    Maybe this (found here: <https://stackoverflow.com/questions/5525071/how-to-wait-until-an-element-exists>):

    ``` javascript
    function waitForElm(selector) {
        return new Promise(resolve => {
            if (document.querySelector(selector)) {
                return resolve(document.querySelector(selector));
            }

            const observer = new MutationObserver(mutations => {
                if (document.querySelector(selector)) {
                    observer.disconnect();
                    resolve(document.querySelector(selector));
                }
            });

            observer.observe(document.body, {
                childList: true,
                subtree: true
            });
        });
    }

    // to use it:
    waitForElm('.some-class').then((elm) => {
        console.log('Element is ready');
        console.log(elm.textContent);
    });

    // or async/await:
    const elm = await waitForElm('.some-class');
    ```

    This didn't work, I got an "unexpected token &" error in the console. Another approach: Maybe create an eventListener for #contact_list element that fires when a child with class "dataTables_scrollBody" is added. I also tried this:

    ``` javascript
    var contactListScrollBodyHeight = 0;
            $(document).ready(function(e) {
                const observer = new IntersectionObserver(updateHeight, { childList: true });

                function updateHeight(mutationsList, observer) {
                    for (const mutation of mutationsList) {
                        if (mutation.type === 'childList') {
                            console.log(mutation.addedNodes[0]);
                            const scrollBody = mutation.addedNodes[0]?.getElementsByClassName('dataTables_scrollBody');

                            if (scrollBody)
                                Shiny.onInputChange('contact_list_scroll_height', scrollBody[0].offsetHeight);
                        }
                    }
                }

                const contactList = document.getElementById('contact_list');
                observer.observe(contactList);
            });
    ```

    To tired now to finish this... Besides, there has to be an easier and cleaner way.\
    OK, here's the thing (could be so easy): I could just use

    ``` javascript
    $('#DataTables_Table_0').DataTable().scroller.measure()
    ```

    This will trigger the re-measurement of the DT by the scroller extension. However, two issues here:

    -   the ID is dynamically created and I cannot define it from within shiny (it seems)

    -   when to call the code?

    Maybe a onetime drawCallback which only executes once:

    ``` r
    output$contact_list <- DT::renderDT(
            rbind(mtcars, mtcars, mtcars, mtcars),
            options = list(scrollResize = TRUE, scrollY = "313px", scroller = TRUE),
            extensions = c("Scroller"),
            plugins = c("scrollResize"),
            callback = DT::JS(
                "
                table.scroller.measure(); // this apparently has no effect
                table.scroller.toPosition(3); // this works
                console.log(table); // this works
                console.log('hello'); // this works
                return table;
                "
            )
        )
    ```

    I really don't get it.... Why in the completely wild fuck does `table.scroller.measure()` not work here while it works when executed in the console?!

    Ok, I can't be bothered anymore. In the end, I might have to admit that using extension `scroller` together with the `scrollResize` plugin might just be a bad idea. I'm probably better of just using `scrollResize` which basically has all the functionality I need except for the dynamic update of the info text beneath the table (indicating which rows are currently shown). It will be easier to just implement this missing feature myself than trying to get these two fellas to work together. First idea for implementation is to use a callback.

    **Custom info text for currently displayed rows:**

    -   javascript function to determine the currently displayed rows

        ``` javascript
        function getDisplayedRows() {
                    scrollBody = document.querySelectorAll('#contact_list .dataTables_scrollBody')[0];

                    const rows = document.querySelectorAll('#contact_list tbody tr');
                    const rowHeights = Array.from(rows, (r) => r.offsetHeight);
                    console.log(scrollBody);

                    scrollBody.addEventListener('scroll', function() {
                        const topPosition = scrollBody.scrollTop;
                        const bodyHeight = scrollBody.clientHeight;
                        console.log('topPos: ' + topPosition + ' bdHeight: ' + bodyHeight);
                        let firstRow = 0;
                        let sumHeight = 0;

                        for (let i = 0; i < rowHeights.length; i++) {
                            sumHeight += rowHeights[i];

                            if (sumHeight >= topPosition) {
                                firstRow = i;
                                break;
                            }
                        }

                        let lastRow = firstRow;
                        sumHeight = 0;

                        for (let i = firstRow; i < rowHeights.length; i++) {
                            sumHeight += rowHeights[i];

                            if (sumHeight > bodyHeight) {
                                lastRow = i;
                                break;
                            }
                        }

                        console.log('The first row: ' + (firstRow + 1) + ', the last row: ' + (lastRow + 1));
                    });
                }
        ```

        This functions first creates a lookup array to store all row heights, then registers an eventlistener that executes the determination of the currently displayed rows given the previously stored row heights. This uses the row heights at the time of creation of the listener, hence resizing the window, the table or adding/removing columns will result in wrong calculation. The array creation can be done in the event listener, but this might slow down the calculation.

    -   this function can f.ex. be used with `datatable`'s `initComplete` callback

    -   this is still an early version. To do:

        -   [ ] make this independent from the datatable id (here: '#contact_list') which is currently hardcoded in the function

        -   [ ] optimize for better performance, e.g.

            -   scroll event is very chatty, when scrolling, this code doesn't need to run several times a second I guess....

            -   always checking all row heights (or making the rowHeights array) seems quiete inefficient

        -   [ ] this must also work if the table columns are changed, added or removed or if the body width changes, since row heights might change due to linebreaks; in any case this needs to be triggered if data changes or if window size changes, etc.
