shinyUI(
    fluidPage(#theme = "style.css",
        verticalLayout(
            plotOutput("p", height = 525)
        ),
        sidebarLayout(
            sidebarPanel(
                sliderInput("year", label = h3("Year"), format="####",  
                            min=1995, max=2014, value=2014),
                selectInput("city", label = h3("Muni"), 
                            choices = list("Anchorage" = "Anchorage",
                                           "Fairbanks" = "Fairbanks",
                                           "Juneau" = "Juneau"), 
                            selected = "Anchorage"),
                div(img(src="cfanc.jpg"), style="text-align: center;")
                ),
            mainPanel(
                tabsetPanel(
                    tabPanel("Intro",
                             div(h3("How Warm Was 2014?"), style = "text-align:center;"),
                             p("Please wait for the first plot to show up while the app loads to before changing the Year and Muni selectors."),
                             p("Weather data extends back to 1995 and only for Anchorage, Fairbanks, and Juneau"),
                             p("2014 currently is only recorded to Dec. 16th."),
                             p("The large dark bar at the right side of the chart representing the normal range is an artifact from low sample size from leap years.")
                             ),
                                            
                    tabPanel("About",
                             p("The data for this app came from the", tags$a(href="http://academic.udayton.edu/kissock/http/Weather/citylistUS.htm", "Dayton Average Daily Temperature Archive"), "."),
                             p("The idea to create this weather app was adapted from a", tags$a(href="http://blog.revolutionanalytics.com/2015/01/a-beautiful-story-about-nyc-weather.html", "Revolutions Analytics blog post"), "."),
                             p("The original code was adapted from is from", 
                               tags$a(href="http://rpubs.com/bradleyboehmke/weather_graphic", "Bradley Boehmke"), 
                               "and",
                               tags$a(href="https://gist.github.com/abresler/46c36c1a88c849b94b07", "Alex Bresler"),"."),
                             p("The code to recreate this app is at the",
                               tags$a(href="https://github.com/hansthompson/AK-Tufte-plot-shiny-app", "Code for Anchorage"), 
                               "github."))
                    
                    
                )))))