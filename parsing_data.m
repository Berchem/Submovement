function [Kinematic, Submoves, Counter, Measures, Amount] = parsing_data(index_sub, index_dist, index_cond, index_trial, filter, initial_path)
    condi = {'Fast','Fast-Mid','Middle','Mid-Accurate','Accurate'};
    h = waitbar( 0, 'Loading... ', 'name','Calculating...',...
        'CreateCancelBtn', 'setappdata(gcbf,''canceling'',1)' );

    path_data = uigetdir(initial_path);
    
    for sub = index_sub
        for dist = index_dist
            for cond = index_cond
                % parsing the data path
                [~, ~, path_cond] = parsing_path(path_data, sub, dist * 10, cond);
                path_current = [path_cond, '\*.dat'];
                listdir = dir(path_current);
                submoves_ct = zeros(1, 21);
                if strcmp(index_trial, 'all'); index_trial = 1:size(listdir, 1); end
                for trial = index_trial
                    %% load data
                    fname = listdir(trial).name;
                    fname = [path_cond, '\', fname];
                    data = load(fname);
                    %% parsing each trial
                    [kinematic, peaks, typecounter, measures] = parsing_trial(data, filter);
                    Kinematic{dist, cond}{trial, sub} = kinematic;
                    Submoves{dist, cond}{trial, sub} = peaks;
                    Counter{sub, 1}{dist, cond}(trial, :) = typecounter;
                    Measures{sub, 1}{dist, cond}(trial, :) = measures;
                    %% count the number of submoves
                    n = size(peaks, 1) + 1;
                    if n > 20; n = 21; end
                    submoves_ct(1, n) = submoves_ct(1, n) + 1;
                    %% waitbar
                    if getappdata( h, 'canceling' ); break; end
                    percent = trial;
                    waitbar( percent/100, h, [{['subject: ', num2str(sub), ', ',...
                        num2str(dist*10), 'cm, ', condi{cond}, ' -- ',...
                        num2str(round(percent/size(listdir,1)*1000)/10), '%']}] )
                end
                Amount{dist,cond}(sub,:) = submoves_ct;
            end
        end
    end
    
    delete(h)
    
    