function [U_dis, U_dil] = Energy_test(strain_stress)
if nargin ==0
    strain_stress = load('strain_stress_NN_original_modified.mat');
    strain_stress = strain_stress.strain_stress;
end
    ep_dis = 0;
    ep_dil = 0; sig_dil = 0;
    U_dis = 0; U_dil = 0;
    sigma2 = 0; sigma3 = 0;
    epsilon2 = 0; epsilon3 = 0;
    tor1 = 0;tor2 = 0; tor3 = 0;
    gama1 = 0;gama2 = 0; gama3 = 0;
    
    ten = strain_stress(:,2);
    ep = strain_stress(:,1);
    tor = strain_stress(:,4);
    gama_t = strain_stress(:,3);
    for t = 1:length(strain_stress(:,1))
        sigma = ten(t);
        epsilon = ep(t);
        tau = tor(t);
        gama = gama_t(t); 

        sig_dil = (sigma) / 3; 
        ep_dil = (epsilon) / 3;

        sigma_dis = [sigma - sig_dil;
                     sigma2 - sig_dil;
                     sigma3 - sig_dil;
                     tau;
                     tor2;
                     tor3];
        ep_dis(1:6,1) = [(epsilon - ep_dil);
                             (epsilon2 - ep_dil);
                             (epsilon3 - ep_dil);
                             gama;
                             gama2;
                             gama3];
  
        energy_dil = 3 * ((sign(sig_dil) * sign(ep_dil)) / 2) * (sig_dil * ep_dil);
        energy_dis = sum(((sign(sigma_dis) .* sign(ep_dis)) / 2) .* (sigma_dis .* ep_dis));    


        U_dil(t) = energy_dil;
        U_dis(t) = energy_dis;

    end
    U_dil = U_dil';
    U_dis = U_dis';
end


