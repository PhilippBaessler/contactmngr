ui <- miniUI::miniPage(
    tags$head(tags$script(
        "
        function resizeAllDataTables() {
            // just testing - here would need to be a proper handling of ids and classes
            const dataTableWrapper = document.getElementsByClassName('dataTables_wrapper')[0];
            dataTableId = dataTableWrapper.id.replace('_wrapper', '');
            console.log('now resizing...');
            console.log(dataTableId);
            //$('#' + dataTableId).DataTable().scroller.measure();
            $('#' + dataTableId).DataTable().tables( { visible: true, api: true } ).scroller.measure(); //https://datatables.net/reference/api/scroller.measure()
        }

        Shiny.addCustomMessageHandler('triggerScrollerMeasure', function(shinyId) {
            const dataTable = document.getElementById(shinyId);
            console.log(dataTable);
            const dataTableWrapper  = dataTable.getElementsByClassName('dataTables_wrapper')[0];
            console.log(dataTableWrapper);
            const dataTableId = dataTableWrapper.id.replace('_wrapper', '');
            console.log(dataTableId);
            $('#' + dataTableId).DataTable().scroller.measure();
        })

        $(document).on('resize', function(e) {
            // this approach seems to be always one step too late
            // e.g. try maximizing then unmaximizing then maximizing and so on, you will see that
            // the update of the info row beneath the datatable is always one step behind

            // just testing - here would need to be a proper handling of ids and classes
            const dataTableWrapper = document.getElementsByClassName('dataTables_wrapper')[0];
            dataTableId = dataTableWrapper.id.replace('_wrapper', '');
            $('#' + dataTableId).DataTable().scroller.measure();
        })

        var contactListScrollBodyHeight = 'TEST'; // used to test DT callback

        $(document).ready(function(e) {
            //does not really work
            //Shiny.setInputChange('contact_list_scroll_height', scrollBody.offsetHeight);
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
                             style = "display: inline-block;"),
                actionButton("DEBUG_trigger_scroller_measure", "DEBUG trigger scroller",
                             style = "display: inline-block;")
            ),
            DT::DTOutput("contact_list", height = "100%")
        )
    )
)

