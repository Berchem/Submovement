function [path_subj, path_dist, path_cond] = parsing_path(path_data, subj, dist, cond)
    path_subj = [path_data, '\S', num2str(subj)];
    path_dist = [path_subj, '\', num2str(dist)];
    path_cond = [path_dist, '\', num2str(cond)];