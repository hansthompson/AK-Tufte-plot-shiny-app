AKweather <- rbind(cbind(read.table("http://academic.udayton.edu/kissock/http/Weather/gsod95-current/AKANCHOR.txt"), city = "Anchorage"),
      cbind(read.table("http://academic.udayton.edu/kissock/http/Weather/gsod95-current/AKFAIRBA.txt"), city = "Fairbanks"),
      cbind(read.table("http://academic.udayton.edu/kissock/http/Weather/gsod95-current/AKJUNEAU.txt"), city = "Juneau"))
      
names(AKweather) <- c("month", "day", "year", "temp" , "city")


save(AKweather, file = "AKweather.rda")

head(AKweather)
