for part=14
    force_sensor = zeros(19,3000000);
    force_mod = zeros(19,3000000);
    STI = zeros(19,3000000);
    force_condition = zeros(19,3000000);
    contact = zeros(19,3000000);
    count = zeros(19,3000000);
    cutoff_freq = zeros(19,3000000);
    target_hard_soft = zeros(19,3000000);
    recovered_last_contact = zeros(19,3000000);
    
    
    A = importdata(strcat('C:\Users\admin\pacof\data\data\participant',{' '},string(part+2),'\feedback_modulation_data.txt'));
    if part == 10 || part == 17 || part ==  19
        A2 = importdata(strcat('C:\Users\admin\pacof\data\data\participant',{' '},string(part+2),'\feedback_modulation_data_2.txt'));
    %         A = A_(A_(:,4) ~= 0,:);
    else 
        A2 = zeros(size(A));
    end
    A2(:,6) = A2(:,6)+1500000;  
    A = cat(1,A,A2);        
    
    n = length(A);
    t = 0:1/1000:n/1000;
    t = t'; % transpose
    t(end) = [];
    
    
    force_sensor = A(:,1);
    force_mod = A(:,2);
%     STI = A(:,3);
    force_condition = A(:,4);
%     contact = A(:,5);
%     count = A(:,6);
%     cutoff_freq = A(:,7);
%     target_hard_soft = A(:,8);
%     recovered_last_contact = A(:,9);
    
    % remap contact to threshold == 1 N
%     contact_shift = arrayfun(@(t){return_contact(t)}, force_sensor);
%     contact_shift = vertcat(contact_shift{:});
    figure 
    hold on
    grid on 
    plot(t, force_sensor, 'LineWidth',1)
    xlabel('Time (s)') 
    ylabel('Force (N)') 
    plot(t, force_mod, 'LineWidth',1)
end

function y = return_contact(x)
    if x > 1
        y = 1.0;
    else 
        y = 0.0;
    end
end
