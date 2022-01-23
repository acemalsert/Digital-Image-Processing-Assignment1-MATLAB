function score = mySSD(A,B)
    x = double(A)-double(B);
    score = sum(x(:).^2);
end       