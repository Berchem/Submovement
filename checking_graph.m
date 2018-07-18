Acc1 = Kinematic{index_dist, index_cond}{index_trial, index_sub}(:,3);
vel =  Kinematic{index_dist, index_cond}{index_trial, index_sub}(:,2);
L = length(Acc1);
x = Submoves{index_dist, index_cond}{index_trial, index_sub}(:,1);
y = Acc1(x);

acc_max_y = max(Acc1);
acc_max_x = find(Acc1==acc_max_y);

c(1, :) = [0, 82, 255] / 255;
c(2, :) = [255, 153, 0] / 255;

fig = figure('Position',[35 246 560 420]);
hold on; box on
plot([1, L], [0, 0], 'k:')

plot(acc_max_x * [1, 1], acc_max_y * [0, 1], 'k:')
plot(acc_max_x + L * .08 *[-1, 1], acc_max_y * [1, 1], 'k:')

peak = Submoves{index_dist, index_cond}{index_trial, index_sub}
for p = 1:size(peak, 1)
    if peak(p, 5) > 2
        continue
    end
    x_0 = peak(p, 1); y_0 = Acc1(x_0);
    x_1 = peak(p, 2); y_1 = Acc1(x_1);
    if peak(p, 5) == 1
        x_2 = peak(p, 1) - peak(p, 4);
    elseif peak(p, 5) == 2
        x_2 = peak(p, 1) + peak(p, 4);
    end
    y_2 = Acc1(x_2);
    plot([x_0, x_2], [y_0, y_0], 'k:')
    plot([x_1, x_1], [y_0, y_1], 'k:')
    plot([x_2, x_2], [y_0, y_2], 'k:')
    text(x_1, y_0, ['dur = ', num2str(abs(x_2 - x_0) / 130 * 1000, 4), 'ms'], ...
        'horizontalalignment', 'center', 'verticalalignment', 'bottom', 'fontname', 'consolas')
    text(x_1, (y_0 + y_1) / 2, ['amp = ', num2str(abs(y_1 - y_0), 4)], ...
        'horizontalalignment', 'center', 'verticalalignment', 'middle', 'fontname', 'consolas')
end

plot(Acc1, 'color', c(1, :), 'linewidth', 2)
plot(x, y, '^', 'color', c(2, :), 'markerfacecolor', c(2, :))

text(acc_max_x+0.02*L, acc_max_y, ['Acc_{\itpeak}= ', num2str(acc_max_y)],...
    'verticalalignment', 'top', 'fontname', 'consolas', 'fontsize', 11)

axis('tight')
xlim = get(gca, 'xlim');
ylim = get(gca, 'ylim');
dx = diff(xlim) * 0.05;
dy = diff(ylim) * 0.05;
axis([xlim(1)-dx, xlim(2)+dx, ylim(1)-dy, ylim(2)+dy])


%%
if any(peak(:, 5) > 2)
    fig = figure('Position',[35 246 560 420]);
    hold on; box on
    plot([1, L], [0, 0], 'k:')
    y = vel(x);
    plot(vel)
    for p = 1:length(x)
        if peak(p, 5) > 2
            x_0 = peak(p, 1); y_0 = vel(x_0);
            x_1 = peak(p, 2); y_1 = vel(x_1);
            x_2 = peak(p, 1) + peak(p, 4); y_2 = vel(x_2);

            plot(x_0:x_2, vel(x_0:x_2) * ones(1, p+1), 'linewidth', 2)

            plot([x_0, x_2], [y_0, y_0], 'k:')
            plot([x_1, x_1], [y_0, y_1], 'k:')
            plot([x_2, x_2], [y_0, y_2], 'k:')
            text(x_0, y_0, ['dur = ', num2str(abs(x_2 - x_0) / 130 * 1000, 4), 'ms'], ...
                'verticalalignment', 'bottom', 'fontname', 'consolas')
            text(x_1, y_1, ['amp = ', num2str(abs(y_1 - y_0), 4)], ...
                'horizontalalignment', 'center', 'verticalalignment', 'middle', 'fontname', 'consolas')
        end
    end
end