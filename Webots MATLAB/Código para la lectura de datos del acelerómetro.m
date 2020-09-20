% MATLAB controller for Webots
% File:          CompresionySalto.m
% Date:
% Description:
% Author:
% Modifications:
desktop;
keyboard;

TIME_STEP = 1;
i = 0;
I = 0;
Accelxyz = zeros(1,3);
Aceleracion = 0;
accel_val = 1;

% Motores y dispositivos
motor_mecanismo = wb_robot_get_device('mot');
motor_cola = wb_robot_get_device('motor cola');
IMU = wb_robot_get_device('IMU');
ACCEL = wb_robot_get_device('XLR8');
wb_inertial_unit_enable(IMU, TIME_STEP);
wb_accelerometer_enable(ACCEL, TIME_STEP);

% Torque máximo del motor
max_Torque = wb_motor_get_max_torque(motor_cola);

% Velocidad máxima del motor
vel_cola = wb_motor_get_max_velocity(motor_cola);
wb_motor_set_velocity(motor_cola, vel_cola);

% Definición de nodo para aplicar fuerza con el Supervisor
node = wb_supervisor_node_get_from_def('CS');

% Ciclo principal
while wb_robot_step(TIME_STEP) ~= -1
  % Contador
  i = i+1;
  
  % Lectura de la aceleración
  x_y_z_array = wb_accelerometer_get_values(ACCEL);
  Accelxyz = [Accelxyz;x_y_z_array];
  % Arreglo de la aceleración
  accel_val = x_y_z_array(3)*cos(0.261799) + x_y_z_array(2)*sin(0.261799);
  Aceleracion = [Aceleracion;accel_val];
  
  wb_motor_set_torque(motor_cola, 0);
  
  %wb_console_print(sprintf('Roll: %f Accel: %f\n',rad2deg(roll_pitch_yaw_array(1)),accel_val), WB_STDOUT);
  %wb_console_print(sprintf('kP: %f kD: %f\n',kp,kd), WB_STDOUT);
  %wb_console_print(sprintf('ii: %f\n',ii), WB_STDOUT);
  
  % Datos para gráficas
  I = [I;i];
  drawnow;

end

% cleanup code goes here: write data to files, etc.
