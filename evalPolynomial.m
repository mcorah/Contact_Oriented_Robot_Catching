function y=evalPolynomial(P,x)
  y=0;
  for i=[1:size(P)]
    y=y+P(i)*x^(i-1);
  end
end
