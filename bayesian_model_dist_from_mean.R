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
##

dist_from_mean <- read_csv("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dist_from_mean_model.csv", 
                           col_names = c('part','dist','cond', 'del', 'force'))
dist_from_mean$round_force = round(dist_from_mean$force)


lm_P_C_D <-  brm(dist ~ (1|part) + (1|cond) + (1|del),
               data = dist_from_mean,
               family = exponential(),
               control = list(adapt_delta = 0.99))

coefs_P_C_D <- coef(posterior(lm_P_C_D), interval=0.9, mean.func = exp)

coefs_P_C_D

coefs_norm_P_C_D_part <- slice(dplyr::select(coefs_P_C_D, center, lower, upper), 10:29)+  1.61 #(dplyr::select(coefs,center),1)
coefs_norm_P_C_D_cond <- slice(dplyr::select(coefs_P_C_D, center, lower, upper), 2:5)+  1.61 #(dplyr::select(coefs,center),1)
coefs_norm_P_C_D_del <- slice(dplyr::select(coefs_P_C_D, center, lower, upper), 6:9)+  1.61 #(dplyr::select(coefs,center),1)


coefs_norm_P_C_D_cond$labels_ = c("raw", "average", "low pass", "scale")
coefs_norm_P_C_D_part$labels_ <- as.character(c(3:21))
coefs_norm_P_C_D_del$labels_ <- c("0ms", "150ms", "300ms", "No visual")


ggplot(coefs_norm_P_C_D_part, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  scale_x_discrete("Participant", limits=coefs_norm_P_C_D_part$labels_)+
  scale_y_continuous("Deviation from mean")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_D_part_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_D_part_large.pdf",
       width = 4.9, height = 3.3, units = "in")

ggplot(coefs_norm_P_C_D_cond, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  scale_x_discrete("Condition", limits = coefs_norm_P_C_D_cond$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_D_cond_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_D_cond_large.pdf",
       width = 4.9, height = 3.3, units = "in")

ggplot(coefs_norm_P_C_D_del, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  scale_x_discrete("Delay condition", limits = coefs_norm_P_C_D_del$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_D_del_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_D_del_large.pdf",
       width = 4.9, height = 3.3, units = "in")

## 


lm_RANPart_forceRANDel_RANCond <-  brm(dist ~ (1|part) + (force|del) +  (1|cond), 
                                          data = dist_from_mean,
                                          family = exponential(),
                                          control = list(adapt_delta = 0.99),
                                          cores = 4, backend = "cmdstanr", threads = threading(4))

coefs_RANPart_forceRANDel_RANCond <- coef(posterior(lm_RANPart_forceRANDel_RANCond), interval=0.9, mean.func = exp)

coefs_RANPart_forceRANDel_RANCond$n = c(1:40)

coefs_RANPart_forceRANDel_RANCond

###
coefs_norm_RANPart_forceRANDel_RANCond_part <- slice(dplyr::select(coefs_RANPart_forceRANDel_RANCond, center, lower, upper), 
                                                        22:40)+  coefs_RANPart_forceRANDel_RANCond$center[1]
coefs_norm_RANPart_forceRANDel_RANCond_part$labels_ <- as.character(c(3:21))
##
coefs_norm_RANPart_forceRANDel_RANCond_cond <- slice(dplyr::select(coefs_RANPart_forceRANDel_RANCond, center, lower, upper), 
                                                        2:5)+  coefs_RANPart_forceRANDel_RANCond$center[1]
coefs_norm_RANPart_forceRANDel_RANCond_cond$labels_ = c("raw", "average", "low pass", "scale")
##
coefs_norm_RANPart_forceRANDel_RANCond_del<- slice(dplyr::select(coefs_RANPart_forceRANDel_RANCond, center, lower, upper), 
                                                           14:17) + coefs_RANPart_forceRANDel_RANCond$center[1]
coefs_norm_RANPart_forceRANDel_RANCond_del$labels_ = c("0ms", "150ms", "300ms", "No visual")
##
coefs_norm_RANPart_forceRANDel_RANCond_del_f<- slice(dplyr::select(coefs_RANPart_forceRANDel_RANCond, center, lower, upper), 
                                                      18:21) + coefs_RANPart_forceRANDel_RANCond$center[1]
coefs_norm_RANPart_forceRANDel_RANCond_del_f$labels_ = c("0ms", "150ms", "300ms", "No visual")
###



ggplot(coefs_norm_RANPart_forceRANDel_RANCond_part, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  scale_x_discrete("Participant", limits=coefs_norm_RANPart_forceRANDel_RANCond_part$labels_)+
  scale_y_continuous("Deviation from mean")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_part_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_part_large.pdf",
       width = 4.9, height = 3.3, units = "in")

ggplot(coefs_norm_RANPart_forceRANDel_RANCond_cond, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  scale_x_discrete("Condition", limits = coefs_norm_RANPart_forceRANDel_RANCond_cond$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_cond_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_cond_large.pdf",
       width = 4.9, height = 3.3, units = "in")

ggplot(coefs_norm_RANPart_forceRANDel_RANCond_del, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  scale_x_discrete("Delay condition", limits=coefs_norm_RANPart_forceRANDel_RANCond_del$labels_)+
  scale_y_continuous("Deviation from mean")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_del_small.pdf",
       width = 2.8, height = 1.9, units = "in")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_RANPart_forceRANDel_RANCond_del_large.pdf",
       width = 4.9, height = 3.3, units = "in")



ggplot(coefs_norm_RANPart_forceRANDel_RANCond_del_f, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  scale_x_discrete("Condition", limits=coefs_norm_RANPart_forceRANDel_RANCond_del_f$labels_)+
  scale_y_continuous("Deviation from mean")











##


lm_test <-  brm(dist ~  (1|cond/part),
               data = dist_from_mean,
               family = exponential(),
               control = list(adapt_delta = 0.99))

coefs_P_C <- coef(posterior(lm_test), interval=0.9)
coefs_P_C$n = c(1:81)
coefs_P_C$cond = c(1:81)
coefs_P_C$part = c(1:81)

coefs_P_C

coefs_norm_P_C_part <- slice(dplyr::select(coefs_P_C, center, lower, upper), 6:25)+  0.75 #(dplyr::select(coefs,center),1)
coefs_norm_P_C_cond <- slice(dplyr::select(coefs_P_C, center, lower, upper), 2:5)+  0.75 #(dplyr::select(coefs,center),1)

coefs_norm_P_C_cond$labels_ = c("raw", "average", "low pass", "scale")
coefs_norm_P_C_part$labels_ <- as.character(c(3:21))



ggplot(coefs_norm_P_C_part, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  geom_errorbar(aes(ymin = lower, ymax = upper))+
  scale_x_discrete("Participant", limits=coefs_norm_P_C_part$labels_)+
  scale_y_continuous("Deviation from mean")
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_part.pdf")

ggplot(coefs_norm_P_C_cond, aes(labels_, center)) +        # ggplot2 plot with 90% credibility limits
  geom_point() +
  scale_x_discrete("Condition", limits = coefs_norm_P_C_cond$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_cond.pdf")








##

lm_C <-  brm(dist ~ 1+ (1|cond),
             data = dist_from_mean,
             family = exponential(),
             control = list(adapt_delta = 0.99))

coefs_C <- coef(posterior(lm_C), interval=0.9)

coefs_C

coefs_norm_C_cond <- slice(dplyr::select(coefs_C, center, lower, upper), 2:5)+ 0.56 #(dplyr::select(coefs,center),1)

coefs_norm_C_cond$labels_ = c("raw", "average", "low pass", "scale")

ggplot(coefs_norm_C_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_C_cond$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean__model_C_cond.pdf")


## without outliers (conclusions don't change)

dist_from_mean_outliers_removed <- subset(x= dist_from_mean,
                                          part != 9 &
                                            part != 14)

m_P_C_No_out <-  brm(dist ~ 1 + (1|part) + (1|cond),
                    data = dist_from_mean_outliers_removed,
                    family = exponential(),
                    control = list(adapt_delta = 0.99))

coefs_P_C_No_out <- coef(posterior(m_P_C_No_out), interval=0.9)

coefs_P_C_No_out

coefs_norm_P_C_No_out_part <- slice(dplyr::select(coefs_P_C_No_out, center, lower, upper), 6:23)+  0.38 #(dplyr::select(coefs,center),1)
coefs_norm_P_C_No_out_part$labels_ = as.character(c(3,4,5,6,7,8,9,10,12,13,14,15,17,18,19,20,21))

ggplot(coefs_norm_P_C_No_out_part, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",labels=coefs_norm_P_C_No_out_part$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_No_out_part.pdf")

coefs_norm_P_C_No_out_cond <- slice(dplyr::select(coefs_P_C_No_out, center, lower, upper), 2:5)+  0.38 #(dplyr::select(coefs,center),1)

coefs_norm_P_C_No_out_cond$labels_=c("raw", "average", "low pass", "scale")

ggplot(coefs_norm_P_C_No_out_cond, aes(labels_, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",limits=coefs_norm_P_C_No_out_cond$labels_)+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
ggsave("C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\dev_from_mean_model_P_C_No_out_cond.pdf")
