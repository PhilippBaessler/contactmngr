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
