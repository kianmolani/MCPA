%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     NOTE: The professor stated that it wasn't necessary to simulate
%     across more than one electron. As I thought that doing so would not 
%     provide me with any new insights, I decided to use only 1 electron
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear
close all

%% initialize parameters and calculate force and acceleration

x = 0; % initial electron position
v = 0; % initial electron velocity

E = 10e6; % electric field through wire (assumed constant)
q = 1.60217662e-19;
F = q*E;
m = 9.10938356e-31;
a = F/m; % constant e-field implies constant force implies constant acceleration

%% plot velocity and position as a function of time w/o scattering

t = linspace(0,60,100); % 60 seconds
[v,x] = vel(a,t);

figure; hold on; grid on; 
xlim([t(1) t(end)]); xlabel('Time (s)');
yyaxis left; ylim([x(1) x(end)]); ylabel('Distance (m)');
yyaxis right; ylim([v(1) v(end)]); ylabel('Velocity (m/s)');

for i=2:length(t)
    yyaxis left
    plot([t(i-1) t(i)],[x(i-1) x(i)],'r-');
    yyaxis right
    plot([t(i-1) t(i)],[v(i-1) v(i)],'b-');
    drawnow limitrate
    pause(0.01);
end

%% plot velocity and position as a function of time w/ scattering

t = 0; v = 0; x = 0;
t = linspace(0,10,100); % 10 seconds
[v,x] = vel(a,t);

modes = ["constant", "custom"]; % constant or custom probability of scattering
mode_active = modes(2);

const_scatter_prob = 0.05; % scattering probability in "constant" mode
custom_scatter_prob = 0; % scattering probability in "custom" mode
tao = 3; % for "custom" mode scattering

figure; 
subplot(2,1,1); hold on; grid on; xlabel('Time (s)'); ylabel('Velocity (m/s)');
subplot(2,1,2); hold on; grid on; xlabel('Time (s)'); ylabel('Distance (m)');


j = 1; x_new = x; v_new = 0; t_since_scatter = 0; 
v_avg = 0; t_diff = diff(t); t_diff = t_diff(1);

for i=2:length(t)
    if (mode_active == "constant")
        if ( rand() < const_scatter_prob )
            subplot(2,1,1);
            x_new = x + x_new;
            line([t(i-1) t(i-1)],[0 v(j)],'Color','blue') % connect discontinuities
            j = 2;  
        else
            j = j + 1;
        end     
    else
        if ( rand() < ( 1 - exp( - t_since_scatter / tao ) ) ) 
            t_since_scatter = 0;
            x_new = x + x_new(j);
            subplot(2,1,1);
            line([t(i-1) t(i-1)],[0 v(j)],'Color','blue')
            j = 2;    
        else
            t_since_scatter = t_since_scatter + t_diff;
            j = j + 1;
        end
    end

    v_new(i) = v(j);
    v_avg(i) = mean(v_new); % calculated drift velocity
    
    subplot(2,1,1);
    plot([t(i-1) t(i)],[v(j-1) v(j)],'b-');
    plot([t(i-1) t(i)],[v_avg(i-1) v_avg(i)],'r-');
    title('')
    title(append('v_d = ',num2str(v_avg(i),5)," m/s"));
    subplot(2,1,2);
    plot([t(i-1) t(i)],[x_new(j-1) x_new(j)],'r-');
    drawnow limitrate
    pause(0.1);
end

subplot(2,1,1);
legend('Velocity','Drift Velocity');


