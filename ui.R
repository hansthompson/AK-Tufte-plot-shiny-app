shinyUI(fluidPage(
    verticalLayout(
        plotOutput("p")
    ),
    sliderInput("year", label = h3("Year"), 
            min=1995, max=2014, value=2014),
    selectInput("city", label = h3("City"), 
            choices = list("Anchorage" = 1, "Fairbanks" = 2, "Juneau" = 3), 
            selected = 1)
)
)