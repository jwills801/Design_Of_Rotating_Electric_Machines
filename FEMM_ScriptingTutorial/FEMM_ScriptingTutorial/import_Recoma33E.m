function import_Recoma33E(matName)
%IMPORT_Recoma33E imports Recoma 33E magnet into FEMM. You can import any
%other magnets too by appropriately renaming the function and 
%setting the values of mu_r and Hc for that material.

mu_r = 1.067;%Relative permeability
Hc = 865000; %Coercivity of the magnet, units of A/m
Conductivity = 0; %Conductivity, units of MS/m
lam_fill = 1; %Lamination fill =1 (Magnets are not laminated)
nstr = 1; %No. of strands (FEMM Scripting Manual says this should be set to 1 for Magnets Ref: Pg 10)
mi_addmaterial(matName, mu_r, mu_r, Hc, 0, Conductivity, 0, 0, lam_fill,...
    0, 0, 0, nstr);

end
