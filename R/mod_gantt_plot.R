#' gantt_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_gantt_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    plotOutput(ns("gantt_plot"))
  )
}
    
#' gantt_plot Server Functions
#'
#' @noRd 
mod_gantt_plot_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    chosen_reg <- reactive(input$map_plot_selected)
    one_sites <- subset(dashboardphenologie::inat_data_to_gantt,
                        dashboardphenologie::inat_data_to_gantt$region == chosen_reg())
    
    output$gantt_plot <- renderPlot({
      ggplot2::ggplot(one_sites, ggplot2::aes(x = jday, y = taxon_species_name)) +
        ggplot2::geom_line(size = 10, col = "darkgreen") +
        ggplot2::theme_minimal() +
        ggplot2::coord_cartesian(xlim = c(0,365))
  })
  })
}
    
## To be copied in the UI
# mod_gantt_plot_ui("gantt_plot_ui_1")
    
## To be copied in the server
# 
