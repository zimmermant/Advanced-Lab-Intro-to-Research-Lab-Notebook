function plot_omega(file_name,pause_for)
load(file_name,'omega_t','X','Y');
figure
for i = 1:size(omega_t,3)
    contourf(omega_t(:,:,i),20);
    pause(pause_for)
end
end

