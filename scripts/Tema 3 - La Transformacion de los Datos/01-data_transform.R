library(tidyverse)
library(nycflights13)

nycflights13::flights
?flights

View(flights)

# tibble es un data frame mejorado para tidyverse
## * int -> números enteros
## * dbl -> números reales (double)
## * chr -> vector de caracteres o strings
## * dttm -> date + time
## * lgl -> logical, contiene valores booleanos (T o F)
## * fctr -> factor, variables categóricas
## * date -> (día, mes y año)

## * filter() -> filtrar observaciones a partir de valores concretos
## * arrange() -> reordenar las filas
## * select() -> seleccionar variables por sus nombres
## * mutate() -> crea nuevas variables con funciones a partir de las existentes
## * summarise() -> colapsar varios valores para dar un resumen de los mismos
## * group_by() -> opera la función a la que acompaña grupo a grupo

## 1 - data frame
## 2 - operaciones que queremos hacer a las variables del data frame
## 3 - resultado en un nuevo data frame


## FILTER

jan1 <- filter(flights, month==1, day==1)
dec25 <- filter(flights, month==12, day==25)

(dec26 <- filter(flights, month==12, day==26)) # todo entre parentesis para tambien mostrarlo por consola

# comparaciones:
# >, >=, <, <=, ==, !=

filter(flights, month==5)

2 == 2

sqrt(2)^2 == 2 # FALSE por problemas de redondeo
near(sqrt(2)^2, 2) # esta "cerca"

1/pi * pi == 1

1/49 * 49 == 1 # FALSE por problemas de redondeo
near(1/49*49, 1) # esta "cerca"

filter(flights, month==5 | month==6)

filter(flights, month==5 | 6) # ESTO NO FUNCIONA...

may_june <- filter(flights, month %in% c(5,6))

#!(x&y) == (!x)|(!y)
#!(x|y) == (!x)&(!y)

filter(flights, !(arr_delay >60 | dep_delay > 60))
filter(flights, arr_delay <= 60, dep_delay <= 60)

# Valores NA

NA > 0
10 == NA
NA + 5
NA / 5
NA == NA

# La tía May tiene una edad desconocida, No se como de vieja es
age.may <- NA
# El tío Ben también hace mucho que no lo veo, y no se cuantos años tiene
age.ben <- NA
# ¿Deben de tener la misma edad Ben y May?
age.may == age.ben

is.na(age.may)

df <- tibble(x = c(1,2,NA,4,5))
filter(df, x>2)
filter(df, is.na(x)|x>2) # para que incluya en el filtrado los NAs


## ORDENANDO LAS FILAS CON ARRANGE

sorted.date <- arrange(flights, year, month, day)

head(arrange(flights, desc(arr_delay)))

arrange(flights, desc(dep_delay))

arrange(df, desc(x))

arrange(df, x)

View(arrange(flights, carrier))

View(arrange(flights, desc(distance)))


## SELECT

View(sorted.date[1024:1068,])

select(sorted.date[1024:1068,], dep_delay, arr_delay)

select(flights, year, month, day)

select(flights, dep_time:arr_delay)

select(flights, -(year:day))

select(flights, starts_with("dep"))

select(flights, ends_with("delay"))

select(flights, contains("st"))

select(flights, matches("(.)\\1"))

select(flights, num_range("x", 1:5)) # x1, x2, x3, x4, x5

# Renombrar y ordenar las columnas

rename(flights, deptime = dep_time,
       año = year,
       mes = month,
       dia = day)

select(flights, deptime = dep_time)

select(flights, time_hour, distance, air_time, everything())


## MUTATE

flights_new <- select(flights,
                      year:day,
                      ends_with("delay"),
                      distance,
                      air_time)

mutate(flights_new, # añade a flights_new nuevas columnas
       time_gain = arr_delay - dep_delay, # diff_t (min)
       air_time_hour = air_time/60,
       flight_speed = distance/air_time_hour, # v = s/t (km/h)
       time_gain_per_hour = time_gain/air_time_hour
       ) -> flights_new

transmute(flights_new, # crea un dataset solo con estas columnas
          time_gain = arr_delay - dep_delay,
          air_time_hour = air_time/60,
          flight_speed = distance/air_time_hour,
          time_gain_per_hour = time_gain/air_time_hour
          ) -> data_from_flights


# * Operaciones aritméticas: +, -, *, /, ^ (hours + 6*minutes)
# * Agregados de funciones: x/sum(x): proporción sobre el total
#                           x - mean(x): distancia respecto de la media
#                           (x - mean(x)/sd(x)): tipificación
#                           (x - min(x))/(max(x)-min(x)): estandarizar entre [0,1]
# * Aritmética modular: %/% -> cociente de la división entera, %% -> resto de la división entera
#                       x == y*(x%/%y) + (x%%y)

transmute(flights,
          air_time,
          hour_air = air_time %/% 60,
          minute_air = air_time %/% 60
          )


# * Logaritmos: log() -> logartimo en base e, log2(), log10()
# * Offsets: lead() -> mueve hacia la izquierda
#            lag() -> mueve hacia la derecha

df <- 1:12
lag(df)
lead(df)


# * Funciones acumulativas: cumsum(), cumprod(), cummin(), cummax(), cummean()

cumsum(df)
cumprod(df)
cummin(df)
cummax(df)
cummean(df)


# * Comparaciones lógicas: >, >=, <, <=, ==, !=

transmute(flights,
          dep_delay,
          has_been_delayed = dep_delay > 0)


# * Rankings: min_rank()

df <- c(7,1,2,5,3,3,8,NA,3,4,-2)

df
min_rank(df)

df
min_rank(desc(df))

df
row_number(df)

df
dense_rank(df)

df
percent_rank(df)

df
cume_dist(df)

df
ntile(df, n = 4)

transmute(flights,
          dep_delay,
          ntile(dep_delay, n = 100))


## SUMMARISE

summarise(flights, delay = mean(dep_delay, na.rm = T))

by_month_group <- group_by(flights, year, month)
summarise(by_month_group, delay = mean(dep_delay, na.rm = T))

by_day_group <- group_by(flights, year, month, day)
summarise(by_day_group,
          delay = mean(dep_delay, na.rm = T),
          median = median(dep_delay, na.rm = T),
          min = min(dep_delay, na.rm = T)
          )

mutate(summarise(group_by(flights, carrier),
                 delay = mean(dep_delay, na.rm = T)),
       sorted = min_rank(delay)
       )


### PIPES
group_by_dest <- group_by(flights, dest)
delay <- summarise(group_by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = T),
                   delay = mean(arr_delay, na.rm = T)
                   )
delay <- filter(delay, count > 100, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 0.2) +
  geom_smooth(se = F) +
  geom_text(aes(label = dest), alpha = 0.6, size = 2.5)

delays <- flights %>%
  group_by(dest) %>%
  summarise(
    count = n(),
    dist = mean(distance, na.rm = T),
    delay = mean(arr_delay, na.rm = T)
  ) %>%
  filter(count > 100, dest != "HNL")

# x %>% f(y) <-> f(x,y)
# x %>% f(y) %>% g(z) <-> g(f(x,y),z)
# x %>% f(y) %>% g(z) %>% h(t) <-> h(g(f(x,y),z),t)

## Problemas con los NAs

flights %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay, na.rm = T),
            median = median(dep_delay, na.rm = T),
            sd = sd(dep_delay, na.rm = T),
            count = n()
            )

not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))
  
flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>%
  group_by(year, month, day) %>%
  summarise(mean = mean(dep_delay, na.rm = T),
            median = median(dep_delay, na.rm = T),
            sd = sd(dep_delay, na.rm = T),
            count = n()
  )

delay_numtail <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay))

ggplot(data = delay_numtail, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 5)

ggplot(data = delay_numtail, mapping = aes(x = delay)) +
  geom_histogram(binwidth = 5)

delay_numtail <- not_cancelled %>%
  group_by(tailnum) %>%
  summarise(delay = mean(arr_delay),
            count = n()
            )

ggplot(data = delay_numtail, mapping = aes(x = count, y = delay)) +
  geom_point(alpha = 0.1)

delay_numtail %>%
  filter(count > 20) %>%
  ggplot(mapping = aes(x = count, y = delay)) +
  geom_point(alpha = 0.2)

## Ejemplo del Béisbol

View(Lahman::Batting)
?Lahman::Batting

batting <- as_tibble(Lahman::Batting)

batters <- batting %>%
  group_by(playerID) %>%
  summarise(hits = sum(H, na.rm = T),
            bats = sum(AB, na.rm = T),
            bat.average = hits/bats
            )

batters %>%
  filter(bats > 100) %>%
  ggplot(mapping = aes(x = bats, y = bat.average)) +
  geom_point(alpha = 0.2) +
  geom_smooth(se = F)

batters %>%
  filter(bats > 100) %>%
  arrange(desc(bat.average))


# * Medidas de Centralización

not_cancelled %>%
  group_by(carrier) %>%
  summarise(mean = mean(arr_delay),
            mean2 = mean(arr_delay[arr_delay > 0]),
            median = median(arr_delay)
            )

# * Medidas de dispersión
not_cancelled %>%
  group_by(carrier) %>%
  summarise(sd = sd(arr_delay),
            iqr = IQR(arr_delay),
            mad = mad(arr_delay)
            ) %>%
  arrange(desc(sd))

# * Medidas de orden
not_cancelled %>%
  group_by(carrier) %>%
  summarise(first = min(arr_delay),
            q1 = quantile(arr_delay, 0.25),
            median = quantile(arr_delay, 0.5),
            q3 = quantile(arr_delay, 0.75),
            last = max(arr_delay)
            )

# * Medidas de posición
not_cancelled %>%
  group_by(carrier) %>%
  summarise(first_dep = first(dep_time),
            second_dep = nth(dep_time, 2),
            third_dep = nth(dep_time, 3),
            last_dep = last(dep_time)
            )

not_cancelled %>%
  group_by(carrier) %>%
  mutate(rank = min_rank(dep_time)) %>%
  filter(rank %in% range(rank))


# * Funciones de conteo
flights %>%
  group_by(dest) %>%
  summarise(count = n(),
            carriers = n_distinct(carrier),
            arrivals = sum(!is.na(arr_delay))
            ) %>%
  arrange(desc(carriers))

not_cancelled %>%
  count(dest)

not_cancelled %>%
  count(tailnum, wt = distance)

## sum/mean de valores lógicos
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(n_prior_5 = sum(dep_time < 500))

not_cancelled %>%
  group_by(carrier) %>%
  summarise(more_than_hour_delay = mean(arr_delay > 60)) %>%
  arrange(desc(more_than_hour_delay))


## Agrupaciones múltiples

daily <- group_by(flights, year, month, day)
per_day <- summarise(daily, n_fl = n())
per_day

per_month <- summarise(per_day, n_fl = sum(n_fl))
per_month

per_year <- summarise(per_month, n_fl = sum(n_fl))
per_year

business <- group_by(flights, carrier, dest, origin)
summarise(business, n_fl = n()) %>%
  summarise(n_fl = sum(n_fl)) %>%
  summarise(n_fl = sum(n_fl))

daily %>%
  ungroup() %>%
  summarise(n_fl = n())

business %>%
  ungroup() %>%
  summarise(n_fl = n())

flights %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

popular_dest <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)
popular_dest

popular_dest %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay/sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay)
