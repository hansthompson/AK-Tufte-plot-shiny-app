shinyUI(
    fluidPage(#theme = "style.css",
        tags$head(includeScript("google-analytics.js")),
        verticalLayout(
            plotOutput("p", height = 525)
        ),
        sidebarLayout(
            sidebarPanel(
                sliderInput("year", label = h3("Year"), format="####",  
                            min=1995, max=2014, value=2014),
                br(),
                selectInput("city", label = h3("Muni"), 
                            choices = list("Anchorage" = "Anchorage",
                                           "Fairbanks" = "Fairbanks",
                                           "Juneau" = "Juneau"), 
                            selected = "Anchorage"),
                br(),
                div(img(src="cfanc.jpg"), style="text-align: center;")
                ),
            mainPanel(
                tabsetPanel(
                    tabPanel("Intro",
                             div(em("Please wait for the first plot to show up while the app loads before changing the Year and Muni selectors."), style = "text-align:center;"),
                             div(h3("How Warm Was 2014?"), style = "text-align:center;"),
                             p("Weather data is the average temperature for the day. The dataset extends back to 1995 and is only for Anchorage, Fairbanks, and Juneau in Alaska."),
                             p("2014 currently is only recorded up to Dec. 16th."),
                             p("The large dark bar at the right side of the chart representing the normal range is an artifact from low sample size of leap years.")
                             ),
                                            
                    tabPanel("About",
                             h3("References"),
                             p("The data for this app came from the", tags$a(href="http://academic.udayton.edu/kissock/http/Weather/citylistUS.htm", "Dayton Average Daily Temperature Archive"), "."),
                             p("The idea to create this weather app was adapted from a", tags$a(href="http://blog.revolutionanalytics.com/2015/01/a-beautiful-story-about-nyc-weather.html", "Revolutions Analytics blog post"), "."),
                             p("The original code was adapted from", 
                               tags$a(href="http://rpubs.com/bradleyboehmke/weather_graphic", "Bradley Boehmke"), 
                               "and",
                               tags$a(href="https://gist.github.com/abresler/46c36c1a88c849b94b07", "Alex Bresler"),"."),
                             p("The code to recreate this app is at the",
                               tags$a(href="https://github.com/codeforanchorage/AK-Tufte-plot-shiny-app", "Code for Anchorage"), 
                               "github."),
                             h3("Me"),
                             p("Developed By: Charles Hans Thompson"),
                             p("hans.thompson1@gmail.com"),
                             p(tags$a(href = "https://github.com/hansthompson", "Github Profile")),
                             p(tags$a(href = "https://www.linkedin.com/pub/charles-hans-thompson/6/b3/300", "LinkedIn Profile")))
                )))))