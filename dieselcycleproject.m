%% 
%% IDEAL DIESEL CYCLE – CLEAN VERSION
clear; clc; close all;

disp('---------------------------------------')
disp('         DESIGN DIESEL CYCLE           ')
disp('---------------------------------------')
disp('  ENTER ENGINE PARAMETERS AND PRESS OK ')
disp('---------------------------------------')

%% 1. ENGINE GEOMETRY
pause(1);
eng = inputdlg({ ...
    'Cylinder Bore Diameter (mm):', ...
    'Cylinder Stroke Length (mm):', ...
    'Number of Cylinders:'}, ...
    'ENGINE PARAMETERS', [1 40; 1 40; 1 40]);

if any(cellfun(@isempty, eng))
    errordlg('Empty engine parameter. Please retry.','ERROR');
    return;
end

Dmm   = str2double(eng{1});      % mm
Lmm   = str2double(eng{2});      % mm
ncyl  = str2double(eng{3});

% Per-cylinder swept volume (m^3)
D  = Dmm/1000;                    % m
L  = Lmm/1000;                    % m
Vs = pi/4*D^2*L;                  % m^3
fprintf('Swept volume per cylinder: %.6f m^3\n', Vs);

%% 2. INITIAL CONDITIONS
clc;
disp('--------------')
disp(' NOTE: 1 bar = 100000 Pa')
disp(' NOTE: Temperature input in degree Celsius')
disp('---------------------------------')
disp(' Compression ratio  = V1/V2')
disp(' Cut-off ratio      = V3/V2')
disp('-------------------------------')

pause(1);
cnd = inputdlg({ ...
    'Atmospheric Pressure (bar):', ...
    'Initial Temperature (°C):', ...
    'Compression Ratio:', ...
    'Cut-off Ratio:'}, ...
    'INITIAL PARAMETERS',[1 40; 1 40; 1 40; 1 40]);

if any(cellfun(@isempty, cnd))
    errordlg('Empty initial condition. Please retry.','ERROR');
    return;
end

p1_bar = str2double(cnd{1});
T1_C   = str2double(cnd{2});
cr     = str2double(cnd{3});
a      = str2double(cnd{4});     % cut-off ratio

if p1_bar <= 0
    errordlg('Pressure must be > 0','ERROR'); return;
end
if cr < 14 || cr > 23
    errordlg('Compression ratio should be between 14 and 23','ERROR'); return;
end
if a <= 1
    errordlg('Cut-off ratio must be > 1','ERROR'); return;
end

%% 3. CONSTANTS
p1 = p1_bar*1e5;          % Pa
T1 = T1_C + 273.15;       % K

R  = 0.287;               % kJ/kg·K
cv = 0.718;               % kJ/kg·K
cp = cv + R;              % kJ/kg·K
gamma = cp/cv;

%% 4. VOLUMES AT STATES
V2 = Vs/(cr-1);           % clearance volume
V1 = Vs + V2;             % total volume at start of compression

% State 1
P1 = p1;   V1s = V1;   T1s = T1;

% State 2 – end compression (adiabatic)
V2s = V2;
P2 = P1*cr^gamma;
T2 = T1*cr^(gamma-1);

% State 3 – end heat addition at constant pressure
V3s = a*V2s;
P3  = P2;
T3  = a*T2;

% State 4 – end expansion (adiabatic back to V1)
V4s = V1s;
P4  = P3*(V3s/V4s)^gamma;
T4  = T3*(V3s/V4s)^(gamma-1);

%% 5. EFFICIENCY & WORK PER kg (air-standard)
eta   = 1 - (1/(cr^(gamma-1)))*((a^gamma - 1)/(gamma*(a-1)));
etapc = eta*100;

Qin   = cp*(T3 - T2);        % kJ/kg
Wnet  = eta*Qin;             % kJ/kg

fprintf('\n--- CYCLE RESULTS PER kg OF AIR ---\n');
fprintf('Thermal efficiency  = %.2f %%\n', etapc);
fprintf('Net work output     = %.2f kJ/kg\n', Wnet);

msgbox({ ...
    ['Thermal efficiency (%) = ', num2str(etapc)], ...
    ['Net work (kJ/kg)       = ', num2str(Wnet)], ...
    ['Compression ratio      = ', num2str(cr)], ...
    ['Cut-off ratio          = ', num2str(a)]}, ...
    'CYCLE SUMMARY');

%% 6. P–V DATA FOR PLOTTING
% compression 1–2
V_12 = linspace(V1s, V2s, 100);
P_12 = P1*(V1s./V_12).^gamma;

% constant-pressure 2–3
V_23 = linspace(V2s, V3s, 100);
P_23 = P2*ones(size(V_23));

% expansion 3–4
V_34 = linspace(V3s, V4s, 100);
P_34 = P3*(V3s./V_34).^gamma;

% constant-volume 4–1
V_41 = [V4s V1s];
P_41 = [P4  P1];

%% 7. FIGURE 1 – P–V & η vs CR
figure(1);

% ---- P–V diagram ----
subplot(2,1,1);
plot(V_12, P_12, 'LineWidth', 2); hold on;
plot(V_23, P_23, 'LineWidth', 2);
plot(V_34, P_34, 'LineWidth', 2);
plot(V_41, P_41, 'LineWidth', 2);
hold off; grid on;
xlabel('Volume (m^3)');
ylabel('Pressure (Pa)');
title('Ideal Diesel Cycle – P–V Diagram');
legend('1-2 Compression','2-3 Heat add (P=const)', ...
       '3-4 Expansion','4-1 Heat rejection (V=const)', ...
       'Location','best');

% ---- Efficiency vs compression ratio (a fixed) ----
cr_vec = linspace(14,23,30);
eta_cr = 1 - (1./(cr_vec.^(gamma-1))) .* ((a^gamma - 1)./(gamma*(a-1)));
eta_cr = eta_cr*100;

subplot(2,1,2);
plot(cr_vec, eta_cr,'LineWidth',2);
grid on;
xlabel('Compression ratio');
ylabel('Efficiency (%)');
title(['Efficiency vs Compression ratio  (a = ',num2str(a),')']);

%% 8. FIGURE 2 – Efficiency vs Cut-off ratio
figure(2);
a_vec = linspace(1.1, a+3, 30);
eta_a = 1 - (1./(cr^(gamma-1))) .* ((a_vec.^gamma - 1)./(gamma*(a_vec-1)));
eta_a = eta_a*100;

plot(a_vec, eta_a,'LineWidth',2);
grid on;
xlabel('Cut-off ratio');
ylabel('Efficiency (%)');
title(['Efficiency vs Cut-off ratio  (CR = ',num2str(cr),')']);

