%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RPI-MATLAB-Simulator
% http://code.google.com/p/rpi-matlab-simulator/
%

function sim = sliding_block ()

    % Ramp
    incline = pi/12; 

    sim = Simulator(.01);
    sim.MAX_STEP = 60;
    %sim.H_dynamics = @mLCPdynamics;
    sim.H_dynamics = @LCPdynamics;
    sim.num_fricdirs = 8;
    %sim.FRICTION = false; 
    sim.userFunction = @trackPosition; 
    sim.userData.trans=rot([1;0;0],-incline)
    
    ramp = mesh_rectangularBlock(2,2,0.1); 
        ramp.dynamic = false; 
        ramp.color = [.7 .5 .5];
        ramp.mu = 0.5;
        ramp.u = [0; 0; -0.05/cos(incline)]; 
        ramp.quat = qt([1 0 0],incline);
    
    % Block
    block = mesh_rectangularBlock(0.3,0.2,0.05);
        block.color = [.3 .6 .5];
        block.quat = ramp.quat; 
        block.u = [0; 0; 0.025/cos(incline)];  qtrotate(block.quat,[0;.5;0]); 
        block.u = block.u + 0.5*qtrotate(block.quat,[0;1;0]);
        dir=rand(1)*pi
        block.nu=[qtrotate(block.quat,qtrotate(qt([0 0 1],dir),[-6*rand(1);0;0]))
                  qtrotate(block.quat,[0;0;2*pi*rand(1)])];
    % Add bodies to simulator
    sim = sim_addBody(sim, [ramp block]);
    
    % Run the simulator
    sim = sim_run( sim );
    eq1=print_array(sim.userData.mytime,sim.userData.U(1,:))
    eq2=print_array(sim.userData.mytime,sim.userData.U(2,:))
    eq3=print_array(sim.userData.mytime,sim.userData.U(3,:))
end



