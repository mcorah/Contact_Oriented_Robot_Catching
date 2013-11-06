%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RPI-MATLAB-Simulator
% http://code.google.com/p/rpi-matlab-simulator/
%

function sim = trackPosition( sim )

    body = sim.bodies(2);   % The body for which we'll plot the energy
    
    trans=sim.userData.trans;
    u=trans*body.u;
    [k th]=R2kth(trans*qt2rot(body.quat));
    % Energies 
    
    if sim.step == 1
        % On the first time step, the plot doesn't exist yet, so we'll create it.
        figure(); 
        sim.userData.U=[u(1);u(2);th]
        sim.userData.mytime=sim.time;
        sim.userData.Ux = plot(sim.userData.mytime,sim.userData.U(1));  
        hold on;      % Always remember hold on!
        sim.userData.Uy = plot(sim.userData.mytime,sim.userData.U(2),'r');  
        sim.userData.Uth = plot(sim.userData.mytime,sim.userData.U(3),'g');  
        xlabel('Time (s)'); 
        ylabel('Position (m)');
        legend('X','Y', 'Theta',2);
    else
        sim.userData.U=[sim.userData.U [u(1);u(2);th]];
        sim.userData.mytime=[sim.userData.mytime sim.time];
        % After the first time step the plots exists, so we'll just update
        % their X and Y data.  
        set(sim.userData.Ux,'xdata',sim.userData.mytime);
        set(sim.userData.Uy,'xdata',sim.userData.mytime);
        set(sim.userData.Uth,'xdata',sim.userData.mytime);
        set(sim.userData.Ux,'ydata',sim.userData.U(1,:)); 
        set(sim.userData.Uy,'ydata',sim.userData.U(2,:)); 
        set(sim.userData.Uth,'ydata',sim.userData.U(3,:)); 
    end
end

