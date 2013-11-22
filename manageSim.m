function sim=manage_sim(sim)
  %fprintf('time: %d\n',sim.time)
  BIG=1e20;
  block=sim.bodies(2);
  %reset the boy when it leaves the plane
  u=sim.bodies(2).u;
  v=sim.bodies(2).nu(1:3);
  trans=sim.userData.trans;
  if abs(u(1))>1 | abs(u(2))>1 | abs(u(3))>1 | norm(v)<0.01
    %x=planTrajectory(sim.userData.mytime',sim.userData.U(1,:)',[-1;-10;-30],[1;10;30],[1;0],[sim.userData.handInit(1);0]);
    %y=planTrajectory(sim.userData.mytime',sim.userData.U(2,:)',[-1;-10;-30],[1;10;30],[1;0],[sim.userData.handInit(2);0]);
    %call to threaded regression function
    %problems ordered x y theta
    time=repmat(sim.userData.mytime',1,3);
    lower=[[-1;-20;-100] [-1;-20;-100] [-BIG;-BIG;-BIG]];
    upper=-lower;
    mask=[[1;1] [1;1] [1;1]];
    init=[[sim.userData.handInit(1:2)';[0 0]] [0;0]];
    sim.userData.poly=planTrajectory(time, sim.userData.U', lower, upper, mask,init);
    %x=planTrajectory(sim.userData.mytime',sim.userData.U(1,:)',[-1;-20;-100],[1;20;100],[1;1],[sim.userData.handInit(1);0]);
    %y=planTrajectory(sim.userData.mytime',sim.userData.U(2,:)',[-1;-20;-100],[1;20;100],[1;1],[sim.userData.handInit(2);0]);
    %th=planTrajectory(sim.userData.mytime',sim.userData.U(3,:)',[],[],[1;1],[0;0]);
    %len=max([length(x) length(y) length(th)]);
    %sim.userData.poly=[[x;zeros(len-length(x),1)] [y;zeros(len-length(y),1)] [th;zeros(len-length(th),1)]];
    sim.userData.deriv=derivPoly(sim.userData.poly);

    sim.bodies(2).u=sim.userData.uInit;
    sim.bodies(2).nu=sim.userData.nuInit;
    sim.bodies(2).quat=sim.userData.quatInit;
    sim.bodies(3).nu=[trans' zeros(3,3);zeros(3,3) trans']*[0;0;0;0;0;0];
    sim.bodies(3).u=trans'*sim.userData.handInit;
    sim.bodies(3).quat=sim.userData.quatInit;
    sim.time=0;
    sim.step=0;
    sim.userData.U=[];
    sim.userData.U2=[];
    sim.userData.mytime=[];

    sim.userData.stage=sim.userData.stage+1;
    disp('INCREMENTING STAGE!')
  end
  if sim.userData.stage == 0
    sim.bodies(3).u=trans'*sim.userData.handInit;
  else
    ux=evalPolynomial(sim.userData.poly(:,1),sim.time);
    uy=evalPolynomial(sim.userData.poly(:,2),sim.time);
    u=[ux;uy;sim.userData.handInit(3)];
    nux=evalPolynomial(sim.userData.deriv(:,1),sim.time);
    nuy=evalPolynomial(sim.userData.deriv(:,2),sim.time);
    nu=[nux;nuy;0;0;0;0];

    sim.bodies(3).nu=[trans' zeros(3,3);zeros(3,3) trans']*nu;
    %sim.bodies(3).nu=[trans' zeros(3,3);zeros(3,3) trans']*[0;0;0;0;0;0];
    sim.bodies(3).u=trans'*u;
  end
  sim=trackPosition(sim);
end
