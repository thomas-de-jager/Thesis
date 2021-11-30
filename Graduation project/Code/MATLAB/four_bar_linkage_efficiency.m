% Thomas de Jager
% 29/11/2021
% Four bar linkage efficiency calculation script

%% Clear the cache
clear
close all
clc

%% Initialise variables
syms beta real % Angles
syms a b c real % Linkages
syms Ax Ay By Gy F_AD F_BD F_BG F_DE F_EG F1 F2 real % Forces
alpha = acos((c-b*sin(beta))/a)+pi/2; % Helper angle


%% Calculations
% Matrix of geometric coefficients
A = [1 0 0 0 -cos(alpha) 0 0 0 0 0; % Node A
    0 -1 0 0 sin(alpha) 0 0 0 0 0;
    0 0 0 0 0 cos(beta) 1 0 0 -1; % Node B
    0 0 -1 0 0 sin(beta) 0 0 0 0;
    0 0 0 0 sin(alpha) -cos(beta) 0 -1 0 0; % Node D
    0 0 0 0 -cos(alpha) -sin(beta) 0 0 0 0;
    0 0 0 0 0 0 0 1 -cos(beta) 0; % Node E
    0 0 0 0 0 0 0 0 -sin(beta) 0;
    0 0 0 0 0 0 -1 0 cos(beta) 0; % Node G
    0 0 0 -1 0 0 0 0 sin(beta) 0;];

% Unknown variables
x = [Ax Ay By Gy F_AD F_BD F_BG F_DE F_EG F1].';

% Known variables
b = [0 0 0 0 0 0 0 -F2 0 0].'; 

% Display the result
disp(x);
disp('=');
disp(simplify(A\b));

%% Sample data
a = 2.5;
b = 5;
c = 2.5;

% Calculate input force based on given output forces at different angles
beta = linspace(0,pi/2,100);
F1 = zeros(3,length(beta));
efficiency = zeros(3,length(beta));
j=1;
for F2 = 40:15:70
    for i=1:length(beta)
        F1(j,i) = real((F2*a*cos(beta(i))*(-(b^2*sin(beta(i))^2 - a^2 + c^2 - 2*b*c*sin(beta(i)))/a^2)^(1/2))/(c*cos(beta(i)) - b*cos(beta(i))*sin(beta(i)) + a*sin(beta(i))*(-(b^2*sin(beta(i))^2 - a^2 + c^2 - 2*b*c*sin(beta(i)))/a^2)^(1/2)));
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
    plot(beta*180/pi,F1(j,:),string(linetype(j)),'LineWidth',1,'Color',color(j));
    yyaxis right
    plot(beta*180/pi,1./efficiency(j,:),'LineWidth',1,'Color',color2(j));
    hold on
end
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'k';
title('Force transfer efficiency four bar linkage with guiding rod');
xlabel('Angle \beta [deg]');
legend('F_{output} = 40N','F_{output} = 55N','F_{output} = 70N','Efficiency','Location','northwest');
yyaxis left
ylabel('Input force [N]');
yyaxis right
ylim([0,10]);
ylabel('Efficiency [e2 %]');

%% Calculate input and output coordinates
alpha = acos((c-b*sin(beta))/a)+pi/2;
x_input =  - b*cos(beta) - a*cos(alpha);
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
title('Relation between input and output variables four bar linkage');
xlabel('\delta_{x,input} [mm]');
xlim([-5 0]);
yyaxis left
ymaxlim = 11;
ylim([0 ymaxlim]);
ylabel('2\cdot\delta_{y,output} [mm]');
yyaxis right
ylim([0 ymaxlim/max(2*y_output)*max(beta)*180/pi]);
ylabel('Angle \beta [deg]');
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';