function [filtered] = func_kalman_filter(data, Q, R)
    f0 = 0;
    p0 = 0;
    f1 = 0;
    p1 = 1;
    filtered = zeros(size(data));
    for i = 1:length(data)
        if i > 1
            f0 = f1;
        else
            f0 = data(i);
        end
        p0 = p1 + Q;
        K = p0 / (p0 + R);
        f1 = f0 + K * (data(i) - f0);
        p1 = (1 - K) * p0;
        filtered(i) = f1;
    end
