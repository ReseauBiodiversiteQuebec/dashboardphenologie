#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  mod_region_plot_server("region_plot_ui_1")
  # mod_gantt_plot_server("gantt_plot_ui_1")
}
