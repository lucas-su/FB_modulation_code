hard_soft_data_long = importdata('C:\\Users\\admin\\pacof\\data\\hard_soft_data_long.csv');
data = hard_soft_data_long.data;
data(:,4) = data(:,4)/1000;

participants = 1;
condition = 2;
delay = 3;
tot = 4;
contacts = 5;

raw = 0;
average = 1;
low_pass = 2;
scale = 3;

pps = 1:19;

%%

lm = fitlme(array2table(data,  'VariableNames',{'participants','condition','delay','tot', 'contacts'}), "tot~delay+(delay|condition)")

