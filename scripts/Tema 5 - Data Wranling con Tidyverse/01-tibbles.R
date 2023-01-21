library(tidyverse)

vignette("tibble")

View(iris)
class(iris)

iris_tibble <- as_tibble(iris)
class(iris_tibble)

t <- tibble(
  x = 1:10,
  y = pi,
  z = y*x^2
)

t$x
t$y
t$z

t[2,3]

t2 <- tibble(
  `:)` = "smilie",
  ` ` = "space",
  `1992` = "number"
)
t2

tribble(
  ~x, ~y, ~z,
#----|---|----|  
  "a", 4, 3.14,
  "b", 8, 6.28,
  "c", 9, -1.25
)

tibble(
  a = lubridate::now() + runif(1e3)*24*60*60,
  b = 1:1e3,
  c = lubridate::today() + runif(1e3)*30,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = T)
)

nycflights13::flights %>%
  print(n = 12, width = Inf)

options(tibble.print_max = 12, tibble.print_min = 12)
options(dplyr.print_min = Inf)
options(tibbles.width = Inf)

nycflights13::flights %>% #...
  View()

# [['nombre_variable']]
# [[posicion_variable]]
# $nombre_variable
df <- tibble(
  x = rnorm(10),
  y = runif(10)
)

df %>% .$x
df %>% .$y
df %>% .$z # salta warning cuando la variable no existe

df[["x"]]
df[["y"]]

df %>% .[["x"]]
df %>% .[["y"]]

df[[1]]
df[[2]]

df %>% .[[1]]
df %>% .[[2]]


# convertir a data frame cuando haya que utilizar
# funciones que no funcionan con tibbles
as.data.frame(df)

# [[]] para acceder a subconjuntos es mejor utilizar en tidyverse las funciones:
#dplyr::filter()
#dplyr::select()

# [[]] sobre data frame, puede devolver un data frame o un vector
# [[]] sobre una tibble, siempre devuelve una tibble
