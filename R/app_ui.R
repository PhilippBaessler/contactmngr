ui <- miniUI::miniPage(
    tags$head(tags$script(
        "
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

            //const scrollBody = await waitForClassElement(contactList, 'dataTables_scrollBody');
            //console.log(contactList);
            //console.log(scrollBody);
            //const scrollBody = contactList.getElementsByClassName('dataTables_scrollBody')[0];
            //Shiny.onInputChange('contact_list_scroll_height', scrollBody.offsetHeight);
        });
        "
    )),
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

