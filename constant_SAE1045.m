clear all, clc
% Given 
MP = xlsread('material properties.xlsx',6);
E = MP(1,1);
G = MP(2,1);
sig_y = MP(3,1);
Poisson = MP(4,1);
D0 = 10^-2.5;
beta = 30.091 * sig_y^ -0.797;

% a_ten = MP(5,1);
% b_ten = MP(6,1);
% a_tor = MP(7,1);
% b_tor = MP(8,1);

a_ten = MP(9,1);
b_ten = MP(10,1);
d_ten = 0.01;

%% %%%%%%%%%%%%%%%%%%%%% DATA %%%%%%%%%%%%%%%%%%%%%%%
N_life = [];
Load = load('loading_data_SAE1045.mat');
Load = Load.U_eqv;
for k = 1:length(Load)
    Load1 = [0;Load(k)];
    for j = 1:25
        Load1 = [Load1;Load1];
    end
U_T = Load1;

%% Fatigue Model
i = 1;
D = 10^-2.5;
R_ten = 0.; % R ratio
m_ten = -2 / b_ten;
C_ten = (2 * a_ten * E * pi)^(-m_ten/2) * 2 *(1-D0^((2-m_ten)/2))/(2-m_ten);
B_ten = m_ten - 2 * d_ten;
A_ten = C_ten * (1-R_ten)^B_ten * (2*E*sig_y)^d_ten / 0.36^d_ten; 
% A_ten = C_ten * sqrt(2*E_7075 *sig_y) * (1-R_ten)^(B_ten) * (1 - beta * R_ten)^(-2 * d_ten)/0.6;

while D < 1
    if U_T(i) < U_T(i+1)
        Umax = max(U_T(i:100+i)); 
        alf_ten = A_ten * (2 * E * Umax * pi)^(B_ten/2) * (pi / sig_y)^(d_ten);      
        eqU = (U_T(i+1)^(d_ten) - U_T(i)^(d_ten));       
        dD_dn = alf_ten * eqU * D^((B_ten/2)+d_ten);
    else
        dD_dn = 0;
    end
    D = dD_dn + D;
    D_his(i) = D;
    i = i+1;
end
    %% Life
    N_life(k) = log10(i/2)
end
N_life = N_life';

p_ten = N_life(36:43);
p_tor = N_life(44:66);
p_pro = N_life(1:25);
p_sin90 = N_life(26:35);

% Experimental Data

a = [2,8];
b = [2,8];

e = [3.099680641 % pro
3.208441356;
3.089551883;
3.245018871;
4.07114529;
4.06483222;
4.016197354;
4.301680949;
4.22762965;
4.296006669;
4.824841472;
5.062581984;
4.903089987;
5.091666958;
4.954242509;
4.606166315;
4.994669022;
4.942008053;
5.786609473;
5.774954689;
5.233757363;
5.59505509;
5.409933123;
5.737033531;
6.125806458;
% sin90
3.720985744;
3.70918513;
3.721150844;
4.767378524;
4.691435152;
4.810568529;
4.540579717;
4.590284404;
6.143639235;
5.787885351;
% ten
3.055760465;
3.044147621;
3.695394108;
3.894260664;
5.153814864;
4.893595334;
4.975546686;
6.301029996;
% tor
2.672097858;
2.694605199;
2.733197265;
2.949390007;
2.948901761;
3.103461622;
3.139564266;
3.166430114;
3.740757323;
3.85308953;
3.922206277;
3.940018155;
4.783546282;
4.544316142;
4.557747742;
4.621591676;
4.863025296;
4.978864984;
5.046885191;
5.009025742;
4.75868485;
4.968716377;
5.737192643;
3.638489257;
4.263043983;
4.961207454];


% Plot Chart
figure
hold on
grid on
plot(e(36:43), p_ten,'s')
plot(e(44:66), p_tor,'d')
plot(e(1:25), p_pro,'o')
plot(e(26:35), p_sin90,'v')
plot(a,b,'red')

c = [2+log10(2),8];
d = [2,8-log10(2)];
plot(c,d,'Color','black','LineStyle','-.')

c = [2+log10(3),8];
d = [2,8-log10(3)];
plot(c,d,'Color','blue','LineStyle','--')

e = [2,8-log10(2)];
f = [2+log10(2),8];
plot(e,f,'Color','black','LineStyle','-.')

e = [2,8-log10(3)];
f = [2+log10(3),8];
plot(e,f,'Color','blue','LineStyle','--')

xlabel('Experimental Fatigue Life')
ylabel('Predicted Fatigue Life')
legend('Tension (Uniaxial)','Pure Torsion','Proportion','sin90','Perfect Fitting','Factor 2','Factor 3','Location','southeast')
% title('(Energy)Time-Based Fatigue Predicted Comparison')
title('SAE1045 Fatigue Predicted Comparison')