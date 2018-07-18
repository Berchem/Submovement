function [peaks] = func_elliott(x,initial,final,type)
% it's a function of elliott's method
% [loc,pks,category] = elliott(x,initial,final,type)
% where x is a time series acc/vel
% give the initial and final point to define the boundary of x
% most of all, we need the 'type' input to go different algorithm
temporal = 72 * 130 / 1000;
% temporal = 0;
peaks = [];
if type==1
    x = [0; x];
    [primpeak, primloc] = findpeaks(x, 'sortstr', 'descend', 'npeak', 1); % peak acc of primary movement
    [p1, locp1] = findpeaks(x(initial:final)); % Type I : acceleration
    dx = diff(x);
    p1(locp1 == find(dx(1:end-1).*dx(2:end)<=0,1)+1)=[]; % delete primary peak
    locp1(locp1 == find(dx(1:end-1).*dx(2:end)<=0,1)+1)=[]; % delete primary peak
    
    for i =1:length(locp1)
        if length(x(locp1(i):-1:initial))>=3
            [v1, locv1] = findpeaks(-x(locp1(i):-1:initial),'npeaks',1);
            if isempty(v1)
                v1 = x(initial);
                locv1 = initial;
            else
                v1 = -v1;
                locv1 = locp1(i) - locv1 + 1;
            end
            % get duration
            dur_1 = find(x(locv1-1:-1:initial, 1) >= p1(i), 1);
            dur_2 = find(dx(locv1-1:-1:2) .* dx(locv1-2:-1:1) <= 0, 1) ;
            if isempty([dur_1, dur_2])
                dur = 0;
            else
                dur = min([dur_1, dur_2]) + locp1(i) - locv1;
            end
            % get amplitude
            p1(i) = p1(i) - v1;

            if p1(i)>=0.1*primpeak && dur>temporal  
                peaks = [peaks; locp1(i), locv1, p1(i), dur, 1];
            end
        end
    end
elseif type == 2
    [primpeak, primloc] = findpeaks(x, 'sortstr', 'descend', 'npeak', 1); % peak acc of primary movement
    [p2, locp2] = findpeaks(-x(initial:final)); % Type II : deceleration
    dx = diff(x);
    locp2 = initial + locp2; % find all valley
    
    for i = 1:length(locp2)
        if length(x(locp2(i):final))>=3
            [v2,locv2] = findpeaks(x(locp2(i):final),'npeaks',1);
            if isempty(v2)
                v2 = x(final);
                locv2 = final;
            else
                v2 = -v2;
                locv2 = locp2(i) + locv2;
            end
            % get duration
            dur_1 = find(-x(locv2:final, 1) >= p2(i), 1);
            dur_2 = find(dx(locv2:final-2) .* dx(locv2+1:final-1) <= 0, 1) + 1;
            if isempty([dur_1, dur_2])
                dur = 0;
            else
                dur = min([dur_1, dur_2]) + locv2 - locp2(i);
            end
            % get amplitude
            p2(i) = p2(i) - v2;
            % elliott's condition for Type II
            if p2(i)>=0.1*primpeak && dur>temporal  
                peaks = [peaks; locp2(i), locv2, p2(i), dur, 2];
            end
        end
    end
elseif type==3
    loc3 = find(x(initial:final)>=5,1) + initial - 1;
    if isempty(loc3)~=1
        p3 = max(x(initial:final));
        locp3 = find(x(initial:final) == p3) + initial - 1;
        dur = final - initial;
        peaks = [initial, locp3, p3, dur, 3];
    end
elseif type==4
    loc4 = find(x(initial:final)<=-1,1) + initial-1;
    if isempty(loc4)~=1
        p4 = min(x(initial:final));
        locp4 = find(x(initial:final) == p4) + initial - 1;
        dur = final - initial;
        peaks = [initial, locp4, p4, dur, 4];
    end
else
    return
end
end
