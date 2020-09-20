clear;
clc;
%Gráficas
%Elegir resorte
% 1 = G.104.130.0425
% 2 = G.110.125.0525
% 3 = G.118.125.0225
% 4 = G.128.125.0325
% 5 = G.128.125.0525
% 6 = D.121.160.0325
n = 6;

%Ángulo máximo de torsión permitido (60°)
thetamax = 0:0.0001:60;
thetaF = 75 - thetamax; %Ángulo para calcular fuerza que ejerce el motor
thetaT = thetamax; %Array para eje x
L = 20e-3; %Longitud del eslabón

%Parámetros motor RB_Pol_446
T_RB_pol_446 = 0.0431;
r_RB_pol_446 = (3e-3)/2;
F_RB_pol_446 = T_RB_pol_446/r_RB_pol_446;
fy_RB_pol_446 = (F_RB_pol_446/8)*ones(size(thetamax));

%Parámetros motor RB_Pol_447
T_RB_pol_447 = 0.0628;
r_RB_pol_447 = (3e-3)/2;
F_RB_pol_447 = T_RB_pol_447/r_RB_pol_447;
fy_RB_pol_447 = (F_RB_pol_447/8)*ones(size(thetamax));

%Parámetros motor RB_Pol_448
T_RB_pol_448 = 0.0726;
r_RB_pol_448 = (3e-3)/2;
F_RB_pol_448 = T_RB_pol_448/r_RB_pol_448;
fy_RB_pol_448 = (F_RB_pol_448/8)*ones(size(thetamax));

%Parámetros motor RB_Pol_452
T_RB_pol_452 = 0.1961;
r_RB_pol_452 = (3e-3)/2;
F_RB_pol_452 = T_RB_pol_452/r_RB_pol_452;
fy_RB_pol_452 = (F_RB_pol_452/8)*ones(size(thetamax));

%Parámetros del resorte
switch n
    case 1
        k = 0.209;
        tmax = 0.328;
        ang_max = rad2deg(tmax/k);
    case 2
        k = 0.118;
        tmax = 0.212;
        ang_max = rad2deg(tmax/k);
    case 3
        k = 0.299;
        tmax = 0.243;
        ang_max = rad2deg(tmax/k);
    case 4
        k = 0.207;
        tmax = 0.243;
        ang_max = rad2deg(tmax/k);
    case 5
        k = 0.128;
        tmax = 0.243;
        ang_max = rad2deg(tmax/k);
    case 6
        k = 0.555;
        tmax = 0.490;
        ang_max = rad2deg(tmax/k);
end

%Fuerzas netas que se ejercen en el eslabón
Ft_RB_pol_446 = fy_RB_pol_446./cos(deg2rad(thetaF));
Ft_RB_pol_447 = fy_RB_pol_447./cos(deg2rad(thetaF));
Ft_RB_pol_448 = fy_RB_pol_448./cos(deg2rad(thetaF));
Ft_RB_pol_452 = fy_RB_pol_452./cos(deg2rad(thetaF));

%Torques generados en las juntas
Te_RB_pol_446 = Ft_RB_pol_446*L;
Te_RB_pol_447 = Ft_RB_pol_447*L;
Te_RB_pol_448 = Ft_RB_pol_448*L;
Te_RB_pol_452 = Ft_RB_pol_452*L;

%Torque que sufre el resorte
Tr = k*(deg2rad(75-thetaF));

%Intersecciones
ind_RB_pol_446 = find(abs(Tr-Te_RB_pol_446)<0.0001,1);
ind_RB_pol_447 = find(abs(Tr-Te_RB_pol_447)<0.0001,1);
ind_RB_pol_448 = find(abs(Tr-Te_RB_pol_448)<0.0001,1);
ind_RB_pol_452 = find(abs(Tr-Te_RB_pol_452)<0.0001,1);

%Ángulos máximos de deformación
theta_max_RB_pol_446 = thetaT(ind_RB_pol_446);
theta_max_RB_pol_447 = thetaT(ind_RB_pol_447);
theta_max_RB_pol_448 = thetaT(ind_RB_pol_448);
theta_max_RB_pol_452 = thetaT(ind_RB_pol_452);

if((isempty(theta_max_RB_pol_446) == 1) || (theta_max_RB_pol_446 > 60))
    theta_max_RB_pol_446 = 60;
end
if(theta_max_RB_pol_446 > ang_max)
    theta_max_RB_pol_446 = ang_max;
end

if((isempty(theta_max_RB_pol_447) == 1) || (theta_max_RB_pol_447 > 60))
    theta_max_RB_pol_447 = 60;
end
if(theta_max_RB_pol_447 > ang_max)
    theta_max_RB_pol_447 = ang_max;
end

if((isempty(theta_max_RB_pol_448) == 1) || (theta_max_RB_pol_448 > 60))
    theta_max_RB_pol_448 = 60;
end
if(theta_max_RB_pol_448 > ang_max)
    theta_max_RB_pol_448 = ang_max;
end

if((isempty(theta_max_RB_pol_452) == 1) || (theta_max_RB_pol_452 > 60))
    theta_max_RB_pol_452 = 60;
end
if(theta_max_RB_pol_452 > ang_max)
    theta_max_RB_pol_452 = ang_max;
end

Angulos_maximos = [theta_max_RB_pol_446;theta_max_RB_pol_447;theta_max_RB_pol_448;theta_max_RB_pol_452];
display(Angulos_maximos);

%Gráficas
plot(thetaT,Tr);
hold on;
plot(thetaT,Te_RB_pol_446);
hold on;
plot(thetaT,Te_RB_pol_447);
hold on;
plot(thetaT,Te_RB_pol_448);
hold on;
plot(thetaT,Te_RB_pol_452);
hold on;
yline(tmax); %Torque máximo del resorte
xlabel('$\theta$', 'Interpreter', 'latex', 'Fontsize', 16);
ylabel('$\mathbf{\tau}(\theta)$', 'Interpreter', 'latex', 'Fontsize', 16);
title('Torque en eslabón \tau_{e} y Torque en resorte \tau_{r}')
l = legend('$\tau_{r}$', '$\tau_{e\_RB\_pol\_446}$', '$\tau_{e\_RB\_pol\_447}$', '$\tau_{e\_RB\_pol\_448}$', ...
    '$\tau_{e\_RB\_pol\_452}$', '$\tau_{r\_max}$', 'Location', 'best', ...
    'Orientation', 'vertical');
set(l, 'Interpreter', 'latex', 'FontSize', 12);
grid minor;