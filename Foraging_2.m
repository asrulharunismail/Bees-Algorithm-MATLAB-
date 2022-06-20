function y = Foraging_2 (patchPosition,nghk,upper,lower,size)
    
    r = nghk * size;
    
    nVar = numel (patchPosition);
    
    k = randi([1 nVar]);
       
    y = patchPosition;

    y(k) = y(k)+ r*((-1)^randi(2));

    y(y>upper) = upper;
    y(y<lower) = lower;
    
end
