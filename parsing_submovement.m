function [peak, typecounter] = parsing_submovement(Vel, Acc)
    Vmax = find(Vel==max(Vel));
    % the location of the max velocity
    under = find(Vel(Vmax:end)<=0.3,1) + (Vmax-1);
    
    % after the max velocity, find the first point of the velocity < 0.3cm/s
    zc = find(Vel(Vmax:end-1).*Vel(Vmax+1:end)<=0) + (Vmax-1);
    % after the max velocity, find the zero crossing of the velocity
    peak1=[]; % type I counter
    peak2=[]; % type II counter
    peak3=[]; % type III counter
    peak4=[]; % type IV counter
    %% calculating
    
    peak1 = func_elliott(Acc, 1, Vmax, 1); % Type I
    if length(zc) < 1
        % in this case, there was no zero crossing occured
        % it would exist type II or III
        peak3 = func_elliott(Vel,under,length(Vel),3); % find type III
        if ~isempty(peak3) % Type III exists
            peak2 = func_elliott(Acc,Vmax,under,2);
        else % Type II only
            peak2 = func_elliott(Acc,Vmax,length(Acc),2);
        end
    else
        % zero crossing was observed in this trial
        % 3 sub-case may occur
        if sum(Vel(under:zc(1))>=5)>0 % case 1 : Type II >> III >> IV
            peak2 = func_elliott(Acc,Vmax,under,2);
            peak3 = func_elliott(Vel,under,zc(1),3);
            peak4 = func_elliott(Vel,zc(1),length(Vel),4);
            %                         subplot(3,1,1); hold on; plot(peak4,Vel(peak4),'^')
        else
            peak2 = func_elliott(Acc,Vmax,zc(1),2);
            if length(zc)<2 % case 3 : Type II >> IV
                peak4 = func_elliott(Vel,zc(1),length(Vel),4);
            else % case 2 : Type II >> IV >> III. There must be 2 zero crossing
                peak4 = func_elliott(Vel,zc(1),zc(2),4);
                peak3 = func_elliott(Vel,zc(2),length(Vel),3);
            end
        end
    end
    %% concatenate different peaks
    peak = [peak1;peak2;peak3;peak4];
    if isempty(peak)~=1
        % sort the peak
        [~,index] = sort(peak(:,1));
        peak = peak(index,:);
    end
    %% which types of peaks were detected
    if size(peak,1) == 0;
        typecounter = [1 0 0 0 0];
    else
        typecounter = [0 size(peak1,1) size(peak2,1) size(peak3,1) size(peak4,1)];
        typecounter = ~isnan(typecounter./typecounter);
    end
    
    
    
 