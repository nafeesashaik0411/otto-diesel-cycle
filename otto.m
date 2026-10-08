% Otto Cycle Analysis – Efficiency and P–V Diagram
clear; clc;

% ------------------ HEADER ------------------
disp('---------------------------------------')
disp('          DESIGN OTTO CYCLE            ')
disp('---------------------------------------')
disp('  ENTER ENGINE PARAMETERS AND PRESS OK ')
disp('---------------------------------------')

pause(2);

% --------- INPUT DIALOG FOR ENGINE PARAMETERS ---------
inputeng = inputdlg({ ...
    'Compression ratio of the Otto cycle', ...
    'Pressure at the entry in the cylinder (in pascals)', ...
    'Temperature at the entry in cylinder (in kelvin)', ...
    'Heat added at constant volume (in J/kg)'}, ...
    'ENGINE PARAMETERS', [1 50; 1 50; 1 50; 1 50]);

% Checking for missing input
for i = 1:4
    if isempty(inputeng{i})
        msgbox('AN EMPTY PARAMETER INPUT FOUND. Please Retry', ...
               'ERROR', 'error');
        clc
        return
    end
end

% --------- EXTRACT AND CONVERT INPUTS ---------
r  = str2double(inputeng{1});   % compression ratio
p1 = str2double(inputeng{2});   % inlet pressure (Pa)
t1 = str2double(inputeng{3});   % inlet temperature (K)
h1 = str2double(inputeng{4});   % heat added at constant volume (J/kg)

% --------- CONSTANTS ---------
Cv = 718;        % J/(kg·K)  specific heat at constant volume
g  = 1.4;        % gamma
R  = 287;        % J/(kg·K)  gas constant for air

% --------- STATE POINT CALCULATIONS ---------
v1 = (R * t1) / p1;
v2 = v1 / r;

p2 = p1 * r^g;
t2 = t1 * r^(g-1);

v3 = v2;
t3 = t2 + (h1 / Cv);
p3 = p2 * (t3 / t2);

v4 = v1;
p4 = p3 / r^g;
t4 = t3 / r^(g-1);

% Ideal efficiency, heat rejected, net work
eff      = 1 - 1 / (r^(g-1));     % theoretical Otto efficiency (fraction)
heatrej  = Cv * (t4 - t1);
workdone = h1 - heatrej;

% --------- RESULT POP-UP ---------
OUTPUT = msgbox({ ...
    ['T1 = ', num2str(t1)], ...
    ['T2 = ', num2str(t2)], ...
    ['T3 = ', num2str(t3)], ...
    ['T4 = ', num2str(t4)], ...
    ['P1 = ', num2str(p1)], ...
    ['P2 = ', num2str(p2)], ...
    ['P3 = ', num2str(p3)], ...
    ['P4 = ', num2str(p4)], ...
    ['Theoretical efficiency of the cycle = ', num2str(eff)], ...
    ['Heat rejected in this cycle = ', num2str(heatrej)], ...
    ['Net work done in this cycle = ', num2str(workdone)], ...
    'Click OK to Continue'}, ...
    'RESULT', 'help');

disp(' To view plots, press OK in the RESULT window ');
uiwait(OUTPUT);     % wait until user presses OK

%% --------- P–V DIAGRAM FOR THIS OTTO CYCLE ---------
V = [v1 v2 v3 v4 v1];
P = [p1 p2 p3 p4 p1];

figure;
plot(V, P, '-o', 'LineWidth', 2);
xlabel('Specific Volume');
ylabel('Pressure');
title('Ideal Otto Cycle – P–V Diagram');
grid on;

%% --------- EFFICIENCY VS COMPRESSION RATIO ---------
r_vec = 1:1:10;
eta_vec = (1 - 1 ./ (r_vec).^(g-1)) * 100;

figure;
plot(r_vec, eta_vec, '--', 'LineWidth', 3);
xlabel('Compression ratio');
ylabel('Efficiency (%)');
title('Otto Cycle – Theoretical Efficiency vs Compression Ratio');
grid on;
