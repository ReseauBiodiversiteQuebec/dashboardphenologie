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
  fluidRow(
    column(4, 
           h2("Selectez un region géographique"),
           ggiraph::girafeOutput(ns("map_plot"))
    ),
    column(6,
           h2("Quand sont les especes presentes?"),
           plotOutput(ns("gantt_plot"), height = 500),
           plotOutput(ns("count_plot"))
    )
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
      ggiraph::girafe(ggobj = ggplot2::ggplot(tableauphenologie::regio_s) + 
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
    
    # gather reactive expressions
    gantt_of_inat <- as.data.frame(tableauphenologie::inat_data_to_gantt)
    gantt_sites <- reactive(
      subset(gantt_of_inat,
             gantt_of_inat$region == input$map_plot_selected)
    )
    
    nper_day <- as.data.frame(tableauphenologie::nper_day)
    count_sites <- reactive(
      subset(nper_day,
             nper_day$region == input$map_plot_selected)
    )
    

    #render plots
    output$gantt_plot <- renderPlot({
      ggplot2::ggplot(gantt_sites(), ggplot2::aes(x = jday, y = taxon_species_name)) +
        ggplot2::geom_line(size = 20, col = "darkgreen") +
        ggplot2::theme_minimal() +
        ggplot2::coord_cartesian(xlim = c(0,365)) +
        ggplot2::labs(x = "Jour de l'année", 
             y = NULL)
    })
    
    output$count_plot <- renderPlot({
      ggplot2::ggplot(count_sites(), ggplot2::aes(x = dayrange, y = n)) + 
        ggplot2::geom_polygon() + 
        ggplot2::theme_minimal() + 
        ggplot2::coord_cartesian(xlim = c(0,365)) +
        ggplot2::labs(x = "Jour de l'année", 
                      y = "Richess d'especes")
    })
    
    })
}
    
## To be copied in the UI
# mod_region_plot_ui("region_plot_ui_1")
    
## To be copied in the server
# mod_region_plot_server("region_plot_ui_1")
