function sim=manageTest(sim)
  BIG=1e20;
  block=sim.bodies(2);
  u=sim.bodies(2).u;
  v=sim.bodies(2).nu(1:3);
  trans=sim.userData.trans;


  %done when the body leaves the plane
  if abs(u(1))>1 | abs(u(2))>1 | abs(u(3))>1 | norm(v)<0.01
    sim.time=0;
    sim.end_sim=true;
  else
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %Positioning of the finger
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    ux=evalPolynomial(sim.userData.hand_control(:,1),sim.time);
    uy=evalPolynomial(sim.userData.hand_control(:,2),sim.time);
    %ux2=evalPolynomial(sim.userData.hand_control(:,3),sim.time);
    %uy2=evalPolynomial(sim.userData.hand_control(:,4),sim.time);
    %th=evalPolynomial(sim.userData.hand_control(:,3),sim.time);
    u=[ux;uy;sim.userData.handInit(3)];
    %u2=[ux2;uy2;sim.userData.handInit2(3)];

    nux=evalPolynomial(sim.userData.hand_vel(:,1),sim.time);
    nuy=evalPolynomial(sim.userData.hand_vel(:,2),sim.time);
    %nux2=evalPolynomial(sim.userData.hand_vel(:,3),sim.time);
    %nuy2=evalPolynomial(sim.userData.hand_vel(:,4),sim.time);
    nu=[nux;nuy;0;0;0;0];
    %nu2=[nux2;nuy2;0;0;0;0];

    sim.bodies(3).nu=nu;
    sim.bodies(3).u=u;
    %sim.bodies(4).nu=nu2;
    %sim.bodies(4).u=u2;


    %%%%%%%%%%%%%%%%%%%%%%%%%%
    %Tracking of the block
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    [k th]=R2kth(qt2rot(block.quat));
    sim.userData.path=[sim.userData.path [block.u(1:2);th]];
  end
end
