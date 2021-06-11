clear all, clc
%% Material Parameters
MP = xlsread('material properties.xlsx',7);
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

%% Data Input
N_life = [];
T_D = [];
Load = load('loading_data_7075.mat');
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

while D < 1
    if U_T(i) < U_T(i+1)
        Umax = max(U_T(i:100+i)); % from Kmax

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

p = N_life;
e = [2.962369336
3.48756256
3.853941446
3.959613711
4.431540663
4.996892388
5.963640048

% % tor
3.256958153
3.54863506
3.632558515
4.275126999
4.306875174
5.250578564
5.488753716
5.516952942
5.606092097
5.631960961
5.906218101
5.960729945
6.002244271
6.587445819
% pro
3.29380436
3.962558736
4.772277688
5.135596923
4.658011397
5.821269128
6.007747778
6.013338693]';
%ten with mean stress
% 3.722222464
% 3.788451207
% 4.089481203
% 4.252488944
% 4.543521731
% 4.737828506
% 5.320638485
% 6.031758587
% 4.899404606
% 3.86421433
% 4.169733198
% 4.397575048]';

a = [2,8];
b = [2,8];

% Plot Chart
figure
hold on
grid on
plot(e(1:7), p(1:7),'p')
plot(e(8:21), p(8:21),'v')
plot(e(22:29), p(22:29),'d')
% plot(e(30:41), p(30:41),'s')
% plot(e(1:15), p(1:15),'o')
plot(a,b,'red')

collect_A = [2+log10(2),8];
d = [2,8-log10(2)];
plot(collect_A,d,'Color','black','LineStyle','-.')

collect_A = [2+log10(3),8];
d = [2,8-log10(3)];
plot(collect_A,d,'Color','blue','LineStyle','--')

e = [2,8-log10(2)];
f = [2+log10(2),8];
plot(e,f,'Color','black','LineStyle','-.')

e = [2,8-log10(3)];
f = [2+log10(3),8];
plot(e,f,'Color','blue','LineStyle','--')

xlabel('Experimental Fatigue Life')
ylabel('Predicted Fatigue Life')
legend('Tension (Uniaxial)','Pure Torsion','Proportion','Perfect Fitting','Factor 2','Factor 3','Location','southeast')
% title('(Energy)Time-Based Fatigue Predicted Comparison')
title('T7075 Fatigue Predicted Comparison')