clear all, clc, close all
%% Material Parameters
E_7075 = 71700;
G_7075 = 26900;
sig_y = 503;
sig_u = 570;
Poisson = 0.306;
D0 = 10^-2.5;
D = 10^-2.5;
beta = 30.091 * sig_y^ -0.797;
d_ten = 0.01;
% Energy fitting data from paper
a_ten = 9.4994;
b_ten = -0.263;

%% Data input

% HCF Uniaxial Spectrum %Km 100
Load = load('test1_u1.mat') % 6.3606
% Load = load('test1_u2.mat') % 6.1327
% Load = load('test1_u3.mat') % 6.1335
% Load = load('test1_u4.mat') % 5.7669
% Load = load('test1_u5.mat') % 5.7666
% Load = load('test1_u6.mat') % 5.5383

% HCF Multiaxial Spectrum %Km 100
% Load = load('test1_p1.mat') % 6.3175
% Load = load('test1_p2.mat') % 6.3349
% Load = load('test1_p3.mat') % 6.2877
% Load = load('test1_np1.mat') % 6.4983
% Load = load('test1_np2.mat') % 6.3102

% LCF+HCF Uniaxial Spectrum % Km 500
% Load = load('test_LCF_HCF_linear.mat') 
% Load = load('test_LCF_HCF_nonlinear.mat')

% LCF+HCF Multiaxial Spectrum % Km 100
Load = load('test_LCF_HCF_pro.mat')
% Load = load('test_LCF_HCF_nonpro.mat') 

Load = Load.U_eqv;

% Spectrum length 
Load = [Load;Load;Load;Load;Load;Load;Load;Load];
% Load = [Load;Load;Load;Load;Load;Load;Load;Load];
% Load = [Load;Load;Load;Load;Load;Load;Load;Load];
% Load = [Load;Load;Load;Load;Load;Load;Load;Load];
% Load = [Load;Load;Load;Load;Load;Load;Load;Load];

U_T = Load;   

%% Determine A and B fitting parameters
R_ten = 0.; % R ratio
m_ten = -2 / b_ten;
C_ten = (2 * a_ten * E_7075 * pi)^(-m_ten/2) * 2 *(1-D0^((2-m_ten)/2))/(2-m_ten);
B_ten = m_ten - 2 * d_ten;
A_ten = C_ten * (1-R_ten)^B_ten * (2*E_7075*sig_y)^d_ten / 0.36^d_ten;

%% Fatigue Model
i = 1;
while D < 1
    if U_T(i) < U_T(i+1)
        Umax = max(U_T(i:100+i)); % from Kmax
        alf_ten = A_ten * (2 * E_7075 * Umax * pi)^(B_ten/2) * (pi / sig_y)^(d_ten);     
        eqU = (U_T(i+1)^(d_ten) - U_T(i)^(d_ten));      
        dD_dn = alf_ten * eqU * D^((B_ten/2)+d_ten);
    else
        dD_dn = 0;
    end
    D = dD_dn + D;
    D_his(i) = D;
    i = i+1;
end

%% Plot the D-N curve
% x = 1:i-1;
% y = D_his;
% plot(x,y)
% grid on
% xlabel('Life (N)')
% ylabel('Damage (D)')
% legend('Trend')
%% Fatigue life in log scale
N_life = log10(i)
