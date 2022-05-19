% sistem posle LQR

alpha = 6;

%% sistem
sistem = @(t, x, T) T*[x(2)
                4.0656*x(1)+4.9155*x(2)-38.8818*x(3)-7.6185*x(4)-1.8182*(1.8182*x(6)+4.5455*x(8))
                x(4)
                10.1639*x(1)+12.2888*x(2)-72.7044*x(3)-19.0462*x(4)-4.5455*(1.8182*x(6)+4.5455*x(8))
                -(4.0656*x(6)+10.1639*x(8))      % odavde krecu p-ovi
                -(1.0000*x(5)+4.9155*x(6)+12.2888*x(8))
                -(-38.8818*x(6)-72.7044*x(8))
                -(-7.6185*x(6)+1.0000*x(7)-19.0462*x(8))];    
    
%% granicni uslovi
granicni_uslovi = @(x_0,x_T, T) [x_0(1)       % klatno krece od nule
                            x_0(2)           % bez pocetne brzine
                            x_0(3)       % uzmimo da klatno stoji pravo na pocetku. Da je pod uglom od 0.1rad pisali bismo x_0(3)-0.1
                            x_0(4)       % i da nema pocetno ugaono ubrzanje
                            x_T(1)-6     % uzmimo da je krajnja pozicija 6
                            x_T(2)       % i da nece imati brzinu u tom trenutku
                            x_T(3)       % nije nam bitno pod kojim uglom ce se zaustaviti
                            x_T(8)       % .. kao ni koju ce ugaonu brzinu imati
                            0.5*(1.818*x_T(6)+4.5455*x_T(8))^2+alpha+x_T(5)*x_T(2)+x_T(6)*(4.0656*x_T(1)+4.9155*x_T(2)-38.8818*x_T(3)-7.6185*x_T(4)-1.8182*(1.8182*x_T(6)+4.5455*x_T(8)))+x_T(7)*x_T(4)+x_T(8)*(10.1639*x_T(1)+12.2888*x_T(2)-72.7044*x_T(3)-19.0462*x_T(4)-4.5455*(1.8182*x_T(6)+4.5455*x_T(8)))];

%% simulacija
tacke = linspace(0,1,1250);
pocetno_pogadjanje = [0;0.1;0.2;0.3;0.4;0.8;0.9;1];
pocetno_pogadjanje_T = 3;

solinit = bvpinit(tacke, pocetno_pogadjanje, pocetno_pogadjanje_T);       % time is not fixed
sol = bvp4c(sistem, granicni_uslovi, solinit);

opt_upravljanje = - (1.818.*sol.y(6,:) + 4.545.*sol.y(8,:))
time = sol.parameters*sol.x;

%% ispis
figure;
plot(time, sol.y(1,:))          % promena pozicije
title('x');
figure;
plot(time, sol.y(3,:).*(180/pi))% promena ugla
title('teta_{deg}')
figure;
plot(time, opt_upravljanje);
title('u');

[y, t, x] = lsim(sys_ss_new, opt_upravljanje, time);
[AX,H1,H2] = plotyy(t,y(:,1),t,y(:,2).*(180/pi),'plot');
set(get(AX(1),'Ylabel'),'String','pozicija x (m)')
set(get(AX(2),'Ylabel'), 'String','ugao teta (deg)')
title('Optimalno upravljanje od 0m do 6m')

