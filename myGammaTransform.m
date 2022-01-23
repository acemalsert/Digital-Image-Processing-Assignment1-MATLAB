function B = myGammaTransform(A,gamma)
% your code comes here

A = im2uint8(A);

c = 1;
% creates vector (zero to 255)
r= 0:255;

s = c*r.^gamma;
s = (s/max(s))*255;

%Evaluates the function 
B = s(A+1);
B = uint8(B);

end