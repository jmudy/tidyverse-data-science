library(tidyverse)

# Análisis exploratorio de datos
# * Modelar
# * Representación gráfica
# * Transformar datos

# * ¿Qué tipo de variaciones sufren las variables?
# * ¿Qué tipo de covariación sufren las variables?

# * variable: cantidad, facvtor o propiedad medible
# * valor: estado de una variable al ser medida
# * observación: conjunto de medidas tomadas en condiciones similares
#                data point, conjunto valores tomados para cada variable
# * datos tabulares: conjunto de valores, asociado a cada variable y observación
#                    si los datos están limpios, cada valor tiene su propia celda
#                    cada variable tiene su columna, y cada observación su fila


#### VARIACIÓN

## Variables categóricas: factor o vector de caracteres

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

diamonds %>%
  count(cut)

## Variables contínuas: conjunto infinito de valores ordenados (números, fechas)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

diamonds %>%
  count(cut_width(carat, 0.5))

diamonds_filter <- diamonds %>%
  filter(carat < 3)

ggplot(data = diamonds_filter) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.01)

ggplot(data = diamonds_filter, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)


# * Cuales son los valores más comunes? Por qué?
# * Cuales son los valores más raros? Por qué? Cumple con lo que esperábamos?
# * Vemos algún patrón característico o inusual? Podemos explicarlos?

# * Qué determina que los elementos de un cluster sean similares entre sí?
# * Qué determina que clusters separados sean diferentes entre sí?
# * Describir y explicar cada uno de los clusters que hemos generado
# * Por qué alguna observación puede ser clasificada en el cluster erróneo...

ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_histogram(binwidth = 0.2)

# Outliers
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 100))

unusual_diamonds <- diamonds %>%
  filter(y < 2 | y > 30) %>%
  select(price,x,y,z) %>%
  arrange(y)
unusual_diamonds

good_diamonds <- diamonds %>%
  filter(between(y, 2.5, 29.5))

good_diamonds <- diamonds %>%
  mutate(y = ifelse(y<2 | y>30, NA, y))
good_diamonds

ggplot(data = good_diamonds, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = T) # no hace falta poner na.rm = T, salta warning y ya esta

nycflights13::flights %>%
  mutate(cancelled = is.na(dep_time),
         sched_hour = sched_dep_time %/% 100,
         sched_min = sched_dep_time %% 100,
         sched_dep_time = sched_hour + sched_min/60
         ) %>%
  ggplot(mapping = aes(sched_dep_time)) +
  geom_freqpoly(mapping = aes(color = cancelled), binwidth = 1/4)


#### COVARIACIÓN

# Categoría vs Contínua

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(reorder(class, hwy, FUN = median), y = hwy))

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip() # girar gráfico


# Categoría vs Categoría

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>%
  count(color, cut)

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(x = cut, y = color)) +
  geom_tile(mapping = aes(fill = n))


# Contínua vs Contínua

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price), alpha = 0.2)

library(hexbin)
ggplot(data = diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) +
  geom_hex(mapping = aes(x = carat, y = price))

diamonds %>%
  filter(carat < 3) %>%
    ggplot(mapping = aes(x = carat, y = price)) +
    geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)), varwidth = T)

diamonds %>%
  filter(carat < 3) %>%
  ggplot(mapping = aes(x = carat, y = price)) +
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))


# Relaciones y los patrones
# * ¿Coincidencias?
# * ¿Relaciones que implica el patrón?
# * ¿Fuerza de la relación?
# * ¿Otras variables afectadas?
# * ¿Subgrupos?

ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))


library(modelr)
mod <- lm(log(price) ~ log(carat), data = diamonds)
mod

diamonds_pred <- diamonds %>%
  add_residuals(mod) %>%
  mutate(res = exp(resid))
diamonds_pred

ggplot(data = diamonds_pred) +
  geom_point(mapping = aes(x = carat, y = resid))

ggplot(data = diamonds_pred) +
  geom_boxplot(mapping = aes(x = cut, y = resid))


faithful %>%
  filter(eruptions > 3) %>%
  ggplot(aes(eruptions)) +
    geom_freqpoly(binwidth = 0.2)


diamonds %>%
  count(cut, clarity) %>%
  ggplot(aes(clarity, cut, fill = n)) +
    geom_tile()
