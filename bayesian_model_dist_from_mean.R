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

##

dist_from_mean <- read_csv("C:\\Users\\admin\\Documents\\MATLAB\\feedback_modulation\\dist_from_mean.csv", 
                           col_names = c('part','dist','cond'))


## 
lm_P_C <-  stan_lmer(dist ~ 1 + (1|part) + (1|cond),
                      data = dist_from_mean )

coefs_P_C <- coef(posterior(lm_P_C), interval=0.9)

coefs_P_C

coefs_norm_P_C_part <- slice(dplyr::select(coefs_P_C, center, lower, upper), 2:20)+ 2.037 #(dplyr::select(coefs,center),1)
coefs_norm_P_C_cond <- slice(dplyr::select(coefs_P_C, center, lower, upper), 21:24)+ 2.037 #(dplyr::select(coefs,center),1)

ggplot(coefs_norm_P_C_part, aes(1:19, center)) +        # ggplot2 plot with 90% credibility limites
  geom_point() +
  scale_x_discrete("Condition",labels=c(3:21))+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))

ggplot(coefs_norm_P_C_cond, aes(1:4, center)) +        # ggplot2 plot with 90% credibility limites
  geom_point() +
  scale_x_discrete("Condition",labels=c('0'="raw", '1'="average", '2'="low pass", '3'="scale"))+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))


##

lm_C <-  stan_lmer(dist ~ 1+ (1|cond),
                      data = dist_from_mean )

coefs_C <- coef(posterior(lm_C), interval=0.9)

coefs_C

coefs_norm_C_cond <- slice(dplyr::select(coefs_C, center, lower, upper), 2:5)+ 1.98 #(dplyr::select(coefs,center),1)


ggplot(coefs_norm_C_cond, aes(c('0','1','2','3'), center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",labels=c('0'="raw", '1'="average", '2'="low pass", '3'="scale"))+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))



## without outliers (conclusions don't change)

dist_from_mean_outliers_removed <- subset(x= dist_from_mean,
                                          part != 9 &
                                            part != 14)


m_P_C_No_out <-  stan_lmer(dist ~ 1 + (1|part) + (1|cond),
                    data = dist_from_mean_outliers_removed  )

coefs_P_C_No_out <- coef(posterior(m_P_C_No_out), interval=0.9)

coefs_P_C_No_out

coefs_norm_P_C_No_out_part <- slice(dplyr::select(coefs_P_C_No_out, center, lower, upper), 2:18)+  1.7661906 #(dplyr::select(coefs,center),1)


ggplot(coefs_norm_P_C_No_out_part, aes(1:17, center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",labels=cat(c(3:10),c(12:15),c(17:21)))+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))


coefs_norm_P_C_No_out_cond <- slice(dplyr::select(coefs_P_C_No_out, center, lower, upper), 19:22)+  1.7661906 #(dplyr::select(coefs,center),1)

ggplot(coefs_norm_P_C_No_out_cond, aes(c('0','1','2','3'), center)) +        # ggplot2 plot with confidence intervals
  geom_point() +
  scale_x_discrete("Condition",labels=c('0'="raw", '1'="average", '2'="low pass", '3'="scale"))+
  scale_y_continuous("Deviation from mean")+  
  geom_errorbar(aes(ymin = lower, ymax = upper))
