function [net, errTrn, errTst, errVal,ep] = gesturetrainFinalcval(network, trainData,trainTarget,testData,testTarget, ...
                                         wtMax, debug1)
  
%   trainTargets=trainTarget;
%   testTargets=testTarget;
%   valTargets=valTarget;
%   
  trainMat = trainData;
  testMat = testData;
  valMat = valData;

  [net, errTrn, errTst, errVal,ep] = ...
	  bpstvalmcvalout (network, trainMat, testMat, trainTarget, ...
			   testTarget, 5, 10, .3, .3,kfold, wtMax, debug1);

  disp(ep); disp(size(errTrn));
%%  plot(1:ep,errTrn,';Train;',1:ep,errTst,';Test;',1:ep,errVal,';Valid;');
  figure
  plot(1:ep,errTrn,'b',1:ep,errTst,'r',1:ep,errVal,'g');
  legend('Train','Test','Valid');
  title('Backprop Error');
  xlabel('Epoch'); ylabel('Sum Squared Error');

end
