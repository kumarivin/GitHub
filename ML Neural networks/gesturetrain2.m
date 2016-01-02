function [net, errTrn, errTst, errVal,ep] = gesturetrain2 (network, trainFile, testFile, valFile, ...
					epochs, wtMax, debug1)

  %% read the data, then put the instances in a row instead of column
  trainNames = readfilenames(trainFile);
  testNames = readfilenames(testFile);
  valNames = readfilenames(valFile);

  trainTargets0 = (1*cellfun(@(x) ~isempty(x), strfind(trainNames, 'down')))';
  testTargets0 = (1*cellfun(@(x) ~isempty(x), strfind(testNames, 'down')))';
  valTargets0 = (1*cellfun(@(x) ~isempty(x), strfind(valNames, 'down')))';
  
  trainTargets1 = (1*cellfun(@(x) ~isempty(x), strfind(trainNames, 'hold')))';
  testTargets1 = (1*cellfun(@(x) ~isempty(x), strfind(testNames, 'hold')))';
  valTargets1 = (1*cellfun(@(x) ~isempty(x), strfind(valNames, 'hold')))';
  
  trainTargets2 = (1*cellfun(@(x) ~isempty(x), strfind(trainNames, 'stop')))';
  testTargets2 = (1*cellfun(@(x) ~isempty(x), strfind(testNames, 'stop')))';
  valTargets2 = (1*cellfun(@(x) ~isempty(x), strfind(valNames, 'stop')))';
  
  trainTargets3 = (1*cellfun(@(x) ~isempty(x), strfind(trainNames, 'up')))';
  testTargets3 = (1*cellfun(@(x) ~isempty(x), strfind(testNames, 'up')))';
  valTargets3 = (1*cellfun(@(x) ~isempty(x), strfind(valNames, 'up')))';
  
  trainTargetsfin=[trainTargets0 trainTargets1 trainTargets2 trainTargets3];
  testTargetsfin=[testTargets0 testTargets1 testTargets2 testTargets3];
  valTargetsfin=[valTargets0 valTargets1 valTargets2 valTargets3];
  trainTargetsfin;
  
  a=size(trainTargetsfin,1);
  b=size(testTargetsfin,1);
  c=size(valTargetsfin,1);
  trainTargets=zeros(a,1);
  testTargets=zeros(b,1);
  valTargets=zeros(c,1);
  for r=1:a 
    if isequal(trainTargetsfin(r,:),[1 0 0 0]);
        trainTargets(r,1)=1;
    elseif isequal(trainTargetsfin(r,:),[0 1 0 0]);
         trainTargets(r,1)=2;
    elseif isequal(trainTargetsfin(r,:),[0 0 1 0]);
         trainTargets(r,1)=3;
    else isequal(trainTargetsfin(r,:),[0 0 0 1]);
         trainTargets(r,1)=4;
    end     
  end
  
 for r=1:b 
    if isequal(testTargetsfin(r,:),[1 0 0 0]);
        testTargets(r,1)=1;
    elseif isequal(testTargetsfin(r,:),[0 1 0 0]);
         testTargets(r,1)=2;
    elseif isequal(testTargetsfin(r,:),[0 0 1 0]);
         testTargets(r,1)=3;
    else isequal(testTargetsfin(r,:),[0 0 0 1]);
         testTargets(r,1)=4;
    end     
  end
  
 for r=1:c 
    if isequal(valTargetsfin(r,:),[1 0 0 0]);
        valTargets(r,1)=1;
    elseif isequal(valTargetsfin(r,:),[0 1 0 0]);
         valTargets(r,1)=2;
    elseif isequal(valTargetsfin(r,:),[0 0 1 0]);
         valTargets(r,1)=3;
    else isequal(valTargetsfin(r,:),[0 0 0 1]);
         valTargets(r,1)=4;
    end     
  end 
  
  trainMat = double(readinputmatrix(trainNames))';
  testMat = double(readinputmatrix(testNames))';
  valMat = double(readinputmatrix(valNames))';
  
  [net, errTrn, errTst, errVal,ep] = ...
	  bpstvalm (network, trainMat, testMat, valMat, trainTargets, ...
			   testTargets, valTargets, 4, 1, .3, .3, 75, 0.1, 0);

  disp(ep); disp(size(errTrn));
%%  plot(1:ep,errTrn,';Train;',1:ep,errTst,';Test;',1:ep,errVal,';Valid;');
  figure
  plot(1:ep,errTrn,'b',1:ep,errTst,'r',1:ep,errVal,'g');
  legend('Train','Test','Valid');
  title('Backprop Error');
  xlabel('Epoch'); ylabel('Sum Squared Error');

end
