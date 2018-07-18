function [kinematic, peaks, typecounter, measures] = parsing_trial(data, filter)
    % adjust pixel to cm, 0.00201 is a right trzcform value for pixel to cm
    data(:, 7) = data(:, 7) * 0.00201;
    
    [start, stop] = func_started_stopped_filter(data(:,7));
    if filter == 1
        data(:, 7) = func_filtmat_class((1/130),5,data(:,7), 1); % 5 = cutoff frequency
    elseif filter == 2
        data(:, 7) = func_kalman_filter(data(:,7), 1, 20);
    else
        data(:, 7) = func_weighted_moving_avg(data(:, 7), 4, 0.9);
    end
    
    % get Position, Velocity, Acceleration, Jerk
    Pos = data(start:stop, 7) - data(start, 7);
    Vel = diff(data(start:stop+1, 7)) * 130;
    Acc = diff(Vel) * 130;
    Jerk = diff(Acc) * 130;
    
    % get kinematic
    kinematic = [Pos-Pos(1), Vel, [0; Acc], [0; 0; Jerk]];
    
    % get measures
    measures(1,1) = Pos(Acc==max(Acc)); % peak acceleration,
    measures(1,2) = Pos(Vel==max(Vel)); % peak velocity,
    measures(1,3) = Pos(Acc==min(Acc)); % peak negative acceleration
    measures(1,4) = Pos(end);           % the end of the movement
    
    % detect sub-movements in each trial
    [peaks, typecounter] = parsing_submovement(Vel, Acc);
    
    
    
    
        

    
        

