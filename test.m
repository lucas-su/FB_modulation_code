hard_soft_data_long = importdata('C:\\Users\\admin\\pacof\\data\\hard_soft_data_long.csv');
data = hard_soft_data_long.data;
headers = hard_soft_data_long.colheaders;



xy = data(data(:,1)==2, data(:,3)==1, [2 3]);

%%
figure
hold on 
means = [];
for i=1:19
    means(end+1) = mean(diff.raw(i));
end
plot(means, '.')
means = [];
for i=1:19
    means(end+1) = mean(diff.av(i));
end
plot(means, '.')
means = [];
for i=1:19
    means(end+1) = mean(diff.low(i));
end
plot(means, '.')
means = [];
for i=1:19
    means(end+1) = mean(diff.sc(i));
end
plot(means, '.')
legend('raw', 'av', 'low', 'sc')
