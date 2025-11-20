clear;
clc;
close all;

%
% Physikalische Parameter
L_Seg = 2;
Gamma = 2*pi;
r_0   = 1;


%% 
% ======================================================================
% Symbolische Funktionen für indizierte Geschwindigkeit in der Umgebung 
% eines Segments
% ----------------------------------------------------------------------

syms x y

% u_theta nach Biot-Savart
func1(x,y) = 0;  % TODO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% Regularisierungs-Funktion f(r)
func2(x,y) = 0;  % TODO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% Regularisierungs-Funktion f(d)
func3(x,y) = 0;  % TODO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% u_theta * f(r)
func4(x,y) = 0;  % TODO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% u_theta * f(d)
func5(x,y) = 0;  % TODO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

% Referenzgeschwindigkeit zur Normierung
U_ref  = abs(func1(0,r_0));



%%
% ======================================================================
% Plots
% ----------------------------------------------------------------------


% Parameter für Plots
my_view = [[150,35]; [90,0]; [0,0]; [0,90]];
fontsize_small = 10;
fontsize_large = 12;

y_max = 2;
x_max = L_Seg/2 + y_max;


%%
% u_theta
for cnt = 1:size(my_view,1)
    figure
    fsurf( func1/U_ref );
    xlim([-x_max,x_max]);
    ylim([-y_max,y_max]);
    zlim([-1,1]);
    cb = colorbar(); 
    ylabel(cb,'u_\theta / U_{ref}','Fontsize',fontsize_large,'Rotation',90)
    clim([-1, 1]);
    xlabel('x / L','Fontsize',fontsize_large);
    ylabel('y / L','Fontsize',fontsize_large);
    zlabel('u_\theta / U_{ref}','Fontsize',fontsize_large);
    ax = gca;
    ax.XAxis.FontSize = fontsize_small;
    ax.YAxis.FontSize = fontsize_small;
    view( my_view(cnt,1), my_view(cnt,2) );
end


%%
% f(r)
for cnt = 1:size(my_view,1)
    figure
    fsurf( func2 );
    xlim([-x_max,x_max]);
    ylim([-y_max,y_max]);
    zlim([0,1.25]);
    cb = colorbar();
    ylabel(cb,'f(r)','Fontsize',fontsize_large,'Rotation',90)
    clim([0, 1]);
    xlabel('x / L','Fontsize',fontsize_large);
    ylabel('y / L','Fontsize',fontsize_large);
    zlabel('f(r)','Fontsize',fontsize_large);
    ax = gca;
    ax.XAxis.FontSize = fontsize_small;
    ax.YAxis.FontSize = fontsize_small;
    view( my_view(cnt,1), my_view(cnt,2) );
end


%%
% f(d)
for cnt = 1:size(my_view,1)
    figure
    fsurf( func3 );
    xlim([-x_max,x_max]);
    ylim([-y_max,y_max]);
    zlim([0, 1.25]);
    cb = colorbar();
    ylabel(cb,'f(d)','Fontsize',fontsize_large,'Rotation',90)
    clim([0, 1]);
    xlabel('x/L','Fontsize',fontsize_large);
    ylabel('y/L','Fontsize',fontsize_large);
    zlabel('f(d)','Fontsize',fontsize_large);
    ax = gca;
    ax.XAxis.FontSize = fontsize_small;
    ax.YAxis.FontSize = fontsize_small;
    view( my_view(cnt,1), my_view(cnt,2) );
end


%%
% u_theta * f(r)
for cnt = 1:size(my_view,1)
    figure
    fsurf( func4/U_ref );
    xlim([-x_max,x_max]);
    ylim([-y_max,y_max]);
    zlim([-1,1]);
    cb = colorbar(); 
    ylabel(cb,'u_\theta / U_{ref}','Fontsize',fontsize_large,'Rotation',90)
    clim([-1, 1]);
    xlabel('x / L','Fontsize',fontsize_large);
    ylabel('y / L','Fontsize',fontsize_large);
    zlabel('u_\theta / U_{ref}','Fontsize',fontsize_large);
    ax = gca;
    ax.XAxis.FontSize = fontsize_small;
    ax.YAxis.FontSize = fontsize_small;
    view( my_view(cnt,1), my_view(cnt,2) );
end


%%
% u_theta * f(d)
for cnt = 1:size(my_view,1)
    figure
    fsurf( func5/U_ref );
    xlim([-x_max,x_max]);
    ylim([-y_max,y_max]);
    zlim([-1,1]);
    cb = colorbar(); 
    ylabel(cb,'u_\theta / U_{ref}','Fontsize',fontsize_large,'Rotation',90)
    clim([-1, 1]);
    xlabel('x / L','Fontsize',fontsize_large);
    ylabel('y / L','Fontsize',fontsize_large);
    zlabel('u_\theta / U_{ref}','Fontsize',fontsize_large);
    ax = gca;
    ax.XAxis.FontSize = fontsize_small;
    ax.YAxis.FontSize = fontsize_small;
    view( my_view(cnt,1), my_view(cnt,2) );
end
