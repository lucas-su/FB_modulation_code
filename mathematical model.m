

alpha = -5.2024;
beta = -503.7880;

Tc = 1/1000;

% straightforward map

STI_map = 0:0.001:1;
STI_map = STI_map';

omega_map = (1/Tc)*log((alpha*STI_map + beta)/(alpha + beta));
% * exp(-100*Tc)

figure
plot(STI_map,omega_map)
grid on