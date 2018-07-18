function [start, stop] = func_started_stopped_filter(pos)
    start = 0;
    stop = length(pos) - 1;
    ct_index = 0;
    for i = 1:length(pos)-1
        vel = (pos(i+1) - pos(i)) * 130;
        if vel >= 0.3  % velocity > 3 mm/sec
            ct_index = ct_index + 1;
        else
            ct_index = 0;
        end

        ct_time = ct_index / 130;
        if ct_time >= 0.030  % duration > 30 msec
            start = i - ct_index + 1;
            break
        end
    end

    ct_index = 0;
    for j = i:length(pos)-1
        vel = (pos(i + 1) - pos(i)) * 130;
        if abs(vel) <= 0.3
            ct_index = ct_index + 1;
        else
            ct_index = 0;
        end

        ct_time = ct_index / 130;
        if ct_time >= 0.030  % duration > 30 msec
            stop = i - ct_index;
            break
        end
    end
end
