
library(tidyverse) # version 1.3.2

# tidyverse 1.3.2 ──
# ✔ ggplot2 3.3.6      ✔ purrr   0.3.4 
# ✔ tibble  3.1.8      ✔ dplyr   1.0.10
# ✔ tidyr   1.2.0      ✔ stringr 1.4.1 
# ✔ readr   2.1.2      ✔ forcats 0.5.2 

# Los coches con motor más grande consumen más combustible
# que los coches con motor más pequeño.
# La relación consumo/tamaño es lineal? Es no lineal? Es exponencial?
# Es positiva? Es negativa?

View(mpg)
?mpg #help(mpg)
# displ: tamaño del motor del coche en litros
# hwy: número de millas recorridas en autopista por galón de combustible (3.78541 litros)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

# Plantilla para hacer una representación gráfica con ggplot
#ggplot(data = <DATA_FRAME>) +
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
  
# Color de los puntos
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Tamaño de los puntos (conviene que sea numérico)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# Transparencia de los puntos
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Forma de los puntos (aparece warning porque ggplot solo permite 6 formas a la vez)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# Elección manual de estéticas
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "red") # Esto ya se trata de una estética global
# color = nombre del color en formato string
# size = tamaño en puntos en mm
# shape = forma del punto con números desde el 0 al 25
# 0 - 14: son formas huecas y por tanto solo se puede cambiar el color
# 15 - 20: son formas rellenas de color, por tanto se puede le puede cambiar el color
# 21 - 25: son formas con borde y relleno, y se les puede cambiar el color (borde) y el fill (relleno)

d = data.frame(p = c(0:25))
ggplot() +
  scale_y_continuous(name = "") +
  scale_x_continuous(name = "") +
  scale_shape_identity() +
  geom_point(data = d, mapping = aes(x = p%%16, y = p%/%16, shape = p, size = 5, fill = "red")) +
  geom_text(data = d, mapping = aes(x = p%%16, y = p%/%16+0.25, label = p), size = 3)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy),
             shape = 23,
             size = 10,
             color = "red",
             fill = "yellow")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy),
             shape = 23,
             size = 10,
             color = "red",
             fill = "yellow", stroke = 5)

# FACETS

# facet_wrap(~ <FORMULA_VARIABLE>): la variable debe de ser discreta
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 3)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ cty, nrow = 3)

# facet_grid(<FORMULA_VARIABLE1> ~ <FORMULA_VARIABLE2>)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)
  
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

  