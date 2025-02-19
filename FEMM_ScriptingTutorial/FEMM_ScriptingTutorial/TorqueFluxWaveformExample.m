%% Initialize the workspace
clear
close all
clc
addpath('C:\femm42\mfiles');

%% Run script to import geometry and configure the motor
SetupModel

%% Solve model at several rotor rotations, extract the torque and flux linkage
%At each rotor angle, the currents are configured to create maximum torque
alpha = linspace(0,180,30); %Mechanical angles at which FE Problem is solved
theta_rot = alpha(2)-alpha(1); %Angle to rotate the rotor by

for i = 1:length(alpha)
    fprintf('Solving for rotation angle %i of %i\n', i, length(alpha))
%Set the currents at each rotor position
    I_u = I_pk*cos(2*alpha(i)*pi/180 + pi/2);
    I_v = I_pk*cos(2*alpha(i)*pi/180 + pi/2-2*pi/3);
    I_w = I_pk*cos(2*alpha(i)*pi/180 + pi/2-4*pi/3);
    mi_setcurrent('U',I_u);
    mi_setcurrent('V',I_v);
    mi_setcurrent('W',I_w);
%Analyse the FE Problem and load the solution
    mi_analyze(1);
    mi_loadsolution;

% Post Processing
% Get the flux linking each coil
    Prop_U = mo_getcircuitproperties('U');
    Prop_V = mo_getcircuitproperties('V');
    Prop_W = mo_getcircuitproperties('W');
    flux_U(i) = Prop_U(3);
    flux_V(i) = Prop_V(3);
    flux_W(i) = Prop_W(3);
% Select the rotor and get torque by MST
    mo_groupselectblock(rotor_group);
    torque(i)=mo_blockintegral(22);
% Close the post processing window
    mo_close;
%Rotate the rotor to the next position for analysis
    if i<length(alpha)
        mi_clearselected;
        mi_selectgroup(rotor_group);
        mi_moverotate(0,0,theta_rot);
        mi_clearselected;
    end
end

%% Create plots of flux linkage and torque vs rotor rotation
figure()
plot(alpha,torque, 'o-');
xlabel('Rotor Angle \theta_{mech} [deg]');
ylabel('Torque [Nm]');

figure()
plot(alpha,flux_U*1e3, 'o-');
hold on
plot(alpha,flux_V*1e3, 'o-');
plot(alpha,flux_W*1e3, 'o-');
xlabel('Rotor Angle \theta_{mech} [deg]');
ylabel('Flux Linkage [mWb]');
