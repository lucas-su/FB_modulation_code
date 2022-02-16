
clear all
clc

%% GRIDCHECK

A = importdata('/home/luc/Desktop/test_acq/claibrate_data_gridcheck.txt');
B = zeros(2,2,4);
n = 1:10;
for i = 1:3
    for j = 1:3
        for k = 1:10
            B(i,j,k) = A( k + 10*(j-1) + 10*3*(i-1));
        end
    end
end

B_STI_LOW = zeros(3,10);
for i = 1:3
    for j = 1:10
        B_STI_LOW(i,j) = B(i,1,j);
    end
end

B_STI_MID = zeros(3,10);
for i = 1:3
    for j = 1:10
        B_STI_MID(i,j) = B(i,2,j);
    end
end

B_STI_HIGH = zeros(3,10);
for i = 1:3
    for j = 1:10
        B_STI_HIGH(i,j) = B(i,3,j);
    end
end


B_STI_LOW

B_STI_MID

B_STI_HIGH

%% plot

% STI LOW

figure
subplot(3,1,1)
plot(B_STI_LOW(1,:));
hold on
grid on
plot(B_STI_LOW(2,:));
plot(B_STI_LOW(3,:));
a = polyfit(n,B_STI_LOW(1,:),1);
plot(a(1)*n + a(2));
a = polyfit(n,B_STI_LOW(2,:),1);
plot(a(1)*n + a(2));
a = polyfit(n,B_STI_LOW(3,:),1);
plot(a(1)*n + a(2));
legend('3N','6N','9N', '3N_avg','6N_avg','9N_avg')

subplot(3,1,2)
plot(B_STI_MID(1,:));
hold on
grid on
plot(B_STI_MID(2,:));
plot(B_STI_MID(3,:));
a = polyfit(n,B_STI_MID(1,:),1);
plot(a(1)*n + a(2));
a = polyfit(n,B_STI_MID(2,:),1);
plot(a(1)*n + a(2));
a = polyfit(n,B_STI_MID(3,:),1);
plot(a(1)*n + a(2));
legend('3N','6N','9N', '3N_avg','6N_avg','9N_avg')

subplot(3,1,3)
plot(B_STI_HIGH(1,:));
hold on
grid on
plot(B_STI_HIGH(2,:));
plot(B_STI_HIGH(3,:));
a = polyfit(n,B_STI_HIGH(1,:),1);
plot(a(1)*n + a(2));
a = polyfit(n,B_STI_HIGH(2,:),1);
plot(a(1)*n + a(2));
a = polyfit(n,B_STI_HIGH(3,:),1);
plot(a(1)*n + a(2));
legend('3N','6N','9N', '3N_avg','6N_avg','9N_avg')


%% doing everything on force condition


f_3 = zeros(3,10);
for i = 1:3
    for j = 1:10
        f_3(i,j) = B(1,i,j);
    end
end
f_3l = f_3(1,:);
a = polyfit(n,f_3l,1);
F_3l = a(1)*n + a(2);
f_3m = f_3(2,:);
a = polyfit(n,f_3m,1);
F_3m = a(1)*n + a(2);
f_3h = f_3(3,:);
a = polyfit(n,f_3h,1);
F_3h = a(1)*n + a(2);

f_6 = zeros(3,10);
for i = 1:3
    for j = 1:10
        f_6(i,j) = B(2,i,j);
    end
end
f_6l = f_6(1,:);
a = polyfit(n,f_6l,1);
F_6l = a(1)*n + a(2);
f_6m = f_6(2,:);
a = polyfit(n,f_6m,1);
F_6m = a(1)*n + a(2);
f_6h = f_6(3,:);
a = polyfit(n,f_6h,1);
F_6h = a(1)*n + a(2);

f_9 = zeros(3,10);
for i = 1:3
    for j = 1:10
        f_9(i,j) = B(3,i,j);
    end
end
f_9l = f_9(1,:);
a = polyfit(n,f_9l,1);
F_9l = a(1)*n + a(2);
f_9m = f_9(2,:);
a = polyfit(n,f_9m,1);
F_9m = a(1)*n + a(2);
f_9h = f_9(3,:);
a = polyfit(n,f_9h,1);
F_9h = a(1)*n + a(2);

%% plot

figure
subplot(3,1,1)
% plot(f_3(1,:));
hold on
grid on
% plot(f_3(2,:));
% plot(f_3(3,:));
plot(F_3l);
plot(F_3m);
plot(F_3h);
legend('low','mid','high')

subplot(3,1,2)
% plot(f_6(1,:));
hold on
grid on
% plot(f_6(2,:));
% plot(f_6(3,:));
plot(F_6l);
plot(F_6m);
plot(F_6h);
legend('low','mid','high')

subplot(3,1,3)
% plot(f_9(1,:));
hold on
grid on
% plot(f_9(2,:));
% plot(f_9(3,:));
plot(F_9l);
plot(F_9m);
plot(F_9h);
legend('low','mid','high')
