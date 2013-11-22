function d=derivPoly(p)
  disp('poly')
  disp(p)
  d=[];
  for i=[1:size(p,2)]
    dn=[];
    for j=[2:size(p,1)]
      dn=[dn;p(j,i)*(j-1)];
    end
    if(size(dn)==0)
      dn=0;
    end
    d=[d dn];
  end
  disp('deriv')
  disp(d)
end
