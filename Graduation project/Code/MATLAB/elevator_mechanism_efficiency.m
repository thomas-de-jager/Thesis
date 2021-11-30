% Thomas de Jager
% 29/11/2021
% Elevator-type linkage efficiency calculation script

%% Clear the cache
clear
close all
clc

%% Initialise variables
syms beta real % Angles
syms a b c real % Linkages
syms Ax Ay Bx By Cy F1 F2 real % Forces
alpha = asin(b*sin(beta)/(c)); % Helper angle

%% Calculations
% Matrix of geometric coefficients
A = [1 0 -1 0 0 0; % Linkage 1
    0 -1 0 1 0 0;
    0 0 -b*sin(beta) -b*cos(beta) 0 -a;
    0 0 1 0 0 0; % Linkage 2
    0 0 0 -1 1 0;
    0 0 0 0 c*cos(alpha) 0];

% Unknown variables
x = [Ax Ay Bx By Cy F1].';

% Known variables
b = [0 0 0 -F2 0 F2*c*sin(alpha)].'; 

% Display the result
disp(x);
disp('=');
disp(simplify(A\b));

%% Sample data
a = 1.5;
b = 2.5;
c = 4.5;

% Calculate input force based on given output forces at different angles
beta = linspace(0,pi,100);
F1 = zeros(3,length(beta));
efficiency = zeros(3,length(beta));
j=1;
for F2 = 40:15:70
    for i=1:length(beta)
        F1(j,i) = real(-(F2*b*sin(beta(i))*(cos(beta(i)) - (cos(beta(i))^2 + 3)^(1/2)))/(a*(4 - sin(beta(i))^2)^(1/2)));
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
%     ylim([0,500]);
    plot(beta*180/pi,F1(j,:),string(linetype(j)),'LineWidth',1,'Color',color(j));
    yyaxis right
    ylabel('Efficiency [e2 %]');
    ylim([0,5]);
    plot(beta*180/pi,1./efficiency(j,:),'LineWidth',1,'Color',color2(j));
    hold on
end
ax = gca;
ax.YAxis(1).Color = 'b';
ax.YAxis(2).Color = 'k';
title('Force transfer efficiency elevator-type linkage mechanism');
xlabel('Angle \beta [deg]');
legend('F_{output} = 40N','F_{output} = 55N','F_{output} = 70N','Efficiency','Location','northwest');


%% Calculate input and output coordinates
alpha = asin(b*sin(beta)/(2*b));
x_input =  -a*beta;
y_output = b*sin(beta-pi/2)+c*cos(alpha)-(c-b);

% Note: figure is not movable/scalable as matlab figure by zooming
% in/panning
figure();
grid on
for j=1:length(beta)
    yyaxis left
    plot(x_input,2*y_output,'-','LineWidth',1,'Color','k');
    hold on
end
title('Relation between input and output variables elevator-type');
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