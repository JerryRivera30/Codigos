%PyXLR8
clear;
clc;
load('ControlPD1.mat')
figure;
subplot(2,1,1);
plot(I/1000,rad2deg(Roll),'b');
hold on
yline(rad2deg(ref), '--');
title('Ángulo Roll');
xlabel('$t(s)$', 'Interpreter', 'latex', 'Fontsize', 14);
ylabel('$\theta(rad/s)$', 'Interpreter', 'latex', 'Fontsize', 14);
l = legend('$\theta(t)$', '$referencia$', 'Location', 'best', 'Orientation', 'vertical');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
axis([0 length(Roll)/1000 rad2deg(min(Roll)-0.2) rad2deg(max(Roll)+0.2)]);
grid on;
grid minor;

subplot(2,1,2);
plot(I/1000,Uk,'r');
hold on
yline(max_Torque,'--');
hold on
yline(-max_Torque,'--');
title('Entrada de torque');
xlabel('$t(s)$', 'Interpreter', 'latex', 'Fontsize', 14);
ylabel('$u(Nm)$', 'Interpreter', 'latex', 'Fontsize', 14);
l = legend('$u(t)$', '$torque max$', 'Location', 'best', 'Orientation', 'vertical');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
axis([0 length(Uk)/1000 min(Uk)-0.2 max(Uk)+0.2]);
grid on;
grid minor;

figure;
plot(I,Accelxyz(1:length(Accelxyz),1),'r');
hold on
plot(I,Accelxyz(1:length(Accelxyz),2),'b');
hold on
plot(I,Accelxyz(1:length(Accelxyz),3),'y');
title('Aceleraciones X, Y, Z');
xlabel('$t(ms)$', 'Interpreter', 'latex', 'Fontsize', 14);
ylabel('$a(m/s^2)$', 'Interpreter', 'latex', 'Fontsize', 14);
l = legend('$ax$','$ay$','$az$', 'Location', 'best', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
axis([0 length(Accelxyz) min(Accelxyz(:,3)) max(Accelxyz(:,3))]);%axis([0 3500 min(Accelxyz(:,3)) max(Accelxyz(:,3))]);
grid on;
grid minor;
grid on;
grid minor;