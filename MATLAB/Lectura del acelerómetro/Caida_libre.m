%Caída Libre
clear;
clc;
load('Caída Libre.mat')
figure;
subplot(2,1,1);
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
axis([0 length(Accelxyz) min(Accelxyz(:,3)) max(Accelxyz(:,3))]);%axis([0 length(Accelxyz) -20 20]);
grid on;
grid minor;
subplot(2,1,2);
plot(I,Aceleracion,'r');
title('Aceleración Vertical');
xlabel('$t(ms)$', 'Interpreter', 'latex', 'Fontsize', 14);
ylabel('$a(m/s^2)$', 'Interpreter', 'latex', 'Fontsize', 14);
l = legend('$a$', 'Location', 'best', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
axis([0 length(Aceleracion) min(Aceleracion) max(Aceleracion)]);%axis([0 length(Aceleracion) -20 20]);
grid on;
grid minor;

load('Estático.mat')
figure;
subplot(2,1,1);
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
axis([0 length(Accelxyz) -20 20]);%axis([0 3500 min(Accelxyz(:,3)) max(Accelxyz(:,3))]);
grid on;
grid minor;
subplot(2,1,2);
plot(I,Aceleracion,'r');
title('Aceleración Vertical');
xlabel('$t(ms)$', 'Interpreter', 'latex', 'Fontsize', 14);
ylabel('$a(m/s^2)$', 'Interpreter', 'latex', 'Fontsize', 14);
l = legend('$a$', 'Location', 'best', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
axis([0 length(Aceleracion) -20 20]);%axis([0 3500 min(Aceleracion) max(Aceleracion)]);
grid on;
grid minor;