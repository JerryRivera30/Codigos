% MATLAB controller for Webots
% Nombre del archivo:          Steps.m
% Fecha: 19/09/2020
% Descripción: Código para obtener modelado del sistema.
% Autor: Jerry Rivera

TIME_STEP = 1;
i = 0;
I = 0;
Roll = 0;
DRoll = 0;
Uk = 0;

uk = 0;

motor1 = wb_robot_get_device('mot');
motor2 = wb_robot_get_device('motor cola');
IMU = wb_robot_get_device('IMU');
GYRO = wb_robot_get_device('gyro');
max_Torque = wb_motor_get_max_torque(motor2);
vel_cola = wb_motor_get_max_velocity(motor2);
wb_inertial_unit_enable(IMU, TIME_STEP);
wb_gyro_enable(GYRO, TIME_STEP)
wb_motor_set_velocity(motor2, vel_cola);
%wb_motor_set_position(motor1, 0.02)
wb_motor_set_position(motor2, 1.75)
node = wb_supervisor_node_get_from_def('CS');

while wb_robot_step(TIME_STEP) ~= -1
  % Se incrementa el contador
  i = i+1;
  
  % Lectura de la IMU
  roll_pitch_yaw_array = wb_inertial_unit_get_roll_pitch_yaw(IMU);
  
  %Lectura del Giroscopio
  x_y_z_array = wb_gyro_get_values(GYRO);

  % Fuerza para generar el salto
  if(i > 100 && i < 110)
    wb_supervisor_node_add_force(node, [0,51.826*cos(deg2rad(15)),-51.826*sin(deg2rad(15))],1);
  end
  
  % Simulación de la descompresión del robot
  if(i > 100)
    wb_motor_set_position(motor1, 0);
  end
  
  % Se setea el valor del torque
  % Se utilizaron varios torques
  % 0.3 Nm
  % 0.4 Nm
  % 0.5 Nm
  if(i == 280)
    uk = 0.3;
  end
  % Se leen las variables de interés
  if(i > 280)
      % Lectura del roll
      y = roll_pitch_yaw_array(1);
      % Lectura de la velocidad del roll
      dy = x_y_z_array(1);
      
      % Se aplica el torque
      wb_motor_set_torque(motor2,uk);
  end 
  
  % Se muestran en consola las variables de interés
  wb_console_print(sprintf('Roll: %f DRoll %f \n',rad2deg(roll_pitch_yaw_array(1)),x_y_z_array(1)), WB_STDOUT);
  % Se almacenan los datos para graficarlos posteriormente
  droll = x_y_z_array(1);
  DRoll = [DRoll;droll];
  Uk = [Uk;uk];
  I = [I;i];

  drawnow;

end
if finished
  saveExperimentData();
  quit(0);
end
% cleanup code goes here: write data to files, etc.
