#' simple_plot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_simple_plot_ui <- function(id){
  ns <- NS(id)
  tagList(
    h2("Its the iris whaaat"),
    plotOutput(ns("plot"))
  )
}
    
#' simple_plot Server Functions
#'
#' @noRd 
mod_simple_plot_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$plot <- renderPlot({
      plot(iris)
    })
  })
}
    
## To be copied in the UI
# mod_simple_plot_ui("simple_plot_ui_1")
    
## To be copied in the server
# mod_simple_plot_server("simple_plot_ui_1")
