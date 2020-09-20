% MATLAB controller for Webots
% Fecha: 19/09/2020
% Descripción: Funcionamiento continuo del robot.
% Autor: Jerry Rivera

TIME_STEP = 1;
i = 0;
ii = 101;
I = 0;
Roll = 0;
Uk = 0;
Accelxyz = zeros(1,3);
Aceleracion = 0;

% Variables para el PID
kp = -2.82;
kd = kp/20;
ki = 0;
ek_1 = 0;
Ek = 0;
uk = 0;
ref = deg2rad(90);
accel_val = 0;

% Definición de banderas para la máquina de estados finitos
bandera1 = 0;
bandera2 = 0;
bandera3 = 0;
bandera4 = 0;
bandera5 = 0;
banderaC = 0;
banderaContador = 0;
banderaContador2 = 0;

% Motores y dispositivos
motor_mecanismo = wb_robot_get_device('mot');
motor_cola = wb_robot_get_device('motor cola');
P1 = wb_robot_get_device('sensorPos');
IMU = wb_robot_get_device('IMU');
ACCEL = wb_robot_get_device('XLR8');
wb_position_sensor_enable(P1, TIME_STEP);
wb_inertial_unit_enable(IMU, TIME_STEP);
wb_accelerometer_enable(ACCEL, TIME_STEP);

% Torque máximo del motor
max_Torque = wb_motor_get_max_torque(motor_cola);

% Velocidad máxima del motor
vel_cola = wb_motor_get_max_velocity(motor_cola);
wb_motor_set_position(motor_cola, 0.3);

% Definición de nodo para aplicar fuerza con el Supervisor
node = wb_supervisor_node_get_from_def('CS');

% Ciclo principal
while wb_robot_step(TIME_STEP) ~= -1
  % Contador
  if(banderaContador == 1)
    i = i+1;
  end
  if(banderaContador2 == 1)
    ii = ii+1;
  end
  
  % Posición de la cola
  Pos = wb_position_sensor_get_value(P1);
  %wb_console_print(sprintf('Pos: %f \n', Pos), WB_STDOUT);
  
  % Lectura del Pitch
  roll_pitch_yaw_array = wb_inertial_unit_get_roll_pitch_yaw(IMU);
  %wb_console_print(sprintf('Roll: %f\n',rad2deg(roll_pitch_yaw_array(1))), WB_STDOUT);
  
  % Lectura de la aceleración
  x_y_z_array = wb_accelerometer_get_values(ACCEL);
  Accelxyz = [Accelxyz;x_y_z_array];
  %wb_console_print(sprintf('Az: %f \n', x_y_z_array(3)), WB_STDOUT);
  %wb_console_print(sprintf('ii: %f \n', ii), WB_STDOUT);
  % Arreglo de la aceleración
  accel_val = x_y_z_array(3)*cos(0.261799) + x_y_z_array(2)*sin(0.261799);
  Aceleracion = [Aceleracion;accel_val];
  % Se imprimen los valores de las banderas para verificación del correcto funcionamiento
  %wb_console_print(sprintf('Bandera1: %f',bandera1), WB_STDOUT);
  %wb_console_print(sprintf('Bandera2: %f',bandera2), WB_STDOUT);
  %wb_console_print(sprintf('Bandera3: %f',bandera3), WB_STDOUT);
  %wb_console_print(sprintf('Bandera4: %f',bandera4), WB_STDOUT);
  %wb_console_print(sprintf('Bandera5: %f',bandera5), WB_STDOUT);
  
  % Condición estado 1
  if((abs(x_y_z_array(3)) > 8) && (abs(x_y_z_array(3)) < 10) && (roll_pitch_yaw_array(1) > deg2rad(88)) && (roll_pitch_yaw_array(1) < deg2rad(92)) && (ii > 100))
    wb_console_print(sprintf('PARÁNDOSE'), WB_STDOUT);
    bandera5 = 0;
    bandera1 = 1;
    ii = 0;
  end
  
  % Condición estado 2
  if((abs(x_y_z_array(3)) < 3) && (Pos > 2.44) && (roll_pitch_yaw_array(1) < deg2rad(-14)) && (roll_pitch_yaw_array(1) > deg2rad(-16)))
    wb_console_print(sprintf('POSICIONANDO'), WB_STDOUT);
    bandera1 = 0;
    bandera2 = 1;
  end
  
  % Condición estado 3
  if((abs(Pos) < 0.01) && (abs(x_y_z_array(3)) < 3) && (roll_pitch_yaw_array(1) < deg2rad(-14)) && (roll_pitch_yaw_array(1) > deg2rad(-16)))
    wb_console_print(sprintf('SALTANDO, i: %f',i), WB_STDOUT);
    bandera2 = 0;
    bandera3 = 1;
  end
  
  % Condición estado 4
  if((abs(x_y_z_array(3)) < 1) && (i > 1))
    wb_console_print(sprintf('CONTROLANDO'), WB_STDOUT);
    bandera3 = 0;
    bandera4 = 1;
    i = 0;
    banderaContador = 0;
  end
  
  % Condición estado 5
  if((abs(x_y_z_array(3)) > 1000) && (banderaC == 1))
    wb_console_print(sprintf('Colisión detectada.'), WB_STDOUT);
    wb_console_print(sprintf('Control Apagado.'), WB_STDOUT);
    bandera4 = 0;
    bandera5 = 1;
    banderaC = 0;
  end
  
  % Estado 1: Pararse
  if(bandera1 == 1)
    wb_motor_set_velocity(motor_cola, vel_cola);
    wb_motor_set_position(motor_mecanismo, 0.02)
    wb_motor_set_position(motor_cola, 2.45);
  end
  
  % Estado 2: Posicionar cola para despegue
  if(bandera2 == 1)
    wb_motor_set_position(motor_cola, 0);
  end
  
  % Estado 3: Salto
  if(bandera3 == 1)
    banderaContador = 1;
    if(i == 1)
      wb_console_print(sprintf('Aplicando Fuerza'), WB_STDOUT);
      wb_supervisor_node_add_force(node, [0,518.25*cos(deg2rad(15)),-518.25*sin(deg2rad(15))],1);
    end
  end
  
  % Estado 4: Control
  if(bandera4 == 1)
      banderaC = 1;
      
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
    
    % Estado 5: Aterrizaje
    if(bandera5 == 1)
      % Se apaga el control
      wb_motor_set_velocity(motor_cola, vel_cola);
      wb_motor_set_position(motor_cola, 0.25);
      if(Pos > 0.23)
        banderaContador2 = 1;
      end
      if(ii > 100)
        banderaContador2 = 0;
      end
    end
  
  
  % Datos para gráficas
  roll = roll_pitch_yaw_array(1);
  Roll = [Roll;roll];
  Uk = [Uk;uk];
  I = [I;i];
  drawnow;

end
if finished
  saveExperimentData();
  quit(0);
end
% cleanup code goes here: write data to files, etc.
