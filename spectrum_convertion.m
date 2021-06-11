clc,clear all, close all
%% Material Properties
MP = xlsread('material properties.xlsx',7);
E = MP(1,1);
G = MP(2,1);
sig_y = MP(3,1);
Poisson = MP(4,1);
D0 = 0;
beta = 30.091 * sig_y^ -0.797;

a_ten = MP(5,1);
b_ten = MP(6,1);
a_tor = MP(7,1);
b_tor = MP(8,1);
% a_ten = MP(9,1);
% b_ten = MP(10,1);
ten_1 = a_ten * 4^b_ten;
tor_1 = a_tor * 4^b_tor;
s = ten_1 / tor_1;

%% Data input [HCF]
% strain_stress = xlsread('loading_dataset.xlsx',1); % Constant loading 
% strain_stress = importdata('Non_Proportional_FALLSTAFF_f2500L_edited_cwt.txt'); % Random loading
if length(strain_stress(1,:)) == 4
    strain_stress = strain_stress;
elseif length(strain_stress(1,:)) == 1
    stress = strain_stress;
    strain = strain_stress ./ E;
    strain_stress = [strain stress zeros(length(strain_stress(:,1))) zeros(length(strain_stress(:,1)))];
elseif length(strain_stress(1,:)) == 2
    stress = strain_stress(:,1);
    shear_stress = strain_stress(:,2);
    ep = stress ./ E;
    gama = shear_stress ./ G;
    strain_stress = [ep stress gama shear_stress];
else 
    strain_stress = strain_stress(:,1) == [];
    stress = strain_stress;
    strain = strain_stress ./ E;
    strain_stress = [strain stress zeros(length(strain_stress(:,1))) zeros(length(strain_stress(:,1)))];
end

%% Data input [LCF]
strain_stress = xlsread('Multi_HC_pro.xlsx'); % multi HCF LCF pro data
% strain_stress = xlsread('Multi_HC_nonpro.xlsx'); % multi HCF LCF nonpro data
% strain_stress = xlsread('Multiaxial_HCF_LCF_pro2.xlsx'); % multi HCF LCF nonpro data
% strain_stress = xlsread('Multiaxial_HCF_LCF_nonpro2.xlsx'); % multi HCF LCF nonpro data


% strain_stress = load('strain_stress_NN_original_modified.mat');
% strain_stress = load('strain_stress_linear_original_modified.mat');
% strain_stress = strain_stress.strain_stress; 
% strain_stress(:,1) .* 2;
% strain_stress = [ans strain_stress(:,2) zeros(length(strain_stress),1) zeros(length(strain_stress),1)];



%% Convert the spectrum to equivalent energy
U_eqv = [];
[U_dis_spec, U_dil_spec] = Energy_test(strain_stress);
for i = 1:length(strain_stress(:,1))
[U_eqv(i)] = Fatigue_Model_D(ten_1, tor_1, Poisson, a_ten, b_ten, U_dis_spec(i), U_dil_spec(i));
end
U_eqv = U_eqv'; 
