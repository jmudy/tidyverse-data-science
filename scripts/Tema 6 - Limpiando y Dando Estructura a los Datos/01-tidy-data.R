
library(tidyverse)

table <- read_csv("../data/population.csv")
View(table)

table %>%
  mutate(rate = cases/population*1e5)

table %>%
  count(year, wt = cases)

table %>%
  ggplot(aes(year, cases)) +
  geom_line(aes(group = country), color = "grey") +
  geom_point(aes(color = country))
