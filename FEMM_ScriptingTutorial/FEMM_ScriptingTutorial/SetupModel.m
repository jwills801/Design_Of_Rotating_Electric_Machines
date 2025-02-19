%% Open FEMM and load the geometry
openfemm;
opendocument('scripting_example.fem');
mi_saveas('workingModel.fem'); %Save this with a new name so that you do not
                       %accidentally modify the original geometry
mi_setgrid(1,'polar');

%% Problem Properties (we recommend that you do not modify these)
mi_probdef(0,'millimeters','planar',1e-8,1,-30,0);

%% Initialize Geometry and settings
I_pk = 100; %Peak current [A]
num_turns = 45; %Number of turns
rotor_group = 1; %Group which the rotor elements belong to
R_so = 175; %Stator Outer Radius
R_si = 140; %Stator back iron inner radius
R_sg = 100; %Stator radius at airgap
delta = 5; %Airgap
R_ro = 95; %Rotor outer radius
R_ri = 85; %Rotor Inner radius

%% Fetch Library materials
mi_getmaterial('Air'); %Add air, an in built material to model
mi_getmaterial('18 AWG'); %Add 18 AWG wire to model
import_Recoma33E('Recoma 33E');  %Import Recoma 33E magnet material and add to model
import_M19_29Ga('M19_29Ga');   %Imports the BH curve and adds the material.

%% Create Circuits
mi_addcircprop('U', 0, 1); %Let initial currents be 0. We will assign them later
mi_addcircprop('V', 0, 1);
mi_addcircprop('W', 0, 1);

%% Winding:
R_wdg=(R_sg+R_si)/2; % Radius at which we place winding labels. [mm]
theta = [20, 40, 80, 100, 140, 160, 200, 220, 260, 280, 320, 340].*pi/180; %[rad]
x = R_wdg.*cos(theta); %polar to cartesian as FEMM takes only cartesian inputs
y = R_wdg.*sin(theta); %polar to cartesian as FEMM takes only cartesian inputs

% Assign the winding material at appropriate regions
for i = 1: length(x)
    turns = num_turns;
    if mod(i,2)==0
       turns = -turns;
    end
    mi_clearselected;
    mi_addblocklabel(x(i),y(i));
    mi_selectlabel(x(i),y(i));
    if i == 1|| i ==6 || i ==7 || i==12
       mi_setblockprop('18 AWG', 1, 0, 'U', 0, 0, turns);
    elseif i == 2|| i ==3 || i==8 || i ==9
       mi_setblockprop('18 AWG', 1, 0, 'V', 0, 0, turns);
    else
       mi_setblockprop('18 AWG', 1, 0, 'W', 0, 0, turns);
    end
end
mi_clearselected; %Do this clear after each operation
                  %so that FEMM clears out the previous selection
		  %(otherwise, odd behavior may result)

%% Magnets:
R_m= (R_ro+R_ri)/2; % Radius at which we place magnet labels. [mm]
theta = [0, 90, 180, 270].*pi/180; %[rad]
x = R_m.*cos(theta); %polar to cartesian as FEMM takes only cartesian inputs
y = R_m.*sin(theta); %polar to cartesian as FEMM takes only cartesian inputs
magdir = [0, -90, 180, 90]; %Magnet directions [deg]

%Assign magnet materials
for i = 1: length(x)
    mi_addblocklabel(x(i),y(i));
    mi_selectlabel(x(i),y(i));
    mi_setblockprop('Recoma 33E', 1, 0, 0, magdir(i), 0, 0);
    mi_clearselected;
end

%% Stator Steel
theta = 0;
x = R_si.*cos(theta); %polar to cartesian as FEMM takes only cartesian inputs
y = R_si.*sin(theta); %polar to cartesian as FEMM takes only cartesian inputs
mi_addblocklabel(x,y);
mi_selectlabel(x,y);
mi_setblockprop('M19_29Ga', 1, 0, 0, 0, 0, 0);
mi_clearselected;

%% Rotor steel
% Add this to the center of the geometry. This makes it easy to assign
% unless you have some special kind of rotor
mi_addblocklabel(0,0);
mi_selectlabel(0,0);
mi_setblockprop('M19_29Ga', 1, 0, 0, 0, 1, 0);
mi_clearselected;

%% Airgap
% Add air gap block label at the avg. airgap radius
delta_avg = R_ro + 0.5*delta; % [mm]
mi_addblocklabel(delta_avg,0);
mi_selectlabel(delta_avg,0);
mi_setblockprop('Air', 1, 0, 0, 0, 0, 0);
mi_clearselected;

%% Outer Air
% This is the air outside your stator. Add it 5mm outside the stator
mi_addblocklabel(R_so+5,0);
mi_selectlabel(R_so+5,0);
mi_setblockprop('Air', 1, 0, 0, 0, 0, 0);
mi_clearselected;

%% Set the rotor group numbers
mi_selectcircle(0,0,R_ro+0.25*delta,4)
mi_setgroup(rotor_group);
mi_clearselected;

%% Make boundary
mi_makeABC(7,1.3*R_so,0,0,1); % Create the outer boundary
