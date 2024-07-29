clc;
clear;
%close all;
clf

% Define maze boundaries
xmin = -10;
xmax = 10;
ymin = -10;
ymax = 10;

% Define obstacles as inequalities in the form x <= f(y)
obstacles = {
%    @(x,y) y <= x.^2 - 5;                 % Example: parabolic obstacle
%    @(x,y) y >= sin(x) - 3 && y <= 5;     % Example: sine wave obstacle
    @(x,y) (x >= -8.5 && x <= 7.5) && (y >= -8 && y <= -7.5);  % Example: rectangular obstacle
    @(x,y) (x >= 1 && x <= 1.5) && (y >= -10 && y <= -8);
    @(x,y) (x >= 7 && x <= 7.5) && (y >= -7.5 && y <= -5.5);
    @(x,y) (x >= -3 && x <= -2.5) && (y >= -7.5 && y <= -5.5);
    @(x,y) (x >= -3 && x <= 5) && (y >= -5.5 && y <= -5);
    @(x,y) (x >= -10 && x <= -8) && (y >= -5.5 && y <= -5);
    @(x,y) (x >= -10 && x <= -5) && (y >= -5.5 && y <= -5);
    @(x,y) (x >= -5.5 && x <= -5) && (y >= -5 && y <= -2);
    @(x,y) (x >= -10 && x <= -3) && (y >= 0.5 && y <= 1);
    @(x,y) (x >= -3 && x <= -2.5) && (y >= -2 && y <= 1);
    @(x,y) (x >= -3 && x <= 7.5) && (y >= -2.5 && y <= -2);
    @(x,y) (x >= 0 && x <= 7.5) && (y >= 0.5 && y <= 1);
    @(x,y) (x >= 0 && x <= 0.5) && (y >= 1 && y <= 4);
    @(x,y) (x >= -3 && x <= 10) && (y >= 3.5 && y <= 4);
    @(x,y) (x >= -10 && x <= -6) && (y >= 3.5 && y <= 4);
    @(x,y) (x >= -7.5 && x <= 7.5) && (y >= 7.5 && y <= 8);
    @(x,y) (x >= -1.5 && x <= -1) && (y >= 8 && y <= 10);
    @(x,y) (x >= 7 && x <= 7.5) && (y >= 6 && y <= 7.5);
    @(x,y) (x >= 4.5 && x <= 5) && (y >= 4 && y <= 6);
    @(x,y) (x >= -3 && x <= 1) && (y >= 5.5 && y <= 6);
    @(x,y) (x >= -8 && x <= -7.5) && (y >= 6 && y <= 8);
    @(x,y) (x >= -8 && x <= -2) && (y >= 5.5 && y <= 6);
    @(x,y) x <= -10; 
    @(x,y) x >= 10; 
    @(x,y) y <= -10; 
    @(x,y) y >= 10; 
    
};

% Define start and end points
start_point = [0, -10];
end_point = [0, 10];

% Visualization parameters
resolution = 0.1;  % Resolution for plotting obstacles
marker_size = 10;

% Plot maze boundaries
figure(1);
hold on;
plot([-1, xmin, xmin, -1], [ymax, ymax, ymin, ymin], 'k-', 'LineWidth', 2);
plot([1, xmax, xmax, 1], [ymin, ymin, ymax, ymax], 'k-', 'LineWidth', 2);
%plot([xmin, -1, xmax, xmax, xmin, xmin], [ymin, ymin, ymax, ymax, ymin], 'k-', 'LineWidth', 2);

% Plot obstacles
x_range = xmin:resolution:xmax;
y_range = ymin:resolution:ymax;
for i = 1:length(obstacles)
    for j = 1:length(x_range)
        for k = 1:length(y_range)
            if obstacles{i}(x_range(j), y_range(k)) && x_range(j)>-10 && x_range(j)<10 && y_range(k)>-10 && y_range(k)<10
                plot(x_range(j), y_range(k), 'r.', 'MarkerSize', 10);
            end
        end
    end
end
x_rangemat = xmin:0.5:xmax;
y_rangemat = ymin:0.5:ymax;
global mapmat;
mapmat = zeros(((xmax-xmin)/0.5));
for i = 1:length(obstacles)
    for j = 1:length(x_rangemat)
        for k = 1:length(y_rangemat)
            if obstacles{i}(x_rangemat(j), y_rangemat(k)) && x_rangemat(j) > -10 && x_rangemat(j) < 10 && y_rangemat(k) > -10 && y_rangemat(k) < 10
                mapmat(j, k) = Inf;
            end
            if j == 1 || j == length(x_rangemat) || k == 1 || k == length(y_rangemat)
                mapmat(j, k) = Inf;
            end
        end
    end
end
mapmat = rot90(mapmat,1);
mapmat(41, 21) = 0;
mapmat(1, 21) = 0;
% Plot start and end points
plot(start_point(1), start_point(2), 'go', 'MarkerSize', marker_size, 'LineWidth', 2);  % Green circle for start
plot(end_point(1), end_point(2), 'ro', 'MarkerSize', marker_size, 'LineWidth', 2);  % Red circle for end

% Adjust axes and grid
axis equal;
grid on;
xlim([xmin, xmax]);
ylim([ymin, ymax]);
title('COSMOS 24 Cluster 11 Maze');

function floodfill(x, y, path_num)
    global mapmat;
    if (x > 1 && x < length(mapmat) && y > 1 && y < length(mapmat(1, :)))
        if (mapmat(x, y) ~= Inf)
            mapmat(x, y) = path_num;
            if(path_num + 1 < mapmat(x+1, y) || mapmat(x+1, y) == 0)
                floodfill(x+1, y, path_num + 1);
            end
            if (path_num + 1 < mapmat(x-1, y) || mapmat(x-1, y) == 0)
                floodfill(x-1, y, path_num + 1);
            end
            if(path_num + 1 < mapmat(x, y+1) || mapmat(x, y+1) == 0)
                floodfill(x, y+1, path_num + 1);
            end
            if(path_num + 1 < mapmat(x, y-1) || mapmat(x, y-1) == 0)
                floodfill(x, y-1, path_num + 1);
            end
            if(path_num + 1 < mapmat(x+1, y+1) || mapmat(x+1, y+1) == 0)
                floodfill(x+1, y+1, path_num + 1);
            end
            if(path_num + 1 < mapmat(x-1, y+1) || mapmat(x-1, y+1) == 0)
                floodfill(x-1, y+1, path_num + 1);
            end
            if(path_num + 1 < mapmat(x+1, y-1) || mapmat(x+1, y-1) == 0)
                floodfill(x+1, y-1, path_num + 1);
            end
            if(path_num + 1 < mapmat(x-1, y-1) || mapmat(x-1, y-1) == 0)
                floodfill(x-1, y-1, path_num + 1);
            end
        end
    end
end

start_point_mat = [40, 21];
end_point_mat = [1, 21];
floodfill(start_point_mat(1), start_point_mat(2), 1);
mapmat(end_point_mat(1), end_point_mat(2)) = mapmat(end_point_mat(1) + 1, end_point_mat(2)) + 1;
path = dfs(end_point_mat(1), end_point_mat(2), start_point_mat);
pathcoords = toCoords(path);
function coords = toCoords(path)
    coords = [[]];
    for i = 1:length(path)
        coords(end+1, :) = [(path(i, 2) - 21)*0.5, (21 - path(i, 1))*0.5];
    end
end
plot(pathcoords(:, 1), pathcoords(:, 2), "b-", 'LineWidth', 4);
function path = dfs(x, y, start_point)
    global mapmat;
    path = [];
    path = [[x, y];path];
    done = false;
    while x~=start_point(1) || y~=start_point(2)
        for i = x-1:x+1
            for j = y-1:y+1
                if i > 0 && i < length(mapmat) && j > 0 && j < length(mapmat(1, :))
                    if mapmat(i, j) < mapmat(x, y) && mapmat(i, j) ~= Inf
                        x = i;
                        y = j;
                        done = true;
                        path = [[x, y];path];
                        break;
                    end
                end
            end
            if done
                done = false;
                break;
            end
        end
    end
end
function isInRange = inrange(x, y)
    global mapmat;
    if x > 0 && x < length(mapmat) && y > 0 && y < length(mapmat(1, :))
        isInRange = true;
    else
        isInRange = false;
    end
end