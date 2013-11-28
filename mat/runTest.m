function [path,time]=runTest(block_u, block_nu, hand_control)

  %%%%%%%%%%%%%%%%%%%%
  %Basic initialization steps
  %%%%%%%%%%%%%%%%%%%%
  sim=Simulator(0.00125);
  sim.MAX_STEP=2000;
  sim.interactive=false;
  sim.draw=true;
  sim.figure=1;
  %sim.draw=true;
  sim.H_dynamics = @mLCPdynamics;
  %sim.H_dynamics = @LCPdynamics;

  incline = pi/12; 
  sim.userData.trans=rot([1;0;0],-incline);
  sim.num_fricdirs = 8;

  %sim.FRICTION = false; 
  sim.userFunction = @manageTest;
  sim.userData.init_tracking=1;
  sim.userData.handInit=[hand_control(1,1);hand_control(1,2);0.045];
  sim.userData.block_u=block_u;
  sim.userData.block_nu=block_nu;
  %This will become the basis for the return value
  sim.userData.path=[];
  sim.userData.time=[];

  %hand control is a row of polynomials that describe
  %hand configuration as a function of time
  sim.userData.hand_control=hand_control;
  sim.userData.hand_vel=derivPoly(sim.userData.hand_control);
  
  %everything represented in the frame of the plane
  %this is much easier to deal with
  sim.gravityVector=sim.userData.trans*[0;0;-9.81];

  %%%%%%%%%%%%%%%%%%%%
  %Description of bodies, less general
  %%%%%%%%%%%%%%%%%%%%
  
  %Ramp
  ramp = mesh_rectangularBlock(2,2,0.1); 
      ramp.dynamic = false; 
      ramp.color = [.7 .5 .5];
      ramp.mu = 0.5;
      ramp.u = [0; 0; -0.05]; 
      ramp.quat = qt([1 0 0],0);
    
  % Block
  %block = mesh_rectangularBlock(0.3,0.2,0.14);
  block = mesh_rectangularBlock(0.35,0.35,0.14);
      block.color = [.3 .6 .5];
      block.quat = ramp.quat; 
      block.u =block_u;
      block.nu=block_nu;

  %sim.userData.uInit=block.u;
  %sim.userData.nuInit=block.nu;
  %sim.userData.quatInit=block.quat;
  
  % Finger
  finger=mesh_cylinder(9,80,0.05,0.07);
      %finger.dynamic=false
      finger.dynamic=true;
      finger.color=[0.1 0.2 0.3];
      finger.quat=block.quat;
      %finger.u=qtrotate(block.quat,[0;1.1;0.035]);
      finger.u=sim.userData.handInit;

  %%%%%%%%%%%%%%%%%%
  %Initiate the simulation passing off to user function
  %%%%%%%%%%%%%%%%%%

  % Add bodies to simulator
  sim = sim_addBody(sim, [ramp block finger]);

  % Run the simulator
  sim = sim_run( sim );
  path=sim.userData.path;
  time=sim.userData.time;
end
