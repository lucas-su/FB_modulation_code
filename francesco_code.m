%% SET-UP
clear all
close all
clc

%% IMPORT DATA

Tc = 1/1000;
FMD = [];
for i = 3:13
    filename = sprintf('participant%d/feedback_modulation_data.txt',i);
    FMD_ = importdata(filename);

    t = FMD_(:,6); % counter
    [~, tmax_index] = max(t);
    t(tmax_index:length(t)) = [];
    t = t*Tc;
    tend = t(end);

    FMD_(tmax_index:length(FMD_),:) = [];

    FMD = [FMD; FMD_];

    clear t tmax_index tend;

end


%%

fX = FMD(:,1);
fXmod = FMD(:,2);
EMG = FMD(:,3);
cF = FMD(:,4); % condition force
cC = FMD(:,5); % flag contact
freq = FMD(:,7);
cHS = FMD(:,8); % condition hard soft
flag_rec = FMD(:,9); % recovery

for i = 1:length(cC)
    if fXmod(i,1) < 2 % threshold
        cC(i,1) = 0;
    end
end


%% sort by condition - HARD CONTACT
% 0 raw sensor
% 1 Kalman - not used
% 2 Average
% 3 LPF
% 4 Scale

fX_raw = fX(cF == 0 & cHS == 1);
fXmod_raw = fXmod(cF == 0 & cHS == 1);
cC_raw = cC(cF == 0 & cHS == 1);
traw = (0:length(fX_raw))*Tc;
traw(end) = [];

fX_Av = fX(cF == 2 & cHS == 1);
fXmod_Av = fXmod(cF == 2 & cHS == 1);
cC_Av = cC(cF == 2 & cHS == 1);
tAv = (0:length(fX_Av))*Tc;
tAv(end) = [];

fX_LPF = fX(cF == 3 & cHS == 1);
fXmod_LPF = fXmod(cF == 3 & cHS == 1);
cC_LPF = cC(cF == 3 & cHS == 1);
tLPF = (0:length(fX_LPF))*Tc;
tLPF(end) = [];

fX_Sc = fX(cF == 4 & cHS == 1);
fXmod_Sc = fXmod(cF == 4 & cHS == 1);
cC_Sc = cC(cF == 4 & cHS == 1);
tSc = (0:length(fX_Sc))*Tc;
tSc(end) = [];

figure

subplot(4,1,1)
plot(traw, fX_raw)
hold on
grid on
plot(traw, fXmod_raw)
plot(traw, cC_raw)
axis([0 traw(end) -1 11])

subplot(4,1,2)
plot(tAv, fX_Av)
hold on
grid on
plot(tAv, fXmod_Av)
plot(tAv, cC_Av)
axis([0 tAv(end) -1 11])

subplot(4,1,3)
plot(tSc, fX_Sc)
hold on
grid on
plot(tSc, fXmod_Sc)
plot(tSc, cC_Sc)
axis([0 tSc(end) -1 11])

subplot(4,1,4)
plot(tLPF, fX_LPF)
hold on
grid on
plot(tLPF, fXmod_LPF)
plot(tLPF, cC_LPF)
axis([0 tLPF(end) -1 11])

%% trial

% raw signal
k = 1;
q = 1;
sumfX_raw = 0;
area = 0;
for i = 2:length(cC_raw)
    
    if cC_raw(i,1) == 1 % contact
        sumfX_raw = sumfX_raw + fX_raw(i,1);
        area = area + 1; % samples in the integral
        temp_raw(q,1) = fX_raw(i,1)/10;
        q = q+1;
    end

    if (cC_raw(i,1) == 0 && cC_raw(i-1,1) == 1) % fill integral and reset
        int_fX_raw(k,1) = sumfX_raw*Tc/(area*Tc);
        sumfX_raw = 0;
        area = 0;

        % compute skewness and reset
        skew_fX_raw(k,1) = skewness(temp_raw);
        temp_raw = [];
        q = 1;

        k = k+1;
    end

end


% Av
k = 1;
sumfX_Av = 0;
area = 0;
for i = 2:length(cC_Av)
    
    if cC_Av(i,1) == 1 % contact
        sumfX_Av = sumfX_Av + fX_Av(i,1);
        area = area + 1; % samples in the integral
        temp_Av(q,1) = fX_Av(i,1)/10;
        q = q+1;
    end

    if (cC_Av(i,1) == 0 && cC_Av(i-1,1) == 1) % fill integral and reset
        int_fX_Av(k,1) = sumfX_Av*Tc/(area*Tc);
        sumfX_Av = 0;
        area = 0;

        % compute skewness and reset
        skew_fX_Av(k,1) = skewness(temp_Av);
        temp_Av = [];
        q = 1;

        k = k+1;
    end

end


% Sc
k = 1;
q = 1;
sumfX_Sc = 0;
area = 0;
for i = 2:length(cC_Sc)
    
    if cC_Sc(i,1) == 1 % contact
        sumfX_Sc = sumfX_Sc + fX_Sc(i,1);
        area = area + 1; % samples in the integral
        temp_Sc(q,1) = fX_Sc(i,1)/10;
        q = q+1;
    end

    if (cC_Sc(i,1) == 0 && cC_Sc(i-1,1) == 1) % fill integral and reset
        int_fX_Sc(k,1) = sumfX_Sc*Tc/(area*Tc);
        sumfX_Sc = 0;
        area = 0;

        % compute skewness and reset
        skew_fX_Sc(k,1) = skewness(temp_Sc);
        temp_Sc = [];
        q = 1;

        k = k+1;
    end

end


% LPF
k = 1;
q = 1;
sumfX_LPF = 0;
area = 0;
for i = 2:length(cC_LPF)
    
    if cC_LPF(i,1) == 1 % contact
        sumfX_LPF = sumfX_LPF + fX_LPF(i,1);
        area = area + 1; % samples in the integral
        temp_LPF(q,1) = fX_LPF(i,1)/10;
        q = q+1;
    end

    if (cC_LPF(i,1) == 0 && cC_LPF(i-1,1) == 1) % fill integral and reset
        int_fX_LPF(k,1) = sumfX_LPF*Tc/(area*Tc);
        sumfX_LPF = 0;
        area = 0;

        % compute skewness and reset
        skew_fX_LPF(k,1) = skewness(temp_LPF);
        temp_LPF = [];
        q = 1;

        k = k+1;
    end

end


figure
subplot(4,1,1)
plot(int_fX_raw)
grid on
subplot(4,1,2)
plot(int_fX_Av)
grid on
subplot(4,1,3)
plot(int_fX_Sc)
grid on
subplot(4,1,4)
plot(int_fX_LPF)
grid on


%% MEAN & SD

mean_raw = mean(int_fX_raw);
std_raw = std(int_fX_raw);
var_raw = var(int_fX_raw);

mean_Av = mean(int_fX_Av);
std_Av = std(int_fX_Av);
var_Av = var(int_fX_Av);

mean_Sc = mean(int_fX_Sc);
std_Sc = std(int_fX_Sc);
var_Sc = var(int_fX_Sc);

mean_LPF = mean(int_fX_LPF);
std_LPF = std(int_fX_LPF);
var_LPF = var(int_fX_LPF);

int_data = [int_fX_raw; int_fX_Av; int_fX_Sc; int_fX_LPF];
group = [    ones(size(int_fX_raw));
         2 * ones(size(int_fX_Av));
         3 * ones(size(int_fX_Sc))
         4 * ones(size(int_fX_LPF))];
figure
boxplot(int_data, group)
set(gca,'XTickLabel',{'raw','Av','Sc','LPF'})


% skewness
int_data = [skew_fX_raw; skew_fX_Av; skew_fX_Sc; skew_fX_LPF];
group = [    ones(size(skew_fX_raw));
         2 * ones(size(skew_fX_Av));
         3 * ones(size(skew_fX_Sc))
         4 * ones(size(skew_fX_LPF))];
figure
boxplot(int_data, group)
set(gca,'XTickLabel',{'raw','Av','Sc','LPF'})


%%
% normalize data
% compute skewness for each contact
% in out case should be lower

% check for normal distribution on skewness