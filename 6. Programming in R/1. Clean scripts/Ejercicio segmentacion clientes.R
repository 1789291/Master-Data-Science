library(tidyverse)

# Traemos el dataset

customers <- read_csv('http://archive.ics.uci.edu/ml/machine-learning-databases/00292/Wholesale%20customers%20data.csv')

head(customers)

# Cambiamos Channel y Region a factor

customers %>% 
  mutate(Channel = as.factor(Channel), Region = as.factor((Region)) )

# Si cada fila es un cliente, cuántos clientes tengo en cada canal? ¿Qué porcentaje?

customers %>% 
  group_by(Channel) %>% 
  summarise(n_clients = n()) 
  
table(customers$Channel)/nrow(customers)

# Miramos las correlaciones de un vistazo

library(GGally) 
ggpairs(customers)


install.packages('corrplot')
library(corrplot)


# Otra manera:
customers %>% 
  select(Fresh:Delicassen) %>% 
  cor() %>% 
  corrplot(method = 'number')

# Vamos a aplicar una técnica de clustering con KMeans

# En este caso no hace falta escalar las variable ya que todas están en dólares

# No obstante, lo haríamos así
customers_scaled <- customers %>% 
  select(Fresh:Delicassen) %>% 
  scale()

fit <- kmeans(customers_scaled, 3)
fit


customers <- customers %>% 
  mutate(cluster = as.factor(fit$cluster))

head(customers)  

# install.packages('ggfortify')
library(ggfortify)  
library(cluster)  
autoplot(fit, data = customers, frame = T, frame.type = 'norm')
