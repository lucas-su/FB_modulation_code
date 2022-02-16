clear all
close all
clc

%% import and plot data

A_ = importdata('/home/luc/Desktop/omega_calibrate_data.txt');
A = A_(30:end,:);
% A = A_(30:end/2,:);
f_ = importdata('/home/luc/Desktop/omega_calibrate_forcedata.txt');
f = f_(30:end);
% f = f_(30:end/2);
n = length(A);
Tc = 1/1000;
t = 0:Tc:n*Tc;
t = t';
t(end) = [];

Dx = A(:,2);
vx = -A(:,4);


%% identification

% no contact must be avoided by the calculation
% this is also done in the real implementation
STI = A(:,5);

for i = 1:n
    if f(i,1) <= 0.1
        STI(i,1) = 0;
        for j = 1:5
            A(i,j) = 0;
        end
    end
end

Con = pinv(A)*f;
k = Con(1,1).*STI + Con(2,1)*ones(n,1);
b = Con(3,1).*STI + Con(4,1)*ones(n,1);
gamma1 = Con(3,1)/Con(1,1);
gamma2 = Con(4,1)/Con(2,1); % correct gamma value
b1 = gamma1*k;
b2 = gamma2*k;


est_f = k.*A(:,2) + b.*A(:,4);
est_f1 = k.*A(:,2) + b1.*A(:,4);
est_f2 = k.*A(:,2) + b2.*A(:,4);

figure
subplot(2,1,1)
plot(t,f)
hold on
grid on
plot(t,est_f)
% plot(t,est_f1)
plot(t,est_f2)
legend("f","est f","est f2")
% subplot(2,1,2)
% plot(t,b)
% hold on
% grid on
% plot(t,b1)
% hold on
% plot(t,b2)
subplot(2,1,2)
plot(t,A(:,2))
legend("dx")

figure
plot(t, Dx.*k)
hold on
grid on
plot(t, vx.*b)
legend("dx", "vx")

alpha = Con(1,1)
beta = Con(2,1)
gamma = Con(4,1)/Con(2,1)
STI_max = 1
STI_min = 0
Td = 0
force_condition = 1


%% PRINT
fileID = fopen('/home/luc/catkin_ws/src/feedback_modulation/config/user_params.yaml','w');
fprintf(fileID,'"/user_vals/Alpha": %f\n"/user_vals/Beta": %f\n"/user_vals/Gamma": %f\n"/user_vals/STI_min": %f\n"/user_vals/STI_max": %f\n"/user_vals/Td": %f\n"/user_vals/force_condition": %f', alpha, beta, gamma, STI_min, STI_max, Td, force_condition);
fclose(fileID);

