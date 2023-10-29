tmp_data <- rbind(mtcars, mtcars, mtcars, mtcars)
tmp_data$mpg <- 1:nrow(tmp_data)

server <- function(input, output, session) {
    output$contact_list <- DT::renderDT(
        tmp_data,
        options = list(scrollResize = TRUE,
                       paging = FALSE,
                       scrollY = "100%",
                       initComplete = DT::JS(HTML(
                           "
                           function(settings, object) {
                               console.log(settings.nTable.id);
                               getDisplayedRows(settings.nTable.id);
                           }
                           "
                       ))),
        extensions = c("Scroller"),
        plugins = c("scrollResize")
    )
}
