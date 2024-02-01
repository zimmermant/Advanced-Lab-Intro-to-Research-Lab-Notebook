function [] = flow_evolution(amp,tf,dt)

% amp gives the amplitude of forcing
% tf is the final time till whcich we integrate, we load t0
% dt is the integration time step O(0.10)

global nu rayfric F D2 ID2 Dx Dy

nu=[]; rayfric=[]; D2 = []; ID2 = []; Dx = []; Dy = [];

% loads simulation parameters
load('parameters.mat','nu','rayfric','F0','D2','ID2','Dx','Dy','Nx','Ny','X','Y');

% Initialise forcing, time and the vorticity
F = amp*F0;
t0 = 0;
t = t0;
omega = 0.2.*rand(Ny,Nx);

%Omega_t is the vector that stores the vorticity field
omega_t = [];
pltnrm = [];

%keeps track of how many time stamps have been saved
count_omega_save = 1;
count_nrm_save=1;

pltnrm(count_nrm_save)= omega(fix(Ny/2),fix(Nx/2));
omega_t(:,:,count_omega_save) = omega;


%this initialises when to start saving the integrated field
del_t_nrm_save = 0.25;
t_nrm_save = t0 + del_t_nrm_save;
del_t_omega_save = 1 ;
t_omega_save = del_t_omega_save + t0;

% The loop that increments time and computes the vorticity field every dt

while (t<tf+dt)
    [t,omega]=integrate(omega,t,dt);
    
    % this condition says when to save the phase to get an estimate of time
    % behaviour
    if(t>=t_nrm_save)
        count_nrm_save = count_nrm_save+1;
        pltnrm(count_nrm_save,:)=omega(fix(Ny/2),fix(Nx/2));
        t_nrm_stamps(count_nrm_save) = t;
        t_nrm_save = t_nrm_save+del_t_nrm_save;
    end
    
    %this condition gives when to save data - the entire vorticity field
    %To use for recurrence analysis we save data every so often. Otherwise we just write data to HDD.
    %The function save_data_HDD writes data to the harddrive
    %The argument check_I is needed in some cases - more on this later
    if(t >= t_omega_save)
        count_omega_save = count_omega_save+1;
        omega_t(:,:,count_omega_save) = omega;
        t_omega_stamps(count_omega_save) = t;
        t_omega_save = t_omega_save+ del_t_omega_save;
    end
end
file_name = sprintf('vorticity_field_%4.3f.mat',amp);
save(file_name,'omega_t','amp','t_omega_stamps','t_nrm_stamps','pltnrm','X','Y');
clear all ; clear all
end


function [t,omega]=integrate(omega,t,dt)
global nu rayfric F Dx Dy D2 ID2 
% second order, implicit linear (CN); explicit nonlinear (MYRK4)

dt_half=dt/2;

% advance linear+forcing terms by dt/2

Omega=fftshift(fft2(omega));

E2=1./(1 - dt_half/2*(nu*D2-rayfric));
Omega=E2.*(dt_half*F + (1 + dt_half/2*(nu*D2-rayfric)).*Omega);

Psi=-ID2.*Omega;
U=Dy.*Psi;
V=-Dx.*Psi;

u=real(ifft2(ifftshift(U)));
v=real(ifft2(ifftshift(V)));


% advance nonlinear terms by dt

omega=real(ifft2(ifftshift(Omega)));

omegax=real(ifft2(ifftshift(Dx.*Omega)));
omegay=real(ifft2(ifftshift(Dy.*Omega)));

k1=-(u.*omegax+v.*omegay);
om_tmp=omega+dt/2*k1;
Om_tmp=fftshift(fft2(om_tmp));
Psi_tmp=-ID2.*Om_tmp;
u_tmp=real(ifft2(ifftshift(Dy.*Psi_tmp)));
v_tmp=real(ifft2(ifftshift(-Dx.*Psi_tmp)));
omegax_tmp=real(ifft2(ifftshift(Dx.*Om_tmp)));
omegay_tmp=real(ifft2(ifftshift(Dy.*Om_tmp)));

k2=-(u_tmp.*omegax_tmp+v_tmp.*omegay_tmp);
om_tmp=omega+dt/2*k2;
Om_tmp=fftshift(fft2(om_tmp));
Psi_tmp=-ID2.*Om_tmp;
u_tmp=real(ifft2(ifftshift(Dy.*Psi_tmp)));
v_tmp=real(ifft2(ifftshift(-Dx.*Psi_tmp)));
omegax_tmp=real(ifft2(ifftshift(Dx.*Om_tmp)));
omegay_tmp=real(ifft2(ifftshift(Dy.*Om_tmp)));

k3=-(u_tmp.*omegax_tmp+v_tmp.*omegay_tmp);
om_tmp=omega+dt*k3;
Om_tmp=fftshift(fft2(om_tmp));
Psi_tmp=-ID2.*Om_tmp;
u_tmp=real(ifft2(ifftshift(Dy.*Psi_tmp)));
v_tmp=real(ifft2(ifftshift(-Dx.*Psi_tmp)));
omegax_tmp=real(ifft2(ifftshift(Dx.*Om_tmp)));
omegay_tmp=real(ifft2(ifftshift(Dy.*Om_tmp)));

k4=-(u_tmp.*omegax_tmp+v_tmp.*omegay_tmp);

omega = omega + dt/6.*(k1 + 2.*(k2+k3) + k4);


% advance linear+forcing terms by dt/2 = dt_half

Omega=fftshift(fft2(omega));

E2=1./(1 - dt_half/2*(nu*D2-rayfric));
Omega=E2.*(dt_half*F + (1 + dt_half/2*(nu*D2-rayfric)).*Omega);

omega=real(ifft2(ifftshift(Omega)));

t=t+dt;

end

