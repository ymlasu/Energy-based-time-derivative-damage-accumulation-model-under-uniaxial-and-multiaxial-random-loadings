clear all, clc
% Given 
MP = xlsread('material properties.xlsx',2);
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
Load = load('loading_data_6061.mat');
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

p_ten = N_life(1:5);
p_tor = N_life(6:10);
p_pro = N_life(11:16);

% Experimental Data

a = [2,8];
b = [2,8];
e = [3.383815366;
3.152288344;
3.06069784;
2.838849091;
2.556302501;
% tor
3.521138084;
3.238046103;
2.995635195;
2.770852012;
2.602059991;
% pro
3.155336037;
2.86923172;
2.602059991;
3.274157849;
2.954242509;
2.77815125];

% Plot Chart
figure
hold on
grid on
plot(e(1:5), p_ten,'s')
plot(e(6:10), p_tor,'d')
plot(e(11:16), p_pro,'o')
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
legend('Tension (Uniaxial)','Pure Torsion','sin90','Perfect Fitting','Factor 2','Factor 3','Location','southeast')
% title('(Energy)Time-Based Fatigue Predicted Comparison')
title('T6061 Fatigue Predicted Comparison')