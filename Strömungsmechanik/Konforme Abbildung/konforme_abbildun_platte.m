% Praktikum Technische Stroemungsmechanik
% Erstellt von Michel Schuemichen, Benjamin Krull
% 08.01.2017

% Hinweis: Definition von Funktionen in Matlab/Octave
%  Eine Funktion f(x) = 3*x wird in Matlab/Octave mit "f = @(x) 3*x" definiert. 
%  Ist zum Beispiel ein Vektor x = [1 2 3]'; gegeben, kann der Vektor der 
%  Funktionswerte ueber "y = f(x)" berechnet werden.


% Speicher bereinigen
clear;
clc;
close all;


%% Komplexes Potential

% Konstanten
u_an     = 1;          % Anstroemgeschwindigkeit
alpha    = 0/180*pi;   % Anstroemwinkel in Bogenmass (betrachte z.B. 30 Grad, d.h. 30/180*pi)
R        = 0.5;        % Radius

% Grundstroemungen
F_Parallel      = @(z) u_an*z;                            % Parallelstroemung
M               = 2*pi*R^2*u_an;                          % Dipolmoment fuer Zylinderumstroemung mit Radius R (vgl. Uebung)
F_Dipol         = @(z) M./(2*pi*z);                       % Dipol
F_PotWirbel     = @(z,Ga) -1i*Ga/(2*pi)*log(z);           % Potentialwirbel mit Zirkulation Ga

% Komplexes Potential der zusammengesetzten Stroemung
% mit Zirkulation Ga als Parameter
F = @(z,Ga) F_Parallel(z) + F_Dipol(z) + F_PotWirbel(z,Ga);

% Rotation der Stroemung um alpha, d.h. z => z*exp(-i*alpha)
F = @(z,Ga) F( z*exp(-1i*alpha), Ga );


%% Komplexe Geschwindigkeit

% Komplexe Geschwindigkeit
% - Ableitung: zentrale Differenzen; in x-Richtung, da Richtung bei komplex
%   diffb. Funktionen beliebig
delta_x = 1e-9;
wf = @(z,Ga) ( F( z+(delta_x/2), Ga ) - F( z-(delta_x/2), Ga ))/delta_x;

% Geschwindigkeitskomponenten in x- und y-Richtung und Norm
uf = @(z,Ga)    real(wf(z,Ga));
vf = @(z,Ga)  - imag(wf(z,Ga));
qf = @(z,Ga)    sqrt(uf(z,Ga).^2+vf(z,Ga).^2);


%% Konkretes Gebiet festlegen
[x,y] = meshgrid(-1.5:0.01:1.5,-1:0.01:1);
z     = x + 1i*y;

innen = find( abs(z) <= R ); % Indexmenge der inneren Punkte
z(innen) = NaN;              % Inneres ausblenden


%% Berechnung der Zylinderkontur
phi     = linspace(0,2*pi,500000);
z_zyl   = R*exp(1i*phi);


%% Groessen berechnen (Verwendung der oben definierten Funktionen)
Gamma = 0.0; % z.B. 1.2
u = uf(z, Gamma);
v = vf(z, Gamma);
q = qf(z, Gamma);


%% Grafische Darstellung
if (1)
    
    % Zylinderinneres zu Null setzen
    q(innen)    = 0;
    
    % Stroemung plotten
    figure;
    hold on;
    contourf(x,y,q,'LineStyle','none'); % Absolutgeschwindigkeit darstellen
    quiver(x(1:10:end,1:10:end),y(1:10:end,1:10:end),u(1:10:end,1:10:end),v(1:10:end,1:10:end),'color',[0 0 0]);   % Darstellung der Geschwindigkeitsvektoren
    cb = colorbar;             % Farbskala anzeigen
    caxis([0 max(q(:))]);      % Bereich festlegen
    ylabel(cb,'q''');            % Beschriftung
    plot(real(z_zyl),imag(z_zyl),'k','LineWidth',2);  
    daspect([1,1,1]);          % Achsenverhaeltnis festlegen
    xlabel('x''');             % Beschriftung x-Achse
    ylabel('y''');             % Beschriftung y-Achse
end
