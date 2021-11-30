% Thomas de Jager
% 29/11/2021
% Scissors-type linkage efficiency calculation script

%% Clear the cache
clear
close all
clc

%% Initialise variables
syms beta real % Angles
syms a real % Linkages
syms Ay Dx Dy Ex Ey F1 F2 real % Forces

%% Calculations
% Matrix of geometric coefficients
A = [0 0 0 1 0 -1; % Linkage 1
    -1 0 0 0 1 0;
    a*cos(beta) 0 0 0 0 -a*sin(beta);
    0 1 0 -1 0 0; % Linkage 2
    0 0 1 0 -1 0;
    0 a*sin(beta) a*cos(beta) 0 0 0];

% Unknown variables
x = [Ay Dx Dy Ex Ey F1].';

% Known variables
b = [0 -F2 -F2*a*cos(beta) 0 0 0].';

% Display the result
disp(x);
disp('=');
disp(simplify(A\b));

%% Sample data
a = 2.5;

% Calculate input force based on given output forces at different angles
beta = linspace(0,pi/2,100);
F1 = zeros(3,length(beta));
efficiency = zeros(3,length(beta));
j=1;
for F2 = 40:15:70
    for i=1:length(beta)
        F1(j,i) = real((F2*cos(beta(i)))/sin(beta(i)));
    end
    efficiency(j,:) = F1(j,:)/F2;
    j = j+1;
end

%% Plot graph
close all
color = ['b' 'b' 'b'];
color2 = ['k' 'k' 'k'];
linetype = {'--', '-.',':'};
figure();
grid on
for j=1:3
    yyaxis left
    ylabel('Input force [N]');
    ylim([0,500]);
    plot(beta*180/pi,F1(j,:),string(linetype(j)),'LineWidth',1,'Color',color(j));
    yyaxis right
    ylabel('Efficiency [e2 %]');
    ylim([0,10]);
    plot(beta*180/pi,1./efficiency(j,:),'LineWidth',1,'Color',color2(j));
    hold on
end
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'k';
title('Force transfer efficiency scissors-type linkage mechanism');
xlabel('Angle \beta [deg]');
legend('F_{output} = 40N','F_{output} = 55N','F_{output} = 70N','Efficiency','Location','northwest');

%% Calculate input and output coordinates
b = 10;
x_input =  -b*cos(beta);
y_output = b*sin(beta);

% Note: figure is not movable/scalable as matlab figure by zooming
% in/panning
figure();
grid on
for j=1:length(beta)
    yyaxis left
    plot(x_input,2*y_output,'-','LineWidth',1,'Color','k');
    hold on
end
title('Relation between input and output variables scissors-type linkage');
xlabel('\delta_{x,input} [mm]');
xlim([-11 0]);
yyaxis left
ymaxlim = 21;
ylim([0 ymaxlim]);
ylabel('2\cdot\delta_{y,output} [mm]');
yyaxis right
ylim([0 ymaxlim/max(2*y_output)*max(beta)*180/pi]);
ylabel('Angle \beta [deg]');
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';