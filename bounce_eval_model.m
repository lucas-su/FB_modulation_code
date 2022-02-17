clear all
close all
clc

diff.raw = [];
diff.av = [];
diff.low = [];
diff.sc = [];
writematrix([],'dist_from_mean_model.csv') % remake empty csv file

for part=1:19
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
    if i == 10 || i == 17 || i ==  19
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
    STI = A(:,3);
    force_condition = A(:,4);
    contact = A(:,5);
    count = A(:,6);
    cutoff_freq = A(:,7);
    target_hard_soft = A(:,8);
    recovered_last_contact = A(:,9);
    
    % remap contact to threshold == 1 N
    contact_shift = arrayfun(@(t){return_contact(t)}, force_sensor);
    contact_shift = vertcat(contact_shift{:});
    
    
    last_contact_i = -1;
    for i=1:length(t)
        if (last_contact_i == -1) && (contact_shift(i) == 1) % fix i for first contact of participant
            last_contact_i = i;
        end
        if contact_shift(i) == 1
            if t(i)-t(last_contact_i) < 0.4 % take out bumps from contacts
                contact_shift(last_contact_i:i)=1.;
            end
            last_contact_i = i;
        end   
    end
    
    
    last_contact_i = -1;
    mean_last_bounce = -1;
    discard_current = -1; % if recover flag is present during contact, discard entire contact
    bounce_cond = -1;
    ncontacts.raw = 0;
    ncontacts.av = 0;
    ncontacts.low = 0;
    ncontacts.sc = 0;

    
    for i=1:length(t)
        if (last_contact_i == -1) && (contact_shift(i) == 1) % fix i for first contact of participant
        last_contact_i = i;
        end
        
        if target_hard_soft(i) ==1
            if contact_shift(i) == 1
                if ~discard_current ==1
                    if contact_shift(i-1) == 0
                        start_contact = i;
                        bounce_cond = force_condition(i);
                        if force_condition(i) == 0
                                ncontacts.raw = ncontacts.raw +1;
                            elseif force_condition(i) == 2
                                ncontacts.av = ncontacts.av +1;
                            elseif force_condition(i) == 3
                                ncontacts.low = ncontacts.low +1;
                            elseif force_condition(i) == 4
                                ncontacts.sc = ncontacts.sc+1;
                        end
                    end
                    if i ~= length(contact_shift) %prevent out of bound index
                        if contact_shift(i+1) == 0
                            mean_last_bounce = mean(force_sensor(start_contact:i,1));
                            temp_array = arrayfun(@(m) {abs(mean_last_bounce-m)/1000}, force_mod(start_contact:i));
                            if bounce_cond == 0
                                diff.raw(part, ncontacts.raw)=sum(vertcat(temp_array{:}));
                            elseif bounce_cond == 2
                                diff.av(part, ncontacts.av)=sum(vertcat(temp_array{:}));
                            elseif bounce_cond == 3
                                diff.low(part, ncontacts.low)=sum(vertcat(temp_array{:}));
                            elseif bounce_cond == 4
                                diff.sc(part, ncontacts.sc)=sum(vertcat(temp_array{:}));
                            end
                        end
                    end
                    last_contact_i = i;
                end
            else % if contact == 0, discard current is reset to 0
                discard_current = 0;
            end
        end
        if recovered_last_contact(i) % delete last entry because it was too hard and robot stalled
            if ~any(recovered_last_contact(i-100:i-1)) % if recover was held for more than one clock cycle, only one entry should be deleted
                if bounce_cond == 0
                        diff.raw(part, ncontacts.raw) = 0;
                        ncontacts.raw = ncontacts.raw - 1;
                    elseif bounce_cond == 2
                        diff.av(part, ncontacts.av) = 0;
                        ncontacts.av = ncontacts.av - 1;
                    elseif bounce_cond == 3
                        diff.low(part, ncontacts.low) = 0;
                        ncontacts.low = ncontacts.low - 1;
                    elseif bounce_cond == 4
                        diff.sc(part, ncontacts.sc) = 0;
                        ncontacts.sc = ncontacts.sc - 1;
                end
            end
            if contact_shift(i) ==1
                discard_current = 1;
            end
        end
    end

    
    % boxplots
    
    b_raw = diff.raw(part,:);
    b_raw = b_raw(b_raw ~=0);
    for o = b_raw
        writematrix([part, o, 0], 'dist_from_mean_model.csv','WriteMode','append')
    end
    b_av = diff.av(part,:);
    b_av = b_av(b_av ~=0);
    for o = b_av
        writematrix([part, o, 1], 'dist_from_mean_model.csv','WriteMode','append')
    end
    b_low = diff.low(part,:);
    b_low = b_low(b_low ~=0);
    for o = b_low
        writematrix([part, o, 2], 'dist_from_mean_model.csv','WriteMode','append')
    end
    b_sc = diff.sc(part,:);
    b_sc = b_sc(b_sc ~=0);
    for o = b_sc
        writematrix([part, o, 3], 'dist_from_mean_model.csv','WriteMode','append')
    end

    boxplot([b_raw, ...
                b_av, ...
                b_low, ...
                b_sc], ...
            [ones(1,ncontacts.raw)*0, ...
                ones(1,ncontacts.av)*1, ...
                ones(1,ncontacts.low)*2, ...
                ones(1,ncontacts.sc)*3])
    saveas(gcf, strcat("C:\\Users\\admin\\pacof\\data\\matlab_figures\\boxplot_distance_from_mean_model_part_", string(part),".pdf"))
end

%% plots
% figure 
% hold on
% plot(t, contact_shift)
% plot(t, force_sensor)

%% export





%%
function y = return_contact(x)
    if x > 1
        y = 1.0;
    else 
        y = 0.0;
    end
end

%%

