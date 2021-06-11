clc,clear all, close all
%% random
% Experimental Data
e_uni = [6.774995156;6.294889292;6.463268709;6.078024121;6.32488326;5.867413861];
e_multi = [6.126711162;6.241954187;6.708097821;6.076102065;5.607511853];
e_mproHLCF = [4.043205039;log10(15624)];
e_mnonproHLCF = [4.244895334;log10(34096)];
e_uniHL = [4.8382;4.5552];

%% Hao
p_multi_h = [6.7258;6.7258;6.5969;6.1248;5.8193];
p_uni_h = [6.2232;6.2232;6.2232;5.7852;5.7394;5.3963];

%% Time
p_uni = [6.3606;6.1327;6.1335;5.7996;5.7666;5.5383];
p_multi = [6.3175;6.3349;6.2877;6.4983;6.3102];
p_mproHLCF = [4.5393;4.2222];
p_mnonproHLCF = [4.2770;4.6542];
p_uniHL = [4.1868;4.3260];

%% constant
% Experimental Data
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
6.013338693
% ten with mean
3.722222464
3.788451207
4.089481203
4.252488944
4.543521731
4.737828506
5.320638485
6.031758587
4.899404606
3.86421433
4.169733198
4.397575048]';

p = [2.92788341033071;
    3.65953590715422;
    4.10191883368042;
    3.98068497436331;
    4.61160648938064;
    5.32673923963763;
    5.94675479016457;
    3.18412335423967;
    3.63336744511701;
    3.61246596395314;
    4.33599917760813;
    4.10670073236235;
    4.58272226282492;
    5.02123479420405;
    4.56803736532834;
    5.66318247730584;
    5.38455232313001;
    6.37611303613425;
    5.95281810294104;
    5.97195876853856;
    6.70301643860106;
    2.73719264270474;
    3.76477371691104;
    4.59739897505903;
    5.19402288101482;
    4.57292965907937;
    5.38749304800529;
    6.05831212110839;
    5.74171321734862;
    3.499961866;
    4.279826582;
    4.942181736;
    4.161368002;
    3.658011397;
    4.878360916;
    4.691373282;
    5.847478881;
    5.36220907;
    4.381241468;
    4.615339718;
    4.772556397];


a = [2,8];
b = [2,8];

figure
hold on
grid on

%% constant
plot(e(1:7), p(1:7),'d')
plot(e(8:21), p(8:21),'v')
plot(e(22:29), p(22:29),'o')
plot(e(30:41), p(30:41),'s')

%% Random
% plot(e_uni, p_uni_h,'p')
% plot(e_multi, p_multi_h,'p')
% plot(e_uni, p_uni,'o')
% plot(e_multi, p_multi,'d')
% plot(e_uniHL,p_uniHL,'v')
% plot(e_mproHLCF,p_mproHLCF,'d')
% plot(e_mnonproHLCF, p_mnonproHLCF,'o')


%% Fitting line and layout for plot
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
legend('Tension (Uniaxial)','Pure Torsion','Proportion','Tension with mean stress','Fitting','Factor 2','Factor 3','Location','southeast')
% legend('HCF Uniaxial Loading','HCF Multiaxial Loading','HCF+LCF Uniaxial Loading','HCF+LCF Multiaxial Loading','Fitting Curve','Factor 2','Factor 3','Location','southeast')
% legend('Proportional HCF+LCF','Non-proportional HCF+LCF','Fitting Curve','Factor 2','Factor 3','Location','southeast')
title('T7075 Fatigue Constant Loading Predicted Comparison')
% title('Time-based model fatigue life prediction in different sampling')
