library(readr)
library(dplyr)
library(tidyverse)
library(rstanarm)
library(mascutils)
library(gridExtra)
library(devtools)
library(knitr)
library(mascutils)
library(bayr)
library(brms)
library(ggplot2)
##

dist_from_mean <- read_csv("C:\\Users\\admin\\pacof\\data\\Feedback Modulation\\FB_modulation_code\\dist_from_mean_model.csv", 
                           col_names = c('part','dist','cond', 'del', 'force'))

lm_RANPart_forceRANDel_RANCond <-  brm(dist ~ (1|part) + (force|del) + (1|cond), 
                                          data = dist_from_mean,
                                          family = exponential(),
                                          control = list(adapt_delta = 0.99),
                                          cores = 4, backend = "cmdstanr", threads = threading(4))

## coefs
coefs_RANPart_forceRANDel_RANCond <- coef(posterior(lm_RANPart_forceRANDel_RANCond), interval=0.9, mean.func = exp)

coefs_RANPart_forceRANDel_RANCond$n = c(1:40)

coefs_RANPart_forceRANDel_RANCond

## coefs norm participants
coefs_norm_RANPart_forceRANDel_RANCond_part <- slice(dplyr::select(coefs_RANPart_forceRANDel_RANCond, center, lower, upper), 
                                                        22:40)+  coefs_RANPart_forceRANDel_RANCond$center[1]
coefs_norm_RANPart_forceRANDel_RANCond_part$labels_ <- as.character(c(3:21))

## coefs norm modulation condition
coefs_norm_RANPart_forceRANDel_RANCond_cond <- slice(dplyr::select(coefs_RANPart_forceRANDel_RANCond, center, lower, upper), 
                                                        2:5)+  coefs_RANPart_forceRANDel_RANCond$center[1]
coefs_norm_RANPart_forceRANDel_RANCond_cond$labels_ = c("raw", "average", "low pass", "scale")

## coefs norm delay condition
coefs_norm_RANPart_forceRANDel_RANCond_del<- slice(dplyr::select(coefs_RANPart_forceRANDel_RANCond, center, lower, upper), 
                                                           14:17) + coefs_RANPart_forceRANDel_RANCond$center[1]
coefs_norm_RANPart_forceRANDel_RANCond_del$labels_ = c("0ms", "150ms", "300ms", "No visual")

## coefs norm force by delay 
coefs_norm_RANPart_forceRANDel_RANCond_del_f<- slice(dplyr::select(coefs_RANPart_forceRANDel_RANCond, center, lower, upper), 
                                                      18:21) + coefs_RANPart_forceRANDel_RANCond$center[1]
coefs_norm_RANPart_forceRANDel_RANCond_del_f$labels_ = c("0ms", "150ms", "300ms", "No visual")


## plot participant
ggplot(coefs_norm_RANPart_forceRANDel_RANCond_part, aes(labels_, center)) +        
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  scale_x_discrete("Participant", limits=coefs_norm_RANPart_forceRANDel_RANCond_part$labels_)+
  scale_y_continuous("Deviation from mean")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_part_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_part_large.pdf",
       width = 4.9, height = 3.3, units = "in")

## plot condition
ggplot(coefs_norm_RANPart_forceRANDel_RANCond_cond, aes(labels_, center)) +        
  geom_point() +
  scale_x_discrete("Condition", limits = coefs_norm_RANPart_forceRANDel_RANCond_cond$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_cond_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_cond_large.pdf",
       width = 4.9, height = 3.3, units = "in")

## plot delay condition 
ggplot(coefs_norm_RANPart_forceRANDel_RANCond_del, aes(labels_, center)) +        
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  scale_x_discrete("Delay condition", limits=coefs_norm_RANPart_forceRANDel_RANCond_del$labels_)+
  scale_y_continuous("Deviation from mean")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_del_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_del_large.pdf",
       width = 4.9, height = 3.3, units = "in")


## plot force by delay
ggplot(coefs_norm_RANPart_forceRANDel_RANCond_del_f, aes(labels_, center)) +        
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  scale_x_discrete("Force per delay condition", limits=coefs_norm_RANPart_forceRANDel_RANCond_del_f$labels_)+
  scale_y_continuous("Deviation from mean")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_del_f_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_del_f_large.pdf",
       width = 4.9, height = 3.3, units = "in")

