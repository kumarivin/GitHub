function [net, errTrn, errTst, errVal, ep, acc] = xorbpstvalm (epochs, debug1)

  %% NOTE: this doesn't currently work with bpstval because of
  %% accuracy checking with no items.

  %% trainMat: instances X inputs
  %% targets: outputs X instances
  %% We1: (inputs+1 X hids)
  %% We2: (hids+1 X outs)
  hids = 7;
  outs = 1;
  eta = 0.3;
  momentum = 0.3;
  network = [];
  data = dlmread('zooData1.csv',',');
  %dataval = dlmread('zooDataval.csv',',');
  %datatest=dlmread('zooDatatest.csv',',');
  % each row is instance
  %% cvobj = mod(1:size(data,1),8);        % cheap version, just take every 8th item
  %% trainInds = cvobj>1;
  %% testInds = cvobj==1;
  %% valInds = cvobj==0;
  %% cvobj = rand(size(data,1),1);        % cheap version, just take every 8th item
  trainInds = ones(101,1);
  %testInds = ones(15,1);
  %valInds = ones(16,1);
  %% testInds = cvobj<=.125;
  %% valInds = cvobj>.125 & cvobj<=.25;
  trainMat = data(trainInds,1:16);
  trainTargets = data(trainInds,12);
  %testMat = data(testInds,1:11);
  %testTargets = data(testInds,12);
  %valMat = data(valInds,1:11);
  %valTargets = data(valInds,12);
  
  testMat = [];
  testTargets = [];
  valMat = [];
  valTargets = [];
  wtMax = .1;
  
  fprintf('trainMat: (%d,%d), testMat: (%d,%d), valMat: (%d,%d)\n',size(trainMat),size(testMat),size(valMat) );

  [net, errTrn, errTst, errVal, ep, acc] = ...
	  bpstvalm (network, trainMat, testMat, valMat, trainTargets, ...
			   testTargets, valTargets, hids, outs, eta, momentum, epochs, wtMax, debug1);

  eptrained = length(errTrn);
  plot(1:eptrained,errTrn,'b',1:eptrained,errTst,'r',1:eptrained,errVal,'g');
  title('Backprop Error');
  legend('Train','Test','Validation');
  xlabel('Epoch'); ylabel('Sum Squared Error');

end
