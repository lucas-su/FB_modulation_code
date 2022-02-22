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
library(naniar)
library(brms)
#library(calibrate)
data <- read_csv("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\auto_gen_hard_soft_data_long.csv", 
                 col_names = c("participant", "condition", "delay", "tot", "ncontacts"))

##
data <- data %>% replace_with_na(replace = list(tot = 999999))
data <- data %>% replace_with_na(replace = list(ncontacts = 999999))
data <- data %>% 
  mutate(tot_norm = tot/1000)



      #########################
      ###                   ###
      ###   Time on task    ###
      ###                   ###
      #########################

tot__RANDel_RANCondition <-  brm(tot_norm ~ (1|delay) +(1|condition),
                                       data = data,
                                 family=exgaussian(),
                                 control = list(adapt_delta = 0.99))

coefs_tot__RANDel_RANCondition = coef(posterior(tot__RANDel_RANCondition), interval=0.9)
coefs_tot__RANDel_RANCondition

coefs_norm_tot__RANDel_RANCondition_del <- 
  slice(dplyr::select(coefs_tot__RANDel_RANCondition, center, lower, upper), 6:9)+23.48 #(dplyr::select(coefs,center),1)

coefs_norm_tot__RANDel_RANCondition_del$labels_ = c("0ms", "150ms", "300ms", "black")

ggplot(coefs_norm_tot__RANDel_RANCondition_del, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_tot__RANDel_RANCondition_del$labels_)+
  scale_y_continuous("Time on Task")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_del.pdf")

coefs_norm_tot__RANDel_RANCondition_cond <- 
  slice(dplyr::select(coefs_tot__RANDel_RANCondition, center, lower, upper), 2:5)+ 23.48 #(dplyr::select(coefs,center),1)

coefs_norm_tot__RANDel_RANCondition_cond$labels_ = c("raw", "average", "low pass", "scale")

ggplot(coefs_norm_tot__RANDel_RANCondition_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_tot__RANDel_RANCondition_cond$labels_)+
  scale_y_continuous("Time on Task")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_cond.pdf")


      #####################
      ###               ###
      ###   ncontacts   ###
      ###               ###
      #####################

ncontacts__RANDel_RANCondition <-  brm(ncontacts ~ (1|delay) +(1|condition),
                                 data = data,
                                 family=poisson(),
                                 control = list(adapt_delta = 0.99))

coefs_ncontacts__RANDel_RANCondition = coef(posterior(ncontacts__RANDel_RANCondition), interval=0.9)
coefs_ncontacts__RANDel_RANCondition

coefs_norm_ncontacts__RANDel_RANCondition_del <- 
  slice(dplyr::select(coefs_ncontacts__RANDel_RANCondition, center, lower, upper), 6:9)+1.84 #(dplyr::select(coefs,center),1)

#coefs_norm_tot__RANDel_RANCondition_del <- 
#  slice(dplyr::select(coefs_tot__RANDel_RANCondition_del, center, lower, upper), 2:5)+ 24.08 #(dplyr::select(coefs,center),1)

coefs_norm_ncontacts__RANDel_RANCondition_del$labels_ = c("0ms", "150ms", "300ms", "black")

ggplot(coefs_norm_ncontacts__RANDel_RANCondition_del, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_ncontacts__RANDel_RANCondition_del$labels_)+
  scale_y_continuous("Number of contacts")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ncontacts__RANDel_RANCondition.pdf")




coefs_norm_nconctacts__RANDel_RANCondition_cond <- 
  slice(dplyr::select(coefs_ncontacts__RANDel_RANCondition, center, lower, upper), 2:5)+ 1.84 #(dplyr::select(coefs,center),1)

coefs_norm_nconctacts__RANDel_RANCondition_cond$labels_ = c("raw", "average", "low pass", "scale")

ggplot(coefs_norm_nconctacts__RANDel_RANCondition_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_nconctacts__RANDel_RANCondition_cond$labels_)+
  scale_y_continuous("Number of contacts")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_cond.pdf")


###################

ncontacts__RANDel_RANCondition <-  brm(ncontacts ~ (1|delay) +(1|condition),
                                       data = data,
                                       family=exgaussian(),
                                       control = list(adapt_delta = 0.99))

coefs_ncontacts__RANDel_RANCondition = coef(posterior(ncontacts__RANDel_RANCondition), interval=0.9)
coefs_ncontacts__RANDel_RANCondition

coefs_norm_ncontacts__RANDel_RANCondition_del <- 
  slice(dplyr::select(coefs_ncontacts__RANDel_RANCondition, center, lower, upper), 6:9)+2.03 #(dplyr::select(coefs,center),1)

#coefs_norm_tot__RANDel_RANCondition_del <- 
#  slice(dplyr::select(coefs_tot__RANDel_RANCondition_del, center, lower, upper), 2:5)+ 24.08 #(dplyr::select(coefs,center),1)

coefs_norm_ncontacts__RANDel_RANCondition_del$labels_ = c("0ms", "150ms", "300ms", "black")

ggplot(coefs_norm_ncontacts__RANDel_RANCondition_del, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_ncontacts__RANDel_RANCondition_del$labels_)+
  scale_y_continuous("Number of contacts")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ncontacts__RANDel_RANCondition.pdf")




coefs_norm_nconctacts__RANDel_RANCondition_cond <- 
  slice(dplyr::select(coefs_ncontacts__RANDel_RANCondition, center, lower, upper), 2:5)+ 1.84 #(dplyr::select(coefs,center),1)

coefs_norm_nconctacts__RANDel_RANCondition_cond$labels_ = c("raw", "average", "low pass", "scale")

ggplot(coefs_norm_nconctacts__RANDel_RANCondition_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_nconctacts__RANDel_RANCondition_cond$labels_)+
  scale_y_continuous("Number of contacts")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\ToT_RANDel_RANCondition_cond.pdf")
  