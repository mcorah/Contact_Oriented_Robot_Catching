function y=evalPolynomial(P,x)
  y=[];
  for i=[1:size(P,2)]
    temp=0;
    for j=[1:size(P,1)]
      temp=temp+P(j,i)*x^(j-1);
    end
    y=[y;temp];
  end
end
