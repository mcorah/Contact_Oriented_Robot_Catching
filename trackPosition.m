%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RPI-MATLAB-Simulator
% http://code.google.com/p/rpi-matlab-simulator/
%

function sim = trackPosition( sim )

    body = sim.bodies(2);   % block
    finger = sim.bodies(3);   % finger
    
    trans=sim.userData.trans;
    u=trans*(body.u+qtrotate(body.quat,[0;-0.35;0]));
    [k th]=R2kth(trans*qt2rot(body.quat));
    u2=trans*finger.u;
    [k th2]=R2kth(trans*qt2rot(finger.quat));
    % Energies 
    
    if sim.userData.init_tracking==1;
      % On the first time step, the plot doesn't exist yet, so we'll create it.
      sim.userData.init_tracking=0;
      %figure(); 
      sim.userData.U=[u(1);u(2);th];
      sim.userData.U2=[u2(1);u2(2);th2];
      sim.userData.mytime=sim.time;

      %%figure();
      %%sim.userData.Ux = plot(sim.userData.mytime,sim.userData.U(1));  
      %%hold on;      % Always remember hold on!
      %%sim.userData.Uy = plot(sim.userData.mytime,sim.userData.U(2));  
      %sim.userData.Uth = plot(sim.userData.mytime,sim.userData.U(3),'g');  
      %%sim.userData.U2x = plot(sim.userData.mytime,sim.userData.U2(1),'g');  
      %%sim.userData.U2y = plot(sim.userData.mytime,sim.userData.U2(2),'g');  
      %%xlabel('Time (s)'); 
      %%ylabel('Position (m)');
      %%legend('X','Y', 'X2', 'Y2',2);
    else
      sim.userData.U=[sim.userData.U [u(1);u(2);th]];
      sim.userData.U2=[sim.userData.U2 [u2(1);u2(2);th2]];
      sim.userData.mytime=[sim.userData.mytime sim.time];
      % After the first time step the plots exists, so we'll just update
      % their X and Y data.  
      %%set(sim.userData.Ux,'xdata',sim.userData.mytime);
      %%set(sim.userData.Uy,'xdata',sim.userData.mytime);
      %%set(sim.userData.U2x,'xdata',sim.userData.mytime);
      %%set(sim.userData.U2y,'xdata',sim.userData.mytime);
      %set(sim.userData.Uth,'xdata',sim.userData.mytime);
      %%set(sim.userData.Ux,'ydata',sim.userData.U(1,:)); 
      %%set(sim.userData.Uy,'ydata',sim.userData.U(2,:)); 
      %%set(sim.userData.U2x,'ydata',sim.userData.U2(1,:)); 
      %%set(sim.userData.U2y,'ydata',sim.userData.U2(2,:)); 
      %set(sim.userData.Uth,'ydata',sim.userData.U(3,:)); 
    end
end

