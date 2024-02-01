function define_parameters(L0,Nmx,Nmy,N0)

% We assume that the magnets are square and hence define just one parameter
% to characterise their size
%L0 in the periodic case is the length of the magnets
%Nmx is the number of magnets in the x direction
%Nmy is the number of magnets in the y direction
%N0  define number of grid points in unit dimension along the x and y. Nx0 * Nx0 is grid density per unit area


kappa = pi/L0;                      % transverse wavenumber
nu = 3.15E-6;                       % effective kinematic viscosity
rayfric = 0.07;                     % rayleigh friction coefficient

%----------------------------------------------------------------------------------------------------------------------------------------------------------------%
% GRID SETTINGS
Nx=Nmx*N0;  % number of mesh points in transverse direction
Ny=Nmy*N0;  % number of grid points along the y direction
Lx=Nmx*L0;  % The width of the domain over which we are integrating
Ly=Nmy*L0;  % The height of the domain we are inegrating over

%----------------------------------------------------------------------------------------------------------------------------------------------------------------%
% MEMORY ALLOCATION FOR DERIVATIVES AND WAVENUMBER VECTORS
x = (1:Nx)./Nx.*Lx;                 %define x vector corresponding to physical coordinates
y = (1:Ny)./Ny.*Ly;                 %define y vector corresponding to physical coordinates
[X Y] = meshgrid(x,y);
f0 = sin(kappa.*Y).*sin(kappa.*X);  %the functional form of force, without amplitude
F0=fftshift(fft2(f0));              %Fourier transform of force

% Wave numbers & differential operators
for k=1:Nx
    qx(k)=(k-1-Nx/2)*2*pi/Lx;
    Dx(:,k)=1i*qx(k)*ones(Ny,1);   % x-derivative
end

for k=1:Ny
    qy(k)=(k-1-Ny/2)*2*pi/Ly;
    Dy(k,:)=1i*qy(k)*ones(1,Nx);   % y-derivative
end

Nx2=Nx/2+1;
Ny2=Ny/2+1;
D2=Dx.*Dx+Dy.*Dy;	% Laplacian
Dy(1,:)=zeros(1,Nx);
Dx(:,1)=zeros(Ny,1);
ID2=D2; ID2(Ny2,Nx2)=-1e32;
ID2=1./ID2;	% Laplacian inverse

save('parameters.mat','nu','rayfric','kappa','N0','Nmx','Nmy','L0','Lx','Ly','Dx','Dy','ID2','D2','F0','f0','X','Y','Nx','Ny');
sprintf('Nmx = %d \nNmy = %d \nLy = %f \nNx = %d \nNy = %d \nnu = %f \nrayfric = %f \n',Nmx,Nmy, Ly, Nx, Ny, nu, rayfric)
pause(3)
clear all
clc
end
