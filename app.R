# app.R

#### Main app file #############################################################
source("global.R")

#### Source ui and server ######################################################

source("R/ui.R")
source("R/server.R")


#### Run the app ###############################################################

shinyApp(ui = ui, server = server)


