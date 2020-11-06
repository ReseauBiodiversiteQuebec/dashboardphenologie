#' region_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_region_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    h2("selectez"),
    ggiraph::girafeOutput(ns("map_plot")),
    h2("plot:"),
    plotOutput(ns("gantt_plot"))
    )
}
    
#' region_plot Server Functions
#'
#' @noRd 
mod_region_plot_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # output the map
    output$map_plot <- ggiraph::renderGirafe({
      ggiraph::girafe(ggobj = ggplot2::ggplot(shinyInat::regio_s) + 
                        ggplot2::geom_sf() + 
                        ggiraph::geom_sf_interactive(ggplot2::aes(tooltip = RES_NM_REG, 
                                                                  data_id = RES_NM_REG),
                                                     fill = "lightblue", lwd = 1.2) +
                        ggplot2::theme_void(),
                      options = list(ggiraph::opts_selection(type = "single",
                                                             only_shiny = TRUE,
                                                             selected = "Outaouais"))
      )
    })
    
    gantt_of_inat <- shinyInat::inat_data_to_gantt
    one_sites <- reactive(
      subset(gantt_of_inat,
             gantt_of_inat$region == input$map_plot_selected)
    )

    output$gantt_plot <- renderPlot({
      ggplot2::ggplot(one_sites(), ggplot2::aes(x = jday, y = taxon_species_name)) +
        ggplot2::geom_line(size = 10, col = "darkgreen") +
        ggplot2::theme_minimal() +
        ggplot2::coord_cartesian(xlim = c(0,365))
    })
    
    })
}
    
## To be copied in the UI
# mod_region_plot_ui("region_plot_ui_1")
    
## To be copied in the server
# mod_region_plot_server("region_plot_ui_1")
