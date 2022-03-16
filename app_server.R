# load packages 
require(EpiModel)
library(tidyverse)
library(plotly)
library(shiny)
library(EpiModel)





# ------- INTERACTIVE VISUALIZAION PLOT ------- 
server <- function(input, output) {
    
  ########### Deterministic model ###########
  output$det <- renderPlot({
    act_rate <- 5.0
    if(input$social) {
      act_rate <- 0.5
    }
    
    param.dcm <- param.dcm(inf.prob = c(as.numeric(input$mask)), act.rate = act_rate, rec.rate = 1/14)
    init.dcm <- init.dcm(s.num = input$pop_size, i.num = 1,r.num = 0)
    control.dcm <- control.dcm(type = "SIR", nsteps = as.numeric(input$time))
    mod.dcm <- dcm(param.dcm, init.dcm, control.dcm)
    plot(mod.dcm, main = "Deterministic Model for Covid-19")
  })
  
   ########### Stochastic model ###########
  
   output$stoc <- renderPlot({
     act_rate <- 5.0
     if(input$social_icm) {
       act_rate <- 0.5
     }
     
     param.icm <- param.icm(inf.prob = c(as.numeric(input$mask_icm)), act.rate = act_rate, rec.rate = 1/14)
     init.icm <- init.icm(s.num = as.numeric(input$pop_drop), i.num = 1,r.num = 0)
     control.icm <- control.icm(type = "SIR", nsims = 50, nsteps = as.numeric(input$time_icm))
     mod.icm <- icm(param.icm, init.icm, control.icm)
     plot(mod.icm, main = "Stochastic Model for Covid-19")
   })
  
  
  
}
