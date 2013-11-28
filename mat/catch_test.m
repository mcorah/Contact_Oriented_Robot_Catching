%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RPI-MATLAB-Simulator
% http://code.google.com/p/rpi-matlab-simulator/
%

function sim = catch_test ()

    sim = Simulator(.01);
    sim.MAX_STEP = 150;
    %sim.H_dynamics = @mLCPdynamics;
    sim.H_dynamics = @LCPdynamics;
    sim.num_fricdirs = 8;
    %sim.FRICTION = false; 
    %sim.userFunction = @plotEnergy; 
    
    % Ramp
    incline = pi/12; 
    ramp = mesh_rectangularBlock(2,2,0.1); 
        ramp.dynamic = false; 
        ramp.color = [.7 .5 .5];
        ramp.mu = 0.5;
        ramp.u = [0; 0; -0.05/cos(incline)]; 
        ramp.quat = qt([1 0 0],incline);
    
    % Block
    block = mesh_rectangularBlock(0.3,0.2,0.14);
        block.color = [.3 .6 .5];
        block.quat = ramp.quat; 
        %block.u = [0; 0; 0.025/cos(incline)];%  qtrotate(block.quat,[0;.5;]); 
        block.u = qtrotate(block.quat,[0;0.5;0.07]);
        dir=rand(1)*pi/2+pi/4;
        block.nu=[qtrotate(block.quat,qtrotate(qt([0 0 1],dir),[-5*0*rand(1);0;0]))
                  qtrotate(block.quat,[0;0;2*pi*rand(1)])];
    finger=mesh_cylinder(9,1,0.05,0.07);
        finger.dynamic=false
        finger.color=[0.1 0.2 0.3];
        finger.quat=ramp.quat;
        finger.u=block.u+qtrotate(block.quat,qtrotate(qt([0 0 1],rand(1)*pi/2+dir-pi/4),[-0.3;0;-0.035]));
    
    % Add bodies to simulator
    sim = sim_addBody(sim, [ramp block finger]);
    
    % Run the simulator
    sim = sim_run( sim );

end



