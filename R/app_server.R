server <- function(input, output, session) {
    # output$contact_list <- DT::renderDT(
    #     mtcars,
    #     options = list(scrollResize = TRUE, scrollY = "100%", scroller = TRUE),
    #     extensions = c("Scroller"),
    #     plugins = c("scrollResize")
    # )
    output$contact_list <- DT::renderDT(
        rbind(mtcars, mtcars, mtcars, mtcars),
        #options = list(scrollResize = TRUE, scrollY = input$windowSize[1], scroller = TRUE),
        options = list(scrollResize = TRUE, scrollY = "313px", scroller = TRUE),
        extensions = c("Scroller"),
        plugins = c("scrollResize"),
        callback = DT::JS(
            "
            table.scroller.measure();
            table.scroller.toPosition(3);
            console.log(table);
            return table;
            "
        )
    )

    observe({
        print("1")
        print(input$contact_list_scroll_height)
    })

    observe({
        print("2")
        print(input$contact_list_scroll_height)
    })
}
