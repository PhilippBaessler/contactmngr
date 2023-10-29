ui <- miniUI::miniPage(
    tags$head(tags$script(HTML(
        "
        function registerRowInfoHandler(id) {
            function setCumSumRowHeights(scrollBody) {
                const rows = document.querySelectorAll('#' + id + ' tbody tr');
                const rowHeights = Array.from(rows, (r) => r.offsetHeight);

                cumsumHeights = rowHeights.map( (sum => value => sum += value)(0) );
            }

            function updateRowInfoText(rowInfoContainer) {
                const topPosition = scrollBody.scrollTop;
                const bodyHeight = scrollBody.clientHeight;
                let firstRow = 0;

                for (let i = 0; i < cumsumHeights.length; i++) {
                    if (cumsumHeights[i] >= topPosition) {
                        firstRow = i;
                        break;
                    }
                }

                let lastRow = firstRow;

                for (let i = firstRow; i <= cumsumHeights.length; i++) {
                    lastRow = i;
                    if (cumsumHeights[i] - cumsumHeights[firstRow] > bodyHeight)
                        break;
                }

                // console.log('The first row: ' + (firstRow + 1) + ', the last row: ' + (lastRow + 1));
                rowInfoContainer.innerHTML = 'Showing ' + (firstRow + 1) + ' to ' + lastRow + ' of ' + cumsumHeights.length + ' rows';
            }

            const scrollBody = document.querySelectorAll('#' + id + '_wrapper .dataTables_scrollBody')[0];
            const rowInfoDiv = document.querySelectorAll('#' + id + '_info')[0];

            console.log(scrollBody);

            let cumsumHeights =  [];
            setCumSumRowHeights(scrollBody);

            window.addEventListener('resize', function() {
                setCumSumRowHeights(scrollBody);
                updateRowInfoText(rowInfoDiv);
            })

            scrollBody.addEventListener('scroll', function() {
                updateRowInfoText(rowInfoDiv);
            });
        }
        "
    ))),
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
                             style = "display: inline-block;"),
                actionButton("DEBUG_trigger_scroller_measure", "DEBUG trigger scroller",
                             style = "display: inline-block;")
            ),
            DT::DTOutput("contact_list", height = "100%")
        )
    )
)

