function [net, errTrn, errTst, errVal,ep] = gesturetrain (network, trainFile, testFile, valFile, ...
					epochs, wtMax, debug1)

  %% read the data, then put the instances in a row instead of column
  trainNames = readfilenames(trainFile);
  testNames = readfilenames(testFile);
  valNames = readfilenames(valFile);

  trainTargets = (1*cellfun(@(x) ~isempty(x), strfind(trainNames, 'down')))';
  testTargets= (1*cellfun(@(x) ~isempty(x), strfind(testNames, 'down')))';
  valTargets= (1*cellfun(@(x) ~isempty(x), strfind(valNames, 'down')))';
    
   
  trainMat = double(readinputmatrix(trainNames))';
  testMat = double(readinputmatrix(testNames))';
  valMat = double(readinputmatrix(valNames))';

  [net, errTrn, errTst, errVal,ep] = ...
	  bpstvalm (network, trainMat, testMat, valMat, trainTargets, ...
			   testTargets, valTargets, 4, 1, .3, .3, epochs, wtMax, debug1);

  disp(ep); disp(size(errTrn));
%%  plot(1:ep,errTrn,';Train;',1:ep,errTst,';Test;',1:ep,errVal,';Valid;');
  figure
  plot(1:ep,errTrn,'b',1:ep,errTst,'r',1:ep,errVal,'g');
  legend('Train','Test','Valid');
  title('Backprop Error');
  xlabel('Epoch'); ylabel('Sum Squared Error');

end
