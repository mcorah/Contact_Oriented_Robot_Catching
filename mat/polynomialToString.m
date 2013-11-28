function [s]=polynomialToString(p)
  s={};
  for i=1:size(p,2)
    temp=[];
    if size(p,1)==0
      temp='0';
    else
      temp=num2str(p(1,i));
      for j=2:size(p,1)
        if 0~=p(j,i)
          if p(j,i)>0
            temp=[temp '+' num2str(p(j,i),3) 'x^' num2str(j-1)];
          else
            temp=[temp '-' num2str(-p(j,i),3) 'x^' num2str(j-1)];
        end
      end
    end
    s=[s;{temp}];
  end
end
