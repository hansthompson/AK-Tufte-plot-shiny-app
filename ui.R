shinyUI(
        fluidPage(#theme = "style.css",
    verticalLayout(
        plotOutput("p", height = 525)
    ),
    sidebarLayout(
        sidebarPanel(
    sliderInput("year", label = h3("Year"), 
            min=1995, max=2014, value=2014),
    selectInput("city", label = h3("Muni"), 
            choices = list("Anchorage" = "Anchorage",
                           "Fairbanks" = "Fairbanks",
                           "Juneau" = "Juneau"), 
            selected = "Anchorage")),
    mainPanel(
        tabsetPanel(
            tabPanel("Intro",
        p("Please wait for the first plot to show up while the app loads to before changing the Year and Muni selectors."),
      p("A new p() command starts a new paragraph. Supply a style attribute to change the format of the entire paragraph", style = "font-family: 'times'; font-si16pt"),
      strong("strong() makes bold text."),
      em("em() creates italicized (i.e, emphasized) text."),
      br(),
      code("code displays your text similar to computer code"),
      div("div creates segments of text with a similar style. This division of text is all blue because I passed the argument 'style = color:blue' to div", style = "color:blue"),
      br(),
      p("span does the same thing as div, but it works with",
        span("groups of words", style = "color:blue"),
        "that appear inside a paragraph.")
    ),
    tabPanel("About",
             p(""))
    
)))))
