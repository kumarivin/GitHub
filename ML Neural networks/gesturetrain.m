function [net, errTrn, errTst, errVal,ep] = gesturetrain (network, trainFile, testFile, valFile, ...
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
  
  trainTargets=[trainTargets0 trainTargets1 trainTargets2 trainTargets3];
  testTargets=[testTargets0 testTargets1 testTargets2 testTargets3];
  valTargets=[valTargets0 valTargets1 valTargets2 valTargets3];
  
  trainMat = double(readinputmatrix(trainNames))';
  testMat = double(readinputmatrix(testNames))';
  valMat = double(readinputmatrix(valNames))';

  [net, errTrn, errTst, errVal,ep] = ...
	  bpstvalm (network, trainMat, testMat, valMat, trainTargets, ...
			   testTargets, valTargets, 4, 4, .3, .3, epochs, wtMax, debug1);

  disp(ep); disp(size(errTrn));
%%  plot(1:ep,errTrn,';Train;',1:ep,errTst,';Test;',1:ep,errVal,';Valid;');
  figure
  plot(1:ep,errTrn,'b',1:ep,errTst,'r',1:ep,errVal,'g');
  legend('Train','Test','Valid');
  title('Backprop Error');
  xlabel('Epoch'); ylabel('Sum Squared Error');

end
