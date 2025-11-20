%##########################################################################
% ----------------Praktikum Technische Stroemungsmechanik------------------
% MATLAB-Skript zur Simulation von Wirbelringen: Deformation, Bewegung,
% Interaktion
%
% input: Excel-File "Konfiguration.xlsx"
%
%
% log:   Karl Schoppmann, 11/2023
%
%##########################################################################

% Speicher bereinigen
clear;
clc;
close all;


%%
%##########################################################################
% Preprocessing, Initialisierung
%##########################################################################

%--------------------------------------------------------------------------
% Allgemeine Parameter fuer gesamte Konfiguration
T        = 20         % physikalische Endzeit (in Sekunden) fuer Simulation
dt       = 0.3;      % Zeitschrittweite fuer physikalische Ergebnisse
N_Wr     = 2;         % Anzahl der Wirbelringe

Konfig = readmatrix('Konfiguration.xlsx');


% zusaetzliche, fest im Raum fixierte Punkte (fP), d.h. EULERsche Punkte
N_fP          = 1;        % Anzahl an fixierten Punkten
fP_Verteilung = "Punkt";  % "Punkt" | "Linie" | "Ebene"
MP_fP = [0; 0; 0];        % Mittelpunkt der Punkteverteilung
L     = 0.4;              % char. Laenge der Punkteverteilung
                          %  - "Punkt": keine Bedeutung
                          %  - "Linie": Laenge der Linie
                          %  - "Ebene": Kantenlaenge einer quadrat. Flaeche
v     = [0; 1; 0];        % char. Vektor der Punkteverteilung
                          %  - "Punkt": keine Bedeutung
                          %  - "Linie": Richtungsvektor der Linie
                          %  - "Ebene": Normalenvektor der Ebene


%--------------------------------------------------------------------------
% Initialisierung der Wirbelringe

Wr = Init_Wr(Konfig, N_Wr);


%--------------------------------------------------------------------------
% Initialisierung der zusaetzlichen raumfesten Punkte

fP = struct();

if N_fP > 0
    fP = Init_fP( N_fP, fP_Verteilung, MP_fP, L, v);
end


%--------------------------------------------------------------------------
% Initialisierung des Loesungsvektors s(t=0) = s0 fuer ode-Solver

N_Kn_ges = 0;   % gesamte Knotenanzahl aller Wirbelringe
for n_Wr = 1:N_Wr
    N_Kn_ges = N_Kn_ges + Wr(n_Wr).N_Seg;
end

s0 = zeros( 3*N_Kn_ges, 1);  % Initialisierung eines Spaltenvektors

s0 = x2s(s0, Wr, N_Wr);  % Knotenpunkte x aller Wr in s0 einsortieren



%% 
%##########################################################################
% Loesung einer DGL der Form ds/dt = rhs(s,t) fuer den Loesungsvektor s
%##########################################################################

if T>0
    fprintf('###############################\n')
    fprintf('Simulation gestartet.\n')
    fprintf('###############################\n')
    
    start_time = tic;
    
    tspan   = 0:dt:T;
    options = odeset('RelTol',1e-8,'AbsTol',1e-10);
    [t, s]  = ode78(@(t,s) rhs(t,s,Wr,N_Wr,fP,N_fP), tspan, s0, options);
    
    end_time = toc(start_time);
    
    fprintf('###############################\n')
    fprintf('Simulation erfolgreich beendet.\n')
    fprintf('Dauer: %0.1f s\n', end_time)
    fprintf('###############################\n')
end



%% 
%##########################################################################
% Postprocessing
%##########################################################################

%--------------------------------------------------------------------------
% Induzierte Geschwindigkeit an Knotenpunkten (dsdt) und an raumfesten
% Punkten (fP(i).U_ind)

if T == 0
    t = 0;
    s = s0;
    [dsdt, Wr, fP] = rhs(t, s, Wr, N_Wr, fP, N_fP);

else
    s = s';  % Spaltenvektor
    
    dsdt = zeros( size(s) );
    
    for n_t = 1:size(t,1)
        dsdt(:,n_t) = rhs(t(n_t), s(:,n_t), Wr, N_Wr, fP, N_fP);
    end
end


%%
%##########################################################################
% Visualisierungen, Plots
%##########################################################################


% Ausgabe der induzierten Geschwindigkeit an einzelnen Punkten
if T == 0 & N_fP == 1
    fprintf('---------------------------------------------------------\n');
    fprintf('Position des raumfesten Punkts:\n');
    fprintf('   x = %.4f \n', fP(1).x(1) );
    fprintf('   y = %.4f \n', fP(1).x(2) );
    fprintf('   z = %.4f \n', fP(1).x(3) );
    fprintf('Induzierte Geschwindigkeit an raumfesten Punkt:\n');
    fprintf('   u_x = %.8f \n', fP(1).U_ind(1) );
    fprintf('   u_y = %.8f \n', fP(1).U_ind(2) );
    fprintf('   u_z = %.8f \n', fP(1).U_ind(3) );
    fprintf('---------------------------------------------------------\n');
    fprintf('Position von Knoten 1 von Wirbelring 1:\n');
    fprintf('   x = %.4f \n', s(1,1) );
    fprintf('   y = %.4f \n', s(2,1) );
    fprintf('   z = %.4f \n', s(3,1) );
    fprintf('Induzierte Geschwindigkeit an Knoten 1 von Wirbelring 1:\n');
    fprintf('   u_x = %.8f \n', dsdt(1,1) );
    fprintf('   u_y = %.8f \n', dsdt(2,1) );
    fprintf('   u_z = %.8f \n', dsdt(3,1) );
    fprintf('---------------------------------------------------------\n');
end



% Animation: Position aller Wirbelrings im Verlauf der Zeit
if T > 0
    
    fig = figure;
    axis tight manual;
    
    N_frames = size(t,1);
    frames(N_frames) = struct('cdata',[],'colormap',[]);
    
    video = VideoWriter('Plot.avi');
    open(video);
    
    fig.Visible = 'on';

    for n_t = 1:N_frames
        
        s_end   = 0;
        
        for n_Wr = 1:N_Wr
            
            N_Seg   = Wr(n_Wr).N_Seg;
            s_start = s_end + 1;      % Beginn von n_Wr-tem Wirbelring in s
            s_end   = s_end + 3*N_Seg;  % Ende von n_Wr-tem Wirbelring in s
            s_Wr_n  = s(s_start:s_end, n_t);    % s von n_Wr-tem Wirbelring
            
            % ersten Knoten hinter letztem anhaengen, um geschlossene Linie
            % in Animation darzustellen
            s_plt = cat(1, s_Wr_n, s_Wr_n(1:3,:));
            
            % Wirbelring plotten
            plot3( s_plt(1:3:end), s_plt(2:3:end), s_plt(3:3:end), '.-')
            if n_Wr == N_Wr
                hold off
            else 
                hold on
            end
        end

        plt.EdgeColor = 'k';
        
        axis equal
        xlim([-2 10])
        ylim([-2 2])
        zlim([-2 2])
        xlabel('x / m')
        ylabel('y / m')
        zlabel('z / m')
        view([20 10])
        grid on
        set(gcf, 'Color', 'white');
        drawnow
        frames(n_t) = getframe(gcf);
        writeVideo(video, frames(n_t));
    end
    
    fig.Visible = 'off';
    close(video);
end



%% 
%##########################################################################
% Definition von Funktionen
%##########################################################################

%--------------------------------------------------------------------------
% Initialisierung der Wirbelringe Wr

function Wr = Init_Wr(Konfig, N_Wr)
% Konfig:   Konfigurationsparameter fuer alle Wirbelringe
% N_Kn:     Anzahl an Wirbelringen
    
    Wr(N_Wr) = struct();  % Wirbelringe, Deklaration als MATLAB-Struktur
    
    for n_Wr = 1:N_Wr % Schleife ueber alle Wirbelringe
        
        N_Seg = Konfig(n_Wr,2);   % Anzahl der Segmente pro Wirbelring
        N_Kn  = N_Seg;            % Anzahl Kn pro Wr = Anzahl Seg pro Wr
        
        Wr(n_Wr).N_Seg = N_Seg;
        Wr(n_Wr).Ga    = Konfig(n_Wr,3);  % Zirkulation Gamma
        Wr(n_Wr).WKM   = Konfig(n_Wr,4);  % Wirbelkernmodell
        
        % Anfangsbedingung fuer alle Knoten einer Wirbelrings
        % Knotenpunkte sind materielle bzw. LAGRANGEsche Punkte
        for n_Kn = 1:N_Kn
            Wr(n_Wr).Kn(n_Kn).x = Init_Knotenposition( Konfig(n_Wr,:), ...
                                                       n_Kn, N_Kn      );
        end
        
        % Volumina aller Segmente eines Wirbelrings
        for n_Seg = 1:N_Seg
            % x_A: Startpunkt des Segments
            x_A = Wr(n_Wr).Kn(n_Seg).x;
            
            % x_B: Endpunkt des Segments
            if n_Seg == N_Seg  % Startpunkt ist "letzter" Knoten
                % Endpunkt ist "erster" Knoten, um Wirbelring zu schliessen
                x_B = Wr(n_Wr).Kn(1).x;
            else
                x_B = Wr(n_Wr).Kn(n_Seg+1).x;
            end
            
            % Segmentvolumen
            Wr(n_Wr).Seg(n_Seg).Vol = Init_Segmentvolumen( ...
                                       Konfig(n_Wr,:), x_A, x_B );
        end
    end

end




%--------------------------------------------------------------------------
% Anfangsbedingung Knotenposition

function x = Init_Knotenposition(Konfig_Wr, n_Kn, N_Kn)
% Konfig_Wr:    Konfigurationsparameter fuer einen Wirbelring
% n_Kn:         aktueller Knoten
% N_Kn:         Anzahl an Knoten
    
    if Konfig_Wr(1) == 1  % Wirbelring mit Kreisform
        R = Konfig_Wr(5);        % Kreisradius
        
        x_MP = [Konfig_Wr(7);
                Konfig_Wr(8);
                Konfig_Wr(9)];   % Kreismittelpunkt
        
        n    = [Konfig_Wr(10);
                Konfig_Wr(11);
                Konfig_Wr(12)];  % Normaleneinheitsvektor
        
        [t1, t2] = SpannvektorenEbene(n);
        
        phi = 2*pi* (n_Kn-1)/N_Kn;  % Winkelkoordinate
        
        x = x_MP + R*cos(phi) * t1 + R*sin(phi) * t2 + 0;  % Knotenposition
    
    elseif Konfig_Wr(1) == 2  % Krakenwirbel
        
        % >>> TODO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        error('NotImplementedError')
    
    
    else  % Wirbelring mit anderer Form (kein Kreis)
        
        error('NotImplementedError')
    
    end
end



%--------------------------------------------------------------------------
% Aufspannende Vektoren einer Ebene aus Normalenvektor

function [t1, t2] = SpannvektorenEbene(n)
% n:    Normalenvektor der Ebene
    
    n = n / norm(n);  % normieren, falls noch kein Einheitsvektor
    
    % 1. Spannvektor (Tangenteneinheitsvektor) der Ebene
    if n(1) == 1
        t1 = [0;1;0];
    else
        t1 = cross(n, [1;0;0]);
        t1 = t1 / norm(t1);
    end
    
    % 2. Spannvektor (Tangenteneinheitsvektor) der Ebene
    t2 = cross(n,t1);
    t2 = t2 / norm(t2);

end



%--------------------------------------------------------------------------
% Anfangsbedingung Segmentvolumen

function Vol_Seg = Init_Segmentvolumen(Konfig_Wr, x_A, x_B)
% Konfig_Wr:    Konfigurationsparameter fuer einen Wirbelring
% x_A:          Startpunkt des Segments
% x_B:          Endpunkt des Segments
    
    % Kernradius konstant über gesamten Wirbelfaden
    R_Kern  = Konfig_Wr(6);       % Wirbelkernradius
    L       = norm(x_B - x_A);    % Laenge des Segments
    Vol_Seg = pi * R_Kern^2 * L;  % Segmentvolumen
    
end



%--------------------------------------------------------------------------
% Verteilung der zusaetzlichen, raumfesten EULER-Punkte (fP)

function fP = Init_fP(N_fP, fP_Verteilung, x_MP, L, v)
% N_fP:             Anzahl an festen Punkte
% fP_Verteilung:    Art der Punkteverteilung
% x_MP:             Mittelpunkt der Punkteverteilung
% L:                char. Laenge der Punkteverteilung
%                    - "Linie": Laenge der Linie
%                    - "Ebene": Kantenlaenge einer quadratischen Flaeche
% v:                char. Vektor der Punkteverteilung
%                    - "Linie": Richtungsvektor der Linie
%                    - "Ebene": Normalenvektor der Ebene
    
    v = v / norm(v);  % normieren, falls noch kein Einheitsvektor
    
    fP(N_fP) = struct();  % Deklaration als MATLAB-Struktur
    
    if fP_Verteilung == "Punkt" || N_fP == 1
        % einzelner Punkt
        
        fP(1).x = x_MP;
    
    elseif fP_Verteilung == "Linie"  
        % Punkte auf einer Linie in radialer Richtung, Laenge L
        
        x_A = x_MP - L/2 * v;  % Anfangspunkt der Linie
        x_B = x_MP + L/2 * v;  % Endpunkt der Linie
        
        for n_fP = 1:N_fP
            fP(n_fP).x = x_A + (n_fP-1)/(max(1, N_fP-1)) * (x_B - x_A);
        end
    
    elseif fP_Verteilung == "Ebene"  
        % Punkte in Ebene senkrecht zum Vektor v, Abmessung L*L
        
        if floor(sqrt(N_fP))^2 ~= N_fP
            error('N_fP muss eine Quadratzahl sein!')
        end
        
        [i,j] = meshgrid( L*(-0.5:1/(sqrt(N_fP)-1):0.5) );
        
        ij = [i(:), j(:)];
        
        [t1, t2] = SpannvektorenEbene(v);
        
        for n_fP = 1:N_fP
            fP(n_fP).x = x_MP + ij(n_fP,1) * t1 ...
                              + ij(n_fP,2) * t2;
        end
    end
    
end



%--------------------------------------------------------------------------
% Knotenpunkte aller Wirbelringe in Spaltenvektor s einsortieren

function s = x2s(s, Wr, N_Wr)
% s:        Spaltenvektor, Loesungsvektor
% Wr:       Wirbelringe
% N_Wr:     Anzahl an Wirbelringen
    
    q = 0;
    
    for n_Wr = 1:N_Wr
        
        N_Kn = Wr(n_Wr).N_Seg;
        
        for n_Kn = 1:N_Kn
            s( (q+1):(q+3) ) = Wr(n_Wr).Kn(n_Kn).x;
            q = q + 3;
        end
    end

end




%--------------------------------------------------------------------------
% Spaltenvektor s allen Knotenpositionen x der Wirbelringe zuordnen

function Wr = s2x(s, Wr, N_Wr)
% s:        Loesungsvektor
% Wr:       Wirbelringe
% N_Wr:     Anzahl an Wirbelringen
    
    n_Off = 0;  % Offset fuer den jeweils 1. Knoten eines Wr im Vektor s
    
    for n_Wr = 1:N_Wr
        N_Kn = Wr(n_Wr).N_Seg;
        
        for n_Kn = 1:N_Kn
            Wr(n_Wr).Kn(n_Kn).x = s( (n_Off+3*n_Kn-2):(n_Off+3*n_Kn) );
        end
        
        n_Off = n_Off + N_Kn*3;
    end

end



%--------------------------------------------------------------------------
% Rechte Seite der DGL

function [dsdt, Wr, fP] = rhs(t, s, Wr, N_Wr, fP, N_fP)
% t:        Zeit
% s:        Loesungsvektor
% s0:       Anfangswert s(t=0) = s0
% Wr:       Wirbelringe
% N_Wr:     Anzahl an Wirbelringen
% fP:       feste Punkte im Raum
% N_fP:     Anzahl an raumfesten Punkten

    fprintf('t = %0.3f s\n', t);
    
    
    % Loesungsvektor s allen Knotenpositionen x der Wirbelringe zuordnen
    Wr = s2x(s, Wr, N_Wr);
    
    
    % Assemblierung des Vektors dsdt: Schleifen ueber alle Kn aller Wr
    dsdt  = zeros( size(s) );  % Initialisierung
    n_Off = 0;  % Offset fuer den 1. Knoten eines Wr in s
    for n_Wr = 1:N_Wr
        N_Kn = Wr(n_Wr).N_Seg;
        
        for n_Kn = 1:N_Kn
            
            x_P = Wr(n_Wr).Kn(n_Kn).x;
            
            U_ind = Ind(x_P, Wr, N_Wr);
            
            dsdt( (n_Off+3*n_Kn-2):(n_Off+3*n_Kn) ) = U_ind;
            
            Wr(n_Wr).Kn(n_Kn).U_ind = U_ind;  % fuer Postprocessing
        end
        n_Off = n_Off + 3*N_Kn;
    end
    
    % Berechnung der induzierten Geschwindigkeit an zusaetzlichen Punkten
    % fuer Postprocessing
    for n_fP = 1:N_fP
        
        x_P = fP(n_fP).x;
        
        U_ind = Ind(x_P, Wr, N_Wr);
        
        fP(n_fP).U_ind = U_ind;
    end
    

end



%--------------------------------------------------------------------------
% Induzierte Geschwindigeit auf x_P von allen Segmenten aller Wirbelringe

function U_ind = Ind(x_P, Wr, N_Wr)
% x_P:      Punkt, an dem induzierte Geschwindigkeit berechnet werden soll
% Wr:       Wirbelringe
% N_Wr:     Anzahl an Wirbelringen
    
    U_ind = 0;
    
    for n_Wr = 1:N_Wr
        N_Seg = Wr(n_Wr).N_Seg;
        
        for n_Seg = 1:N_Seg
            % x_A: Startpunkt des Segments
            x_A = Wr(n_Wr).Kn(n_Seg).x;
            
            % x_B: Endpunkt des Segments
            if n_Seg == N_Seg            % Startpunkt ist "letzter" Knoten
                x_B = Wr(n_Wr).Kn(1).x;  % Endpunkt ist "erster" Knoten
            else
                x_B = Wr(n_Wr).Kn(n_Seg+1).x;
            end
            
            Ga      = Wr(n_Wr).Ga;              % Zirkulation 
            Vol_Seg = Wr(n_Wr).Seg(n_Seg).Vol;  % Segmentvolumen
            WKM     = Wr(n_Wr).WKM;             % Wirbelkernmodell
            
            % --------------Biot-Savart-Gesetz-----------------------------
            U_ind = U_ind + BiotSavart(x_A, x_B, x_P, Ga, Vol_Seg, WKM);
            % -------------------------------------------------------------
        end
    end

end



%--------------------------------------------------------------------------
% Biot-Savart-Gesetz

function U_ind_Seg = BiotSavart(x_A, x_B, x_P, Ga, Vol_Seg, WKM)
% x_A:      Startpunkt des Segments
% x_B:      Endpunkt des Segments
% x_P:      Punkt mit induzierter Geschwindigkeit
% Ga:       Zirkulation Gamma
% Vol_Seg:  Volumen des Segments (zeitlich konstant)
% WKM:      Nummer des zu verwendenen Wirbelkernmodells
    
    r_AP = x_P - x_A;  % Verbindungsvektor von Segmentendunkt A zu Punkt P
    r_BP = x_P - x_B;  % Verbindungsvektor von Segmentendunkt B zu Punkt P
    r_AB = x_B - x_A;  % Verbindungsvektor von A nach B
    
    L_AP = norm(r_AP);  % Laenge des Vektors r_AP
    L_BP = norm(r_BP);  % Laenge des Vektors r_BP
    L_AB = norm(r_AB);  % Laenge des Vektors r_AB
    
    if or( L_AP==0, L_BP==0 )  % Punkt P liegt auf Segment
        U_ind_Seg = [0;0;0];
    
    else  % Punkt P liegt nicht auf Segment
        
        % Richtung der induzierten Geschwindigkeit:
        % Einheitsvektor e senkrecht zur Ebene des Dreiecks ABP
        e = cross(r_AB/L_AB, r_AP/L_AP);
        e = e / norm(e);
        
        % Cosinus von Dreiecks-Innenwinkel bei Punkt A
        cosA = dot(r_AB,r_AP) / (L_AB*L_AP);
        
        % Cosinus von Aussenwinkel bei Punkt B
        cosB = dot(r_AB,r_BP) / (L_AB*L_BP);
        
        % Hoehe h des Dreiecks ABP
        h = L_AP * sin( acos(cosA) );
        %h = norm( cross(r_AP,r_AB) ) / L_AB;  % Alternative
        
        % Distanz d zwischen Segment und Punkt P
        % >>> TODO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        % Wirbelkernradius
        R_Kern = sqrt( Vol_Seg / (pi*L_AB) );
        
        % Wirbelkernmodell
        if WKM == 0      % Cut-Off (kein Wirbelkern)
            Mod = 1;
        
        else
            % >>> TODO <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            error('NotImplementedError')
        end
        
        %-----Biot-Savart-Gl. fuer geraden, endlich langen Wirbelfaden-----
        U_ind_Seg = Ga/(4*pi*h) *Mod* (cosA - cosB) * e;
        %------------------------------------------------------------------
        
        % Korrektur, falls P auf Geraden durch A und B liegt
        if h < 10e-12
            U_ind_Seg = [0;0;0];
        end
    end
end
