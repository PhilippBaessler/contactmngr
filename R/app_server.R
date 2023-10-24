server <- function(input, output, session) {
    output$contact_list <- DT::renderDT(
        rbind(mtcars, mtcars, mtcars, mtcars),
        options = list(scrollResize = TRUE,
                       scrollY = "80vh", #"300px"
                       scroller = TRUE,
                       # scrollCollapse = FALSE, # no idea what this is doing
                       # this seems to introduce an infinite loop:
                       # drawCallback = DT::JS(
                       #     "
                       #     function() {
                       #      resizeAllDataTables();
                       #     }
                       #     "
                       # )),
                       # this does nothing:
                       stateLoaded = DT::JS(
                           "
                           function(settings, data) {
                              console.log('stateLoaded');
                              resizeAllDataTables();
                           }
                           "
                       ),
                       initComplete = DT::JS(
                           "
                           function(settings, data) {
                              console.log('initComplete');
                              resizeAllDataTables();
                           }
                           "
                       )),
        extensions = c("Scroller"),
        plugins = c("scrollResize"),
        callback = DT::JS(
            "
            console.log(contactListScrollBodyHeight);
            return(table);
            "
        )
    )

    observeEvent(input$DEBUG_trigger_scroller_measure, {
        session$sendCustomMessage("triggerScrollerMeasure",
                                  "contact_list")
    })
}
