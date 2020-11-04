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
    plotOutput(ns("map_plot"))
    )
}
    
#' region_plot Server Functions
#'
#' @noRd 
mod_region_plot_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$map_plot <- renderPlot({
        ggplot2::ggplot(shinyInat::regio_s) + 
        ggplot2::geom_sf() + 
        ggplot2::theme_void()
    })
    })
}
    
## To be copied in the UI
# mod_region_plot_ui("region_plot_ui_1")
    
## To be copied in the server
# mod_region_plot_server("region_plot_ui_1")
