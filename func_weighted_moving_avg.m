function [filtered] = func_weighted_moving_avg(data, window, w)
    filtered = zeros(size(data));
    data = [data(window:-1:1); data];
    for i =1:length(data)-window
        filtered(i) = mean(data(i:i+window-1)) * w + data(i+window) * (1 - w);
    end