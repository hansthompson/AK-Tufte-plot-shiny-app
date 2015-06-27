library(dplyr)
library(tidyr)
library(magrittr)
library(ggplot2)
load("AKweather.rda")
#input <- list(city = "Anchorage", year = 2014, month = 1)

shinyServer(function(input, output) {

p <- reactive({
    
    AKweather %>%
        filter(city == input$city) %>%
        group_by(year, month) %>%
        arrange(day) %>%
        ungroup() %>%
        group_by(year) %>%
        mutate(newday = seq(1, length(day))) %>%   # label days as 1:365 (will represent x-axis)
        ungroup() %>%
        filter(temp != -99 & year != input$year) %>%     # filter out missing data (identified with '-99' value) & current year data
        group_by(newday) %>%
        mutate(upper = max(temp), # identify max value for each day
               lower = min(temp), # identify min value for each day
               avg = mean(temp),  # calculate mean value for each day
               se = sd(temp)/sqrt(length(temp))) %>%  # calculate standard error of mean
        mutate(avg_upper = avg+(2.101*se),  # calculate 95% CI for mean
               avg_lower = avg-(2.101*se)) %>%  # calculate 95% CI for mean
        ungroup() -> past
    
    # create dataframe that represents current year data
    AKweather %>%
        filter(city == input$city) %>%
        group_by(year, month) %>%
        arrange(day) %>%
        ungroup() %>%
        group_by(year) %>%
        mutate(newday = seq(1, length(day))) %>%  # create matching x-axis as historical data
        ungroup() %>%
        filter(temp != -99 & year == input$year) -> present   # filter out missing data & select current year data
    
    # create dataframe that represents the lowest temp for each day for the historical data
    pastlows <- past %>%
        group_by(newday) %>%
        summarise(Pastlow = min(temp)) # identify lowest temp for each day from 1995-2914
    
    # create dataframe that identifies the days in 2014 in which the temps were lower than all previous 19 years
    presentlows <- present %>%
        left_join(pastlows) %>%  # merge historical lows to current year low data
        mutate(record = ifelse(temp<Pastlow, "Y", "N")) %>% # identifies if current year was record low
        filter(record == "Y")  # filter for days that represent current year record lows
    
    # create dataframe that represents the highest temp for each day for the historical data
    pasthighs <- past %>%
        group_by(newday) %>%
        summarise(Pasthigh = max(temp))  # identify highest temp for each day from 1995-2014
    
    # create dataframe that identifies the days in 2014 in which the temps were higher than all previous 19 years
    presenthighs <- present %>%
        left_join(pasthighs) %>%  # merge historical highs to current year low data
        mutate(record = ifelse(temp>Pasthigh, "Y", "N")) %>% # identifies if current year was record high
        filter(record == "Y")  # filter for days that represent current year record highs

    
    
    dgr_fmt <- function(x, ...) {
        parse(text = paste(x, "*degree", sep = ""))
    }
    
    # create y-axis variable
    a <- dgr_fmt(seq(-50,90, by=10))
    
    p <- ggplot(past, aes(newday, temp)) +
        theme(plot.background = element_blank(),
              panel.grid.minor = element_blank(),
              panel.grid.major = element_blank(),
              panel.border = element_blank(),
              panel.background = element_blank(),
              axis.ticks = element_blank(),
              axis.title = element_blank()) +
        geom_linerange(past, 
                       mapping=aes(x=newday, ymin=lower, ymax=upper), colour = "wheat2", alpha=.1)
    
    #Next, we can add the data that represents the 95% confidence interval around the daily mean temperatures for 1975-2013.
    p <- p +
        geom_linerange(past,
                       mapping=aes(x=newday, ymin=avg_lower, ymax=avg_upper), colour = "wheat4")
    
    p <- p +
        geom_line(present, mapping=aes(x=newday, y=temp, group=1)) +
        geom_vline(xintercept = 0, colour = "wheat3", linetype=1, size=1)
    
    p <- p + 
        geom_hline(yintercept = -20, colour = "white", linetype=1) +
        geom_hline(yintercept = 0, colour = "white", linetype=1) +
        geom_hline(yintercept = 20, colour = "white", linetype=1) +
        geom_hline(yintercept = 40, colour = "white", linetype=1) +
        geom_hline(yintercept = 60, colour = "white", linetype=1) +
        geom_hline(yintercept = 80, colour = "white", linetype=1)
    
    p <- p +
        geom_vline(xintercept = 31, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 59, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 90, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 120, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 151, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 181, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 212, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 243, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 273, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 304, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 334, colour = "wheat3", linetype=3, size=.5) +
        geom_vline(xintercept = 365, colour = "wheat3", linetype=3, size=.5)
    
    p <- p +
        coord_cartesian(ylim = c(-50,90)) +
        scale_y_continuous(breaks = seq(-50,90, by=10), labels = a) +
        scale_x_continuous(expand = c(0, 0),
                           breaks = c(15,45,75,105,135,165,195,228,258,288,320,350),
                           labels = c("January", "February", "March", "April",
                                      "May", "June", "July", "August", "September",
                                      "October", "November", "December"))
    
    #Step 7
    p <- p +
        geom_point(data=presentlows, aes(x=newday, y=temp), colour="blue3") +
        geom_point(data=presenthighs, aes(x=newday, y=temp), colour="firebrick3")
    
    p <- p +
        ggtitle(paste(paste0(input$city, "'s Weather in ", input$year))) +
        theme(plot.title=element_text(face="bold",hjust=.012,vjust=.8,colour="#3C3C3C",size=20)) +
        annotate("text", x = 35, y = 98, label = "temperature in Fahrenheit", size=4, fontface="bold")
    
    
    p <- p +
        annotate("text", x = 63, y = 80,
                 label = paste("Record Highs Since 1995:", dim(presenthighs)[1], "Days"), size=4, colour="gray30") +
        annotate("text", x = 63, y = 75,
                 label = paste("Record Lows Since 1995:", dim(presentlows)[1], "Days"), size=4, colour="gray30") 
    
    present %>% filter(newday %in% c(180:185)) %>% select(x = newday, y =  temp) %>% data.frame -> legend_data
    legend_data$y - 65 -> legend_data$y
    p +
        annotate("segment", x = 182, xend = 182, y = 5, yend = 25, colour = "wheat2", size=3) +
        annotate("segment", x = 182, xend = 182, y = 12, yend = 18, colour = "wheat4", size=3) +
        #geom_line(data=legend_data, aes(x=x,y=y)) +
        annotate("segment", x = 184, xend = 186, y = 17.7, yend = 17.7, colour = "wheat4", size=.5) +
        annotate("segment", x = 184, xend = 186, y = 12.2, yend = 12.2, colour = "wheat4", size=.5) +
        annotate("segment", x = 185, xend = 185, y = 12.2, yend = 17.7, colour = "wheat4", size=.5) +
        annotate("text", x = 197, y = 14.75, label = "NORMAL RANGE", size=3, colour="gray30") +
        #annotate("text", x = 165, y = 14.75, label = "SELECTED YEAR", size=3, colour="gray30") +
        annotate("text", x = 195, y = 25, label = "RECORD HIGH", size=3, colour="gray30") +
        annotate("text", x = 195, y = 5, label = "RECORD LOW", size=3, colour="gray30")
})

output$p <- renderPlot({
  print(p())
})

})