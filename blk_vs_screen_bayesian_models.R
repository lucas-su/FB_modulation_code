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
#library(calibrate)
data <- read_csv("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\auto_gen_hard_soft_data_long.csv", 
                 col_names = c("participant", "condition", "delay", "tot", "ncontacts"))

##
data <- data %>% replace_with_na(replace = list(tot = 999999))
data <- data %>% replace_with_na(replace = list(ncontacts = 999999))
data <- data %>% 
  mutate(tot_norm = tot/1000)



tot__del_RANCondition <-  stan_lmer(tot_norm ~ delay + (1|condition),
           data = data  )

coefs_tot__del_RANCondition = coef(posterior(tot__del_RANCondition), interval=0.9)

coefs_norm_tot__del_RANCondition = slice(dplyr::select(coefs_tot__RANDel_RANCondition_del, center, lower, upper), 2:6)+ 19.04 #(dplyr::select(coefs,center),1)

coefs_norm_tot__del_RANCondition$labels_ = c("delay", "raw", "average", "low pass", "scale")

ggplot(coefs_norm_tot__del_RANCondition, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Effects",limits=coefs_norm_tot__del_RANCondition$labels_)+
  scale_y_continuous("Time on Task")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))


##
tot__RANDel_RANCondition <-  stan_lmer(tot_norm ~ (1|delay) +(1|condition),
                                   data = data  )
coefs_tot__RANDel_RANCondition_del = coef(posterior(tot__RANDel_RANCondition), interval=0.9)

coefs_norm_tot__RANDel_RANCondition_del <- 
  slice(dplyr::select(coefs_tot__RANDel_RANCondition_del, center, lower, upper), 2:5)+ 24.08 #(dplyr::select(coefs,center),1)

coefs_norm_tot__RANDel_RANCondition_del$labels_ = c("0ms", "150ms", "300ms", "black")

ggplot(coefs_norm_tot__RANDel_RANCondition_del, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_tot__RANDel_RANCondition_del$labels_)+
  scale_y_continuous("Time on Task")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))


coefs_norm_tot__RANDel_RANCondition_cond <- 
  slice(dplyr::select(coefs_tot__RANDel_RANCondition_del, center, lower, upper), 6:9)+ 24.08 #(dplyr::select(coefs,center),1)

coefs_norm_tot__RANDel_RANCondition_cond$labels_ = c("raw", "average", "low pass", "scale")

ggplot(coefs_norm_tot__RANDel_RANCondition_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_tot__RANDel_RANCondition_cond$labels_)+
  scale_y_continuous("Time on Task")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))


##
tot__delRANCondition <-  stan_lmer(tot_norm ~ (delay|condition),
                      data = data  )
coef(posterior(tot__delRANCondition), interval=0.9)


##
tot__RANdel <-  stan_lmer(tot_norm ~ (1|delay),
                                   data = data  )
coef(posterior(tot__RANdel), interval=0.9)



##
tot__RANParticipant_RANCondition <-  stan_lmer(tot_norm ~ delay + (1|participant) + (1|condition),
                      data = data  )

coefs <- coef(posterior(tot__RANParticipant_RANCondition), interval=0.9)

coefs

shifted_coefs <- slice(dplyr::select(coefs, center, lower, upper), 2:5)+ 24.0204422 #(dplyr::select(coefs,center),1)


ggplot(shifted_coefs, aes(c('0','1','2','3'), center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",labels=c('0'="raw", '1'="average", '2'="low pass", '3'="scale"))+
  scale_y_continuous("Time on Task")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))





/
  