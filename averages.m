% hard_soft_data = importdata('C:\\Users\\admin\\pacof\\data\\hard_soft_data.csv');
data = importdata('C:\\Users\\admin\\pacof\\data\\FB_modulation_code\\auto_gen_hard_soft_data_long.csv');
data(data == 999999) = NaN;

%%
% switches:
participants = 1:19; % 1:19 for all, 10:19 for blk condition, 1:18 for all except last participant

fprintf('condition delay 1 delay 2 delay 3')
for r=1:4
    fprintf('%d %.2f %.2f %.2f %.2f \n', ...
        r-1, ... 
        mean(data(participants,((r-1)*3)+r), 'omitnan')/1000, ...
        mean(data(participants,((r-1)*3)+r+1), 'omitnan')/1000, ...
        mean(data(participants,((r-1)*3)+r+2), 'omitnan')/1000, ...
        mean(data(participants,((r-1)*3)+r+3), 'omitnan')/1000);
end
