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
## * group_by() -> opera la función a la que acompñaa grupo a grupo

## 1 - data frame
## 2 - operaciones que queremos hacer a las variables del data frame
## 3 - resultado en un nuevo data frame

### FILTER

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

transmutate(flights,
            air_time,
            hour_air = air_time %/% 60,
            minute_air = air_time %/% 60
            )

















