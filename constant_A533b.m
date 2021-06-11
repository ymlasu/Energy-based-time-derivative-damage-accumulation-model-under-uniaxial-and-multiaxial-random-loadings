clear all, clc
% Given 
MP = xlsread('material properties.xlsx',3);
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
Load = load('loading_data_A533b.mat');
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

p_ten = N_life(1:11);
p_tor = N_life(12:22);
p_pro = N_life(23:42);
p_sin90 = N_life(43:66);

% Experimental Data

a = [2,8];
b = [2,8];

e = [2.716003344;
2.954242509;
3.431363764;
3.361727836;
3.361727836;
3.653212514;
3.892094603;
3.608526034;
4.130333768;
4.674861141;
5.105510185;

% tor
2.903089987;
2.812913357;
3.204119983;
3.525044807;
3.544068044;
3.717670503;
3.841984805;
4.118925753;
4.077004327;
4.588831726;
4.77815125;

% pro
3.799340549;
3.982271233;
3.903089987;
4.29666519;
4.247973266;
5.434568904;
5.51054501;
3.544068044;
3.544068044;
4.07371835;
4.024074987;
4.662757832;
4.630427875;
4.62838893;
4.896526217;
4.914871818;
5.353146546;
5.674493717;
5.679791171;
5.447158031;
% sin90
3.699837726;
3.643452676;
4.255272505;
4.255272505;
5.353339095;
3.53529412;
3.608526034;
3.957128198;
4.082426301;
4.095518042;
4.426511261;
4.484299839;
4.439332694;
4.814247596;
4.873901598;
5.062957834;
4.838219222;
5.103803721;
3.812913357;
3.785329835;
4.247973266;
3.989004616;
4.093421685;
4.161368002];


% Plot Chart
figure
hold on
grid on
plot(e(1:11), p_ten,'s')
plot(e(12:22), p_tor,'d')
plot(e(23:42), p_pro,'o')
plot(e(43:66), p_sin90,'v')
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
title('A533b Fatigue Predicted Comparison')