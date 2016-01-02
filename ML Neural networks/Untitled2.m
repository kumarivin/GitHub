for r=1:a 
    if isequal(trainTargets(r,:),[1 0 0 0])
        A(r,1)=1
    elseif isequal(trainTargets(r,:),[0 1 0 0])
         A(r,1)=2
    elseif isequal(trainTargets(r,:),[0 0 1 0])
         A(r,1)=3
    else isequal(trainTargets(r,:),[0 0 0 1])
         A(r,1)=4
    end     
end        