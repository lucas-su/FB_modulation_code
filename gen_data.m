
clear all
close all
clc

%%

writematrix([], "auto_gen_hard_soft_data_long.csv")


hard_soft_time = [504000, 880000; ...
780000,1228600; ...
392000,750000; ...
600000,1170000; ...
725000,1080000; ...
495000,900000; ...
440000,850000; ...
500000,820000; ...
680000,1180000; ...
460000,1650000; ...
470000,900000; ...
435000,1050000; ...
400000,950000; ...
645000,1360000; ...
498000,1400000; ...
465000,1150000; ...
1530000,2380000; ...
720000,1420000; ...
495000,2100000];


for part = 1:19
    A = importdata(strcat('C:\Users\admin\pacof\data\data\participant',{' '},string(part+2),'\feedback_modulation_data.txt'));
    if part == 10 || part == 17 || part ==  19
        A2 = importdata(strcat('C:\Users\admin\pacof\data\data\participant',{' '},string(part+2),'\feedback_modulation_data_2.txt'));
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
    target_hard_soft = A(:,8); % 1 == hard 2 == soft
    recovered_last_contact = A(:,9);
    
    contact_shift = arrayfun(@(t){return_contact(t)}, force_sensor);
    contact_shift = vertcat(contact_shift{:});

    time.raw = [];
    time.av = [];
    time.low = [];
    time.sc = [];

    cont.raw = [];
    cont.av = [];
    cont.low = [];
    cont.sc = [];

    contact_count = 0;
    last_contact_time = 0;
    last_contact_state = 0;
    starttime_current_cond = 0;
    for i=hard_soft_time(part,1):hard_soft_time(part,2)
        if i == hard_soft_time(part,1)
            lastmode = force_condition(i);
        end

        if contact_shift(i) == 0
            if ~(i==1) && contact_shift(i-1)==1 && any(contact_shift(i+1:i+200))    % bounce breaks contact correction
                    contact_shift(i) = 1;
            end
            discard_current = 0;
        else
            if ~discard_current ==1
                if contact_shift(i-1) == 0
                    start_contact = i;
                    bounce_cond = force_condition(i);
                    contact_count = contact_count +1;
                
                    if starttime_current_cond == 0
                        starttime_current_cond = i;
                    end
                end
                if contact_shift(i+1) == 0
                    last_contact_time = i;   
                end
            end
        end
    
        if recovered_last_contact(i) % delete last entry because it was too hard and robot stalled
            if ~any(recovered_last_contact(i-100:i-1)) % if recover was held for more than one clock cycle, only one entry should be deleted
                if lastmode == 0
                       contact_count = contact_count -1;
                    elseif lastmode == 2
                        contact_count = contact_count -1;
                    elseif lastmode == 3
                        contact_count = contact_count -1;
                    elseif lastmode == 4
                        contact_count = contact_count -1;
                end 
            end
            if contact_shift(i) ==1
                discard_current = 1;
            end
        end

        if lastmode ~= force_condition(i)
            if lastmode == 0
                time.raw(end+1) = last_contact_time-starttime_current_cond;
                cont.raw(end+1) = contact_count;
            end
            if lastmode == 2
                time.av(end+1) = last_contact_time-starttime_current_cond;
                cont.av(end+1) = contact_count;
            end
            if lastmode == 3
                time.low(end+1) = last_contact_time-starttime_current_cond;
                cont.low(end+1) = contact_count;
            end
            if lastmode == 4
                time.sc(end+1) = last_contact_time-starttime_current_cond;
                cont.sc(end+1) = contact_count;
            end
            %         restart timer, contact_count and contact
            contact_count = 0;
            starttime_current_cond = 0;
        end
        last_contact_state = contact_shift(i);
        lastmode = force_condition(i);
    end 

    if lastmode == 0
        time.raw(end+1) = last_contact_time-starttime_current_cond;
        cont.raw(end+1) = contact_count;
    end
    if lastmode == 2
        time.av(end+1) = last_contact_time-starttime_current_cond;
        cont.av(end+1) = contact_count;
    end
    if lastmode == 3
        time.low(end+1) = last_contact_time-starttime_current_cond;
        cont.low(end+1) = contact_count;
    end
    if lastmode == 4
        time.sc(end+1) = last_contact_time-starttime_current_cond;
        cont.sc(end+1) = contact_count;
    end

    
    %% display for checking 
    disp(time.raw);
    disp(time.av);
    disp(time.low);
    disp(time.sc);
    
    disp(cont.raw);
    disp(cont.av);
    disp(cont.low);
    disp(cont.sc);
    %% fixes

    if part<10 % ignore label 999 for black condition 
        time.raw(4) = 999999;
        time.av(4) = 999999;
        time.low(4) = 999999;
        time.sc(4) = 999999;
        
        cont.raw(4) = 999999;
        cont.av(4) = 999999;
        cont.low(4) = 999999;
        cont.sc(4) = 999999;
    end

    if part == 4 % myo stopped and datacollection had to be restarted
        time.sc(2) = 15800;
        time.sc(3) = 999999;
        cont.sc(2) = 4;
        cont.sc(3) = 999999;
    end
    
    if part == 8 % condition wrongly selected
        time.sc(3) = 795581-778784;
        cont.sc(3) = 4;
        time.av(3) = 999999;
        cont.av(3) = 999999;
    end

    if part == 10 % two-part collection, remove middle 
        time.raw(4) = time.raw(5);
        cont.raw(4) = cont.raw(5);
    end
        
    if part == 11 % zero-contact state switch to raw, removed
        time.raw(3) = time.raw(4);
        cont.raw(3) = cont.raw(4);
        time.raw(4) = time.raw(5);
        cont.raw(4) = cont.raw(5);
    end

    if part == 14 % selected sc instead of low
        time.low(4) = 999999;
        cont.low(4) = 999999;
        time.sc(4) = time.sc(5);
        cont.sc(4) = cont.sc(5);
    end

    if part == 15 % selected sc instead of low
        time.av(2) = 809748-796827;
        cont.av(2) = 5;
        time.sc(4) = time.sc(3);
        cont.sc(4) = cont.sc(3);
        time.sc(3) = time.sc(2);
        cont.sc(3) = cont.sc(2);
        time.sc(2) = 999999;
        cont.sc(2) = 999999;
    end

    if part == 19 % double condition 2  removed because of restart program because of very long acquisition
        time.low(3) = time.low(4);
        cont.low(3) = cont.low(4);
        time.low(4) = time.low(5);
        cont.low(4) = cont.low(5);      
    end

    figure
    grid on
    hold on
    plot(t,force_sensor)
    plot(t,contact_shift)
    plot(t,force_condition)
    saveas(gcf, strcat("C:\Users\admin\pacof\data\matlab_figures\force_sensor_contact_condition_participant_", string(part), ".fig"))


    %% write to csv
    for del = 1:4
        writematrix([part,0,del,time.raw(del), cont.raw(del)], "auto_gen_hard_soft_data_long.csv",'WriteMode','append')
        writematrix([part,1,del,time.av(del),  cont.av(del)], "auto_gen_hard_soft_data_long.csv",'WriteMode','append')
        writematrix([part,2,del,time.low(del), cont.low(del)], "auto_gen_hard_soft_data_long.csv",'WriteMode','append')
        writematrix([part,3,del,time.sc(del), cont.sc(del)], "auto_gen_hard_soft_data_long.csv",'WriteMode','append')
    end
end

function y = return_contact(x)
    if x > 2
        y = 1.0;
    else 
        y = 0.0;
    end
end