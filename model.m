%% parametri
M = 0.5;    % masa kolica
m = 0.2;    % masa stapa koji balansira
b = 0.1;    % koeficijent trenja
I = 0.006;  % moment inercije
g = 9.8;    % gravitaciono ubrzanje
l = 0.3;    % duzina stapa

p = I*(M+m)+M*m*l^2; %denominator for the A and B matrices

%% model u prostoru stanja
A = [0      1              0           0;
     0 -(I+m*l^2)*b/p  (m^2*g*l^2)/p   0;
     0      0              0           1;
     0 -(m*l*b)/p       m*g*l*(M+m)/p  0];
B = [     0;
     (I+m*l^2)/p;
          0;
        m*l/p];
C = [1 0 0 0;
     0 0 1 0];
D = [0;
     0];
 
 %% definisanje sistema u prostoru stanja
states = {'x' 'x_dot' 'theta' 'theta_dot'};
inputs = {'u'};
outputs = {'x'; 'theta'};

sys_ss = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs)
sys_tf = tf(sys_ss);

%% lqr
ro = 1
R = 2       % definise cost function za upravljanje
Q = ro * (C'* C)   % definise cost function za model
% Q[0][0] definise tezinu parametra pozicije, a Q[2][2] definise tezinu
% parametra ugla teta
Q(1,1) = 10;
Q(3,3) = 50;
K = lqr(A, B, Q, R);

%% novi model
A_new = [(A - B*K)];
B_new = [B];
C_new = [C];
D_new = [D];

states = {'x' 'x_dot' 'theta' 'theta_dot'};
inputs = {'u'};
outputs = {'x'; 'theta'};
sys_ss_new = ss(A_new,B_new,C_new,D_new,'statename',states,'inputname',inputs,'outputname',outputs)

%% simulacija
t = 0:0.01:5;
step = 12*ones(size(t));

[y, t, x] = lsim(sys_ss_new, step, t);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2).*(180/pi),'plot');
set(get(AX(1),'Ylabel'),'String','pozicija x (m)')
set(get(AX(2),'Ylabel'), 'String','ugao teta (deg)')
title('Step pobuda sa LQR Controlom')