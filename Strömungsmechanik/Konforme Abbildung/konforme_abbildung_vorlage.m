% ============================================================
% Stroemung um eine senkrechte Platte via konformer Abbildung
% Zylinderstroemung in z'-Ebene -> Platte in z-Ebene
% ============================================================

clear;
clc;
close all;

%% Konstanten
u_an  = 1;        % Anstroemgeschwindigkeit
R     = 0.5;      % Zylinderradius
Gamma = 0.0;      % Zirkulation

%% Komplexes Potential (ZYLINDER, z'-Ebene)
F_Parallel = @(zp) u_an*zp;
M          = 2*pi*R^2*u_an;
F_Dipol    = @(zp) M./(2*pi*zp);
F          = @(zp,Ga) F_Parallel(zp) + F_Dipol(zp);

%% Numerische Ableitung -> komplexe Geschwindigkeit (Zylinder)
delta_x = 1e-9;
wf_zyl = @(zp,Ga) ...
    ( F(zp + delta_x/2,Ga) - F(zp - delta_x/2,Ga) ) / delta_x;

%% Konforme Abbildung: z = z' - R^2/z'
map      = @(zp) zp - R^2./zp;
dmap_dzp = @(zp) 1 + R^2./zp.^2;

%% Rechengitter in z'-Ebene
[xp,yp] = meshgrid(-2:0.02:2,-2:0.02:2);
zp      = xp + 1i*yp;

% Inneres des Zylinders entfernen
innen = abs(zp) <= R;
zp(innen) = NaN;

%% Geschwindigkeit in der PLATTENEBENE
wf = @(zp,Ga) wf_zyl(zp,Ga) ./ dmap_dzp(zp);

u = real(wf(zp,Gamma));
v = -imag(wf(zp,Gamma));
q = sqrt(u.^2 + v.^2);

%% Punkte in z-Ebene abbilden
z = map(zp);
x = real(z);
y = imag(z);

%% Zylinderkontur -> Plattenkontur
phi      = linspace(0,2*pi,3000);
zp_zyl   = R*exp(1i*phi);
z_platte = map(zp_zyl);

%% Plot
figure;
hold on;

q(innen) = NaN;

contourf(x,y,q,50,'LineStyle','none');
quiver(x(1:8:end,1:8:end), ...
       y(1:8:end,1:8:end), ...
       u(1:8:end,1:8:end), ...
       v(1:8:end,1:8:end),'k');

plot(real(z_platte),imag(z_platte),'k','LineWidth',3);

cb = colorbar;
ylabel(cb,'|u|');

daspect([1 1 1]);
xlabel('x');
ylabel('y');
title('Stroemung um eine senkrechte Platte (konforme Abbildung)');
