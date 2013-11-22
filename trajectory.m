%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RPI-MATLAB-Simulator
% http://code.google.com/p/rpi-matlab-simulator/
%

function sim = trajectory ()

    % Ramp
    incline = pi/12; 

    sim = Simulator(.01);
    sim.MAX_STEP = 10e3;
    %sim.H_dynamics = @mLCPdynamics;
    sim.H_dynamics = @LCPdynamics;
    sim.num_fricdirs = 8;
    %sim.FRICTION = false; 
    sim.userFunction = @manageSim;
    %sim.userFunction = @trackPosition; 
    sim.userData.trans=rot([1;0;0],-incline);
    sim.userData.init_tracking=1;
    sim.userData.stage=0;
    %sim.userData.handInit=[0;-0.8;0.035];
    sim.userData.handInit=[0;-0.8;0.045];
    
    %Ramp
    ramp = mesh_rectangularBlock(2,2,0.1); 
        ramp.dynamic = false; 
        ramp.color = [.7 .5 .5];
        ramp.mu = 0.5;
        ramp.u = [0; 0; -0.05/cos(incline)]; 
        ramp.quat = qt([1 0 0],incline);
    
    % Block
    %block = mesh_rectangularBlock(0.3,0.2,0.14);
    block = mesh_rectangularBlock(0.35,0.35,0.14);
        block.color = [.3 .6 .5];
        block.quat = ramp.quat; 
        block.u = qtrotate(block.quat,[0;0.5;0.09]);
        dir=rand(1)*pi
        block.nu=[qtrotate(block.quat,qtrotate(qt([0 0 1],dir),[-6*rand(1);0;0]))
                  qtrotate(block.quat,[0;0;2*pi*rand(1)])];
    sim.userData.uInit=block.u;
    sim.userData.nuInit=block.nu;
    sim.userData.quatInit=block.quat;

    % Finger
    finger=mesh_cylinder(9,20,0.05,0.07);
        %finger.dynamic=false
        finger.dynamic=true
        finger.color=[0.1 0.2 0.3];
        finger.quat=block.quat;
        %finger.u=qtrotate(block.quat,[0;1.1;0.035]);
        finger.u=sim.userData.trans'*sim.userData.handInit;
    % Add bodies to simulator
    sim = sim_addBody(sim, [ramp block finger]);
    
    % Run the simulator
    sim = sim_run( sim );
    eq1=print_array(sim.userData.mytime,sim.userData.U(1,:))
    eq2=print_array(sim.userData.mytime,sim.userData.U(2,:))
    eq3=print_array(sim.userData.mytime,sim.userData.U(3,:))
end



