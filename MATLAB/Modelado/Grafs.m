clear;
clc;
k = 1;
if(k == 1)
    load('Step_torque1_PD.mat');
    Pos = Pos1;
    C = CP;
    C_1 = CPD;
end
if(k == 2)
    load('Step_torque2_PD.mat');
    Pos = Pos2;
    C = CP;
end
if(k == 3)
    load('Step_torque3_PD.mat');
    Pos = Pos3;
    C = CP;
end

subplot(2,1,1);
plot(I,DRoll/10,'b');
title('Velocidad angular pitch');
xlabel('$t (s)$', 'Interpreter', 'latex', 'Fontsize', 14);
ylabel('$\dot{\theta}(rad/s)$', 'Interpreter', 'latex', 'Fontsize', 14);
l = legend('$\dot{\theta}(t)$', 'Location', 'best', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
axis([0 700 -1+min(DRoll)/10 1+max(DRoll)/10]);
grid on;
grid minor;
subplot(2,1,2);
plot(I,-Uk,'r');
title('Entrada de torque');
xlabel('$t (s)$', 'Interpreter', 'latex', 'Fontsize', 14);
ylabel('$u(Nm)$', 'Interpreter', 'latex', 'Fontsize', 14);
l = legend('$u(t)$', 'Location', 'best', 'Orientation', 'horizontal');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
axis([0 700 0 max(-Uk)+0.1]);
grid on;
grid minor;
figure;
step(-Pos);
title('Respuesta al escalón de la posición angular');
figure;
step(feedback(C*Pos,1));
title('Respuesta al escalón del sistema con control PD');
if(k == 4)
    figure;
    step(feedback(C_1*Pos,1));
end
title('Respuesta al escalón del sistema con control P');