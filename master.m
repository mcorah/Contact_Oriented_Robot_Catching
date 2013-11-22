%%%%%%%%%%%%%%%%%%%%%%%%%%
% Driver function for catching simulation
% Micah Corah
%%%%%%%%%%%%%%%%%%%%%%%%%%

%Sampling space
block_dir=rand(1)*pi
block_u=[0;0.5;0.09];
block_nu=[rot([0;0;1],block_dir)*[-6*rand(1);0;0]
          [0;0;2*pi*rand(1)-pi]];

hand_control=[0 -0.8];

[path,time]=runTest(block_u,block_nu,hand_control);


%call to threaded regression function
%problems ordered x y theta
time=repmat(time',1,2);
lower=[[-1;-20;-100] [-1;-20;-100]];
upper=-lower;
mask=[[1;1] [1;1]];

hand_control=planTrajectory(time, path(1:2,:)',lower,upper,mask,hand_control);

[path,time]=runTest(block_u,block_nu,hand_control);
