#install packages
require(EpiModel)
library(shiny)
library(ggplot2)
library(plotly)

source('app_server.R')



# --------- CREATE WIDGETS ---------- 

mask_type_input <- selectInput(
  "mask",
  label = h3("Type of Mask Behavior"),
  choices = c("No Mask (Both Parties)" = 0.9,
              "Cloth Mask (Carrier)" = 0.7,
              "Medical Standard/N95 (Healthy)" = 0.3,
              "Medical Standard/N95 (Carrier)" = 0.05,
              "Medical Standard/N95 (Both Parties)" = 0.01
              ),
  multiple = FALSE,
  )

mask_type_icm <- selectInput(
  "mask_icm",
  label = h3("Type of Mask Behavior"),
  choices = c("No Mask (Both Parties)" = 0.9,
              "Cloth Mask (Carrier)" = 0.7,
              "Medical Standard/N95 (Healthy)" = 0.3,
              "Medical Standard/N95 (Carrier)" = 0.05,
              "Medical Standard/N95 (Both Parties)" = 0.01
  ),
  multiple = FALSE,
)

social_dist_input <- checkboxInput(
  "social",
  label = h4("Enforce Strict Social Distancing Measures"),
  value = FALSE
)

social_dist_icm <- checkboxInput(
  "social_icm",
  label = h4("Enforce Strict Social Distancing Measures"),
  value = FALSE
)

time_input <- selectInput(
  "time",
  label = h4("Approx. Length of Time"),
  choices = c("3 Months" = 90,
              "Half Year" = 200,
              "Year 1" = 400,
              "Year 2" = 800
  ),
  multiple = FALSE,
)

time_input_icm <- selectInput(
  "time_icm",
  label = h4("Approx. Length of Time"),
  choices = c("3 Months" = 90,
              "Half Year" = 200,
              "Year 1" = 400,
              "Year 2" = 800
  ),
  multiple = FALSE,
)

pop_size_input <- sliderInput(
  inputId = "pop_size",
  label = h4("Select the Size of Initial Population"),
  min = 500, max = 10000, step = 100,
  value = 1000, dragRange = FALSE
)

pop_size_drop <- selectInput(
  "pop_drop",
  label = h4("Select the Size of Initial Population"),
  choices = c("500" = 500,
              "1000" = 1000,
              "2000" = 2000,
              "4000" = 4000
  ),
  multiple = FALSE,
)

# --------- CREATE PAGES ---------- 

dcm_model <- tabPanel(
  title = "Deterministic Model",                   
  sidebarLayout(             
    sidebarPanel( 
      time_input,
      mask_type_input,
      social_dist_input,
      pop_size_input
    ),           
    mainPanel(
      plotOutput('det')
    )
  )
)

icm_model <- tabPanel(
  "Stochastic Model",
  sidebarLayout(
    sidebarPanel(
      time_input_icm,
      mask_type_icm,
      social_dist_icm,
      pop_size_drop
    ),
    mainPanel(
      plotOutput('stoc')
    )
  )
)

insight_page <- tabPanel(
 title = "Interpretations",
 mainPanel(
   tags$h1(
     id = "insights",
     paste("Insights for Future Projects")
   ),
   tags$h2(
     id = "insights_dcm",
     paste("Insights from the DCM Model")
   ),
   p(
     id = "insight_dcm",
     "The DCM model allows a more simplistic model of the paramaters as it does not take into 
      account any random variability and that each person acts the same with each step. Without 
      any type of non-pharmaceutical interventions (NPIs) in use, it is interesting to see that 
      the spread of the disease is very rapid with the total amount of people becoming infected 
      within 3 weeks time (20 steps). Assuming that every person is able to adhere to strict social
      distancing measure and the carrier is wearing a mask, transmission would be nearly non-existant
      as shown by a nearly flat line as people are able to recover without spreading to others. 
      Interestingly, if the carrier wears a mask then within half a year the number of infected will
      reach near zero and there will be a portion of the population that will still be in the susceptible
      group. This shows that NPIs are a valid measure in protecting susceptible populations by limiting
      the rate in which people are able to get infected and spread the disease to others.
     "),
   tags$h2(
     id = "insight_icm",
     paste("Insights from the ICM Model")
   ),
   tags$p(
     id = "insight_icm",
     paste("A unique feature of the ICM model over the DCM model is that it takes into account 
            some level of randomness. This model is smoother when dealing with high chances of 
            infection which makes it easier to see the overall trend. The use of cloth masks may
            not be enough to protect susceptible populations as the entire population will move into
            infected and recovered compartments within 2 weeks. The healthy moniker is the spread
            of covid between a carrier without a mask and a susceptible individual wearing a mask.
            This had very little effect on keeping the disease isolated because of also having a high
            activity rate. One major difference between the two models is that the ICM model will predict
            values that tend to be less than those predicted in the DCM model. Interestingly, the variability
            when looking at the spread when the infected wear a mask to hinder spread we find that the model
            has high uncertainty and that half still get infected before reaching a point of equilibrium.
           ")
   ),
   tags$h2(
     id = "limits",
     paste("Limitations of the Study and Models")
   ),
   tags$p(
     id = "limits",
     paste("One major limitation that arose from this project are the types of populations that 
            the insights from the models will be able to apply to. The DCM model assumes that each person acts
            the same way throughout but the conditions in which people live their lives are more complex. For instance,
            it may not be a possibility to completely limit interactions to a small degree. People can live
            in multi-generational houses or have jobs that require face-to-face interactions which would increase
            the ability for the disease to spread.", "
            This project does not take into account the differing transmission and reinfection
            rates of the different variants. Various studies report differing infection, transmission, and re-infection
            rates for novel variants which are not taken into accout for this project. Instead, I will link
            the study in which these values originated. Variants are one way that infection probability
            fluctuates however it is harder to predict when unique variants present themselves and takes
            time for all parameters to be measured.")
   )
 )
)

intro_page <- tabPanel(
  title = "Introduction",
  mainPanel(
    tags$h1(
      id = "greeting",
      paste("Welcome to a Brief Model of Covid-19")
    ),
    tags$h2(
      id = "overview",
      paste("Project Overview: Details and Data Sources")
    ),
    p(
      id = "overview",
      paste("The purpose of this project is to take current measurements of the spreadability of covid-19
            and present them through two models: deterministic and stochastic. The decision to use the SIR 
            model is due to a 'period of infection-induced immunologic protection against reinfection' (CDC, 2021). 
            This protection wanes over time allowing people to become susceptible but current studies show that 
            the believed rate is less than 1%. Mask usage and Social Distancing measures are chosen as important
            interventions because of the difficulty of identifying asymptomatic carriers that can still spread the 
            virus. It may be more important to understand the effect non-pharmaceutical interventions has on 
            reducing the overall spread over a period of time.
            ")
      ),
    tags$h2(
      id = "data",
      paste("Data Source Origins")
    ),
    tags$p(
      id = "data",
      paste("The values used in this model are simplified in comparison to real-world scenarios but are 
             taken from CDC statements and an article looking at the spread of covid through coughs as a
             point of contact. The activity rate assumes that people are not seeking out interactions
             but are going through a typical day to day. The recovery rate is the reciprocal of the mean 
             duration of the illness which is about 14 days. Each step in the model will represent one day.
             Below are links to the sites.",
            a("Duration of Disease", href = "https://www.cdc.gov/coronavirus/2019-ncov/hcp/duration-isolation.html"),
            a("Duration of Disease", href = "https://www.cdc.gov/coronavirus/2019-ncov/science/science-briefs/masking-science-sars-cov2.html"),
            a("Duration of Disease", href = "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7976050/")
            )
    )
  )
) 
# --------- DEFINING UI: PUTTING PAGES TOGETHER ----------
ui <- navbarPage(
  "A3: Disease Modeling",
  intro_page,
  dcm_model,
  icm_model,
  insight_page
)

