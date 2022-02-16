hard_soft_data = importdata('C:\\Users\\admin\\pacof\\data\\hard_soft_data.csv');


figure
hold on 
for k=1:19
    subplot(7,3,k);
    
    for i=1:4
    hold on 
    plot([1,2,3,4],[hard_soft_data(k,((i-1)*3)+i)/1000, ...
        hard_soft_data(k,((i-1)*3)+i+1)/1000, ...
        hard_soft_data(k,((i-1)*3)+i+2)/1000, ...
        hard_soft_data(k,((i-1)*3)+i+3)/1000]);
    ylim([0, 150])
    xlim([1,4])
    xticks([1,2,3,4])
    end
end

figure
hold on 
for k=1:19
    subplot(7,3,k);
    
    for i=1:4
    hold on 
    plot([1,2,3,4],[hard_soft_data(k,((i-1)*3)+i+16), ...
        hard_soft_data(k,((i-1)*3)+i+17), ...
        hard_soft_data(k,((i-1)*3)+i+18), ...
        hard_soft_data(k,((i-1)*3)+i+19)]);
    ylim([0, 20])
    xlim([1,4])
    xticks([1,2,3,4])
    end
end
