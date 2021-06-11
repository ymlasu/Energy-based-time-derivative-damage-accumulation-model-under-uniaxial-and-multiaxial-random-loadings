function [U_eqv] = Fatigue_Model_D(energy_uni_lmt, energy_dis_lmt, Poisson, Faxial, Baxial,U_dis,U_dil) %W_ten, W_tor)


s = energy_uni_lmt / energy_dis_lmt;
k = 1 / 3 / (1-2*Poisson) * (503/570)^2; % 276/434
t = (2+2*Poisson) / (1-2*Poisson);
%-------------------------------
if U_dis > (2+2*Poisson) * U_dil / (1-2*Poisson)
     U_uni = 3 * U_dil / (1-2*Poisson);
     U_dis = U_dis - (2+2*Poisson) * U_dil / (1-2*Poisson);
     U_dil = 0;
else
    U_uni = 3 * U_dis / (2+2*Poisson);
    U_dil = U_dil - (1-2*Poisson) * U_dis / (2+2*Poisson);
    U_dis = 0;
end

U_eqv = s*U_dis + U_uni + k*U_dil;
% U_eqv = U_uni 


% F_life = 10 ^ ((log10(U_eqv) - log10(Faxial)) / (Baxial));

end