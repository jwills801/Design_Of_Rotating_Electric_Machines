%% Initialize the workspace
addpath('/home/jackson/Documents/Courses/Year5/Design_Of_Rotating_Electric_Machines/wineprefix/drive_c/femm42/mfiles')
    % I don't think this is necessary because this line is already in the
    % matlab startup.m file, but it's included here for fun or something

%% Run script to import geometry and configure the motor
SetupModel

%% Solve under no-load conditions
% Set the currents to zero to get flux density from Magnets alone
    I_u = 0;
    I_v = 0;
    I_w = 0;
    mi_setcurrent('U',I_u);
    mi_setcurrent('V',I_v);
    mi_setcurrent('W',I_w);
% Analyse the FE Problem and load the solution
    mi_analyze(1);
    mi_loadsolution;

%% Extract no-load airgap field and plot the radial component
alpha = linspace(0,360,61); % Sample the airgap at 61 different points
for i = 1:length(alpha)
x = delta_avg*cos(alpha(i)*pi/180);
y = delta_avg*sin(alpha(i)*pi/180);
B = mo_getb(x,y); % This gives the x and y components.
Br(i) = B(1).*cos(alpha(i)*pi/180)+B(2).*sin(alpha(i)*pi/180);
end

% Make Plots
figure()
plot(alpha,Br);
xlabel('Location in Airgap \alpha [deg]');
ylabel('Radial Air Gap Flux Density [T]');
xlim([0,360]);
mo_close;

%% Solve under loaded conditions and determine torque
I_u = 100;
I_v = -50;
I_w = -50;

mi_setcurrent('U',I_u);
mi_setcurrent('V',I_v);
mi_setcurrent('W',I_w);
mi_analyze(1);
mi_loadsolution;
mo_groupselectblock(rotor_group); %Select the rotor block
torque=mo_blockintegral(22); %Get the torque by Stress tensor
mo_close;

fprintf('The torque = %d\n',torque);

%% Calculate winding current linkage (turn magnets "off") and plot
R_m= (R_ro+R_ri)/2; % Radius at which we place magnet labels. [mm]
theta = [0, 90, 180, 270].*pi/180; %Angles of each magnet label
x = R_m.*cos(theta); %polar to cartesian as FEMM takes only cartesian inputs
y = R_m.*sin(theta); %polar to cartesian as FEMM takes only cartesian inputs
for i = 1: length(x)
    mi_selectlabel(x(i),y(i));
    mi_setblockprop('Air', 1, 0, 0, 0, 0, 0); %Change magnet to air to get current linkage
    mi_clearselected;
end

mi_analyze(1);
mi_loadsolution;

alpha = linspace(0,360,61); %Take 61 equally spaced points
for i = 1:length(alpha)
x = delta_avg*cos(alpha(i)*pi/180);
y = delta_avg*sin(alpha(i)*pi/180);
H = mo_geth(x,y); %Get Values of H [A/m]
Hn(i) = H(1).*cos(alpha(i)*pi/180)+H(2).*sin(alpha(i)*pi/180); %Dot product with unit vector in the radial direction to get radial component
end

%Plots
figure()
plot(alpha,Hn.*(delta + (R_ro-R_ri))*1e-3); %CORRECTION FROM VIDEO: use R_ro-R_ri to add magnet length to airgap length
xlabel('Location in Airgap \alpha [deg]');
ylabel('Current Linkage [A]');
xlim([0,360]);
