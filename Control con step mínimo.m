% MATLAB controller for Webots
% Fecha: 19/09/2020
% Descripción: Implementación de controlador PID.
% Autor: Jerry Rivera
% Modificaciones: Se redujo el step de simulación al mínimo: 1ms. 

TIME_STEP = 1;
i = 0;
I = 0;
Roll = 0;
Uk = 0;
Accelxyz = zeros(1,3);
Aceleracion = 0;

% Variables para el PID
kp = -0.863;%-0.863 -1.02 -2.82 -2.22 
kd = 0;%-0.0015;
ki = 0;
ek_1 = 0;
Ek = 0;
uk = 0;
ref = deg2rad(90);
accel_val = 0;
bandera = 0;

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

% Se comprime el robot y se para
wb_motor_set_position(motor_mecanismo, 0.02)
wb_motor_set_position(motor_cola, 2.4);

% Definición de nodo para aplicar fuerza con el Supervisor
node = wb_supervisor_node_get_from_def('CS');

% Ciclo principal
while wb_robot_step(TIME_STEP) ~= -1
  % Contador
  i = i+1;
  
  % Lectura del Pitch
  roll_pitch_yaw_array = wb_inertial_unit_get_roll_pitch_yaw(IMU);
  
  % Lectura de la aceleración
  x_y_z_array = wb_accelerometer_get_values(ACCEL);
  Accelxyz = [Accelxyz;x_y_z_array];
  % Arreglo de la aceleración
  accel_val = x_y_z_array(3)*cos(0.261799) + x_y_z_array(2)*sin(0.261799);
  Aceleracion = [Aceleracion;accel_val];
  % Posicionar colar para despegue
  if(i == 1000)
    wb_motor_set_position(motor_cola, 0);
  end
  
  % Fuerza para salto
  if((i > 1800) && (i < 1811))
    wb_console_print(sprintf('Aplicando Fuerza'), WB_STDOUT);
    wb_supervisor_node_add_force(node, [0,54.98*cos(deg2rad(15)),-54.98*sin(deg2rad(15))], 1);
  end
  
  % Inicio del control
  if((i > 1810) && (bandera == 0))
      % Mensaje
      wb_console_print(sprintf('Control Activo'), WB_STDOUT);
      
      % Descompresión
      wb_motor_set_position(motor_mecanismo, 0);
      
      % Referencia
      y = roll_pitch_yaw_array(1);
      
      % Errores
      ek = ref-y;
      ed = ek - ek_1;
      
      % Controlador
      uk = kp*ek + (kd/(TIME_STEP*10e-3))*ed;
      
      % Cotas
      if (uk < -max_Torque)
        uk = -max_Torque;
      end
      if (uk > max_Torque)
        uk = max_Torque;
      end
      
      % Actualización
      ek_1 = ek;
      
      % Aplicar torque
      wb_motor_set_torque(motor_cola,uk);
  end   
  
  % Detección de colisión con el suelo
  if(abs(accel_val) > 1000)
    bandera = 1;
    % Se apaga el control
    wb_console_print(sprintf('Colisión detectada'), WB_STDOUT);
    wb_motor_set_velocity(motor_cola, vel_cola);
    wb_motor_set_position(motor_cola, 0.4);
  end 
  
  % Líneas para mostrar cantidades útiles para la verificación del funcionamiento del control
  % wb_console_print(sprintf('Roll: %f Accel: %f\n',rad2deg(roll_pitch_yaw_array(1)),accel_val), WB_STDOUT);
  % wb_console_print(sprintf('kP: %f kD: %f\n',kp,kd), WB_STDOUT);
  
  % Datos para gráficas
  roll = roll_pitch_yaw_array(1);
  Roll = [Roll;roll];
  Uk = [Uk;uk];
  I = [I;i];
  drawnow;

end

% cleanup code goes here: write data to files, etc.
