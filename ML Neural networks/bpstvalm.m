function [net, errTrn, errTst, errVal, ep, accTrn] = ...
	  bpstvalm (network, trainset, testset, valset, targets, ...
			   testTargets, valTargets, numHids, numOuts, ...
			   eta, momentum, wtMax, debug1)
  %% tuneset, weights1, weights2, outputEpochs, debug2
  
  %% This is the stochastic version
  % assuming that the instances are the rows of the sets
  
  %% Initializations

  % we'll choose weights uniformly from the interval [-wtMax, wtMax]
  %% sizeWe = numIns*numHids + numHids*numOuts + 2;
  fprintf('network: %d,%d,%d',network,size(network));
  if wtMax == []
      wtMax = .1;
  end
  if isstruct(network)
      We1 = network.We1;
      We2 = network.We2;
      numIns = size(We1,1) - 1;
      numHids = size(We1,2);
      numOuts = size(We2,2);
  else 
      numIns = size(trainset,2);
      We1 = rand((numIns+1), numHids) * 2 * wtMax - wtMax;
      We2 = rand((numHids+1), numOuts) * 2 * wtMax - wtMax;
  end

  %% For returning the weights at the point of minimum validation error
  minValError = 10000;
  minValErrorEpoch = 0;
  minValErrorWe1 = [];
  minValErrorWe2 = [];
  minValDecreasing = false;
  minValTargetEpochs = epochs;

  %% previous Deltas for momentum purposes
  Delta1 = zeros(size(We1));
  Delta2 = zeros(size(We2));
  
  numInsts = size(trainset,1);
  x0 = ones(numInsts,1);
  inputs = [x0 trainset];
  
  %% what's the iteration?
  %% For stochastic, I have to iterate through insts
  errTrn = zeros(1,epochs);
  errTst = zeros(1,epochs);
  errVal = zeros(1,epochs);
  accTrn = zeros(1,epochs);
  accTst = zeros(1,epochs);
  accVal = zeros(1,epochs);
  accuracy = 0;
  
  if debug1 >= 3
	  printsizem('trainset',trainset,'testset',testset,'valset',valset,'targets',targets,'testTargets',testTargets,'valTargets',valTargets);
      % disp(size(We1));
      % disp(size(We2));
	  printsizem('We1',We1,'We2',We2);
      fprintf('  We1: '); fprintf('%7.3g ', We1); fprintf('\n');
      fprintf('  We2: '); fprintf('%7.3g ', We2); fprintf('\n');
  end

  ep = 0;
  while (ep < epochs) && (ep < minValTargetEpochs) && (accuracy < 1)
      ep = ep+1;

      error = zeros(1,numInsts);
      for i = 1:numInsts
          %% hidOuts: output of each hidden node (1 x numHids): 
          %% a_j := sum_k wkj xk[e]
          hidOuts = sigmoid(inputs(i,:)*We1);
          %printsizem('hidOuts',hidOuts);

          %% (1x3)*(3x1)->(1x1): (1 x numOuts)
          %% a_i := sum_j wji*oj
          outOuts = sigmoid([1 hidOuts]*We2);
          %printsizem('outOuts',outOuts);
          if (debug1 > 2)
			fprintf('  outOuts(%d): ', i); fprintf('%7.3g ', outOuts); 
			fprintf('  targets(%d): ', i); fprintf('%7.3g ', targets(i,:)); fprintf('\n');
		  end
          
          error(i) = .5*sum((targets(i,:)-outOuts).^2);
          %printsizem('error(i)',error(i));
          
          %% T4.3: error terms for outputs
          %% δi := oi(1 − oi)(ti[e] − oi)
          %% (1xnO) .*(1xnO).*(1xnO) => (1 x numOuts)
          outErrors = outOuts.*(1-outOuts).*(targets(i,:) - outOuts);
          
          %% For each hid(h), need sum over outs(k) of w_kh*delta_k
          %% We2(3x1)*(1x1) -> sum((8x2).*(8x2)).*(2x1)x(1x1)
          %% (1 x nH).*(1 x nH).* ((nH x nO) * (nO x 1))' => (1 x nH)
          %% (1x20) .* (1x20) .* ((20x3)*(3x1))
								  
		  %printsizem('hidOuts',hidOuts,'We2',We2,'outErrors',outErrors);
          hidErrors = hidOuts .* (1-hidOuts) .* (We2(2:end,:)*outErrors')';
          
          %% T4.5
          %% First do deltas to bring in momentum: Eqn 4.18
          Delta2 = (eta*outErrors'*[1 hidOuts])' + momentum*Delta2;
          Delta1 = (eta*hidErrors'* inputs(i,:))' + momentum*Delta1;
          
          %% 3x1 + (1x1)*(1x1)*(1x3)'
          %% (nH+1 x nO) + (1 * (nO x 1) * (1 x nH+1))' => (nH+1 x nO)
          We2 = We2 + Delta2;
          
          %% (1x1)*(1x2)
          %% (nI+1 x nH) + (1 * (nH x 1) * (1 x nI+1))' => (nI+1 x nH)
          We1 = We1 + Delta1;
          
          if debug1 >=4
              fprintf('%d, %d, error: %8.4g\n', ep, i, error);
              fprintf('  hidOuts: '); fprintf('%8.4g ', hidOuts); fprintf('\n');
              fprintf('  outOuts: '); fprintf('%8.4g ', outOuts); fprintf('\n');
              fprintf('  outErrors: '); fprintf('%8.4g ', outErrors); fprintf('\n');
              fprintf('  hidErrors: '); fprintf('%8.4g ', hidErrors); fprintf('\n');
              fprintf('  We1: '); fprintf('%8.4g ', We1); fprintf('\n');
              fprintf('  We2: '); fprintf('%8.4g ', We2); fprintf('\n');
          end
      end                               % of EPOCH

      %% Doing RMSE at end of epoch
      %% errTrn(ep) = sum(error)/numInsts;
      hidOuts = sigmoid(inputs*We1);    % 113x5 * 5x20 -> 113x20
      outOuts = sigmoid([x0 hidOuts]*We2); % (instsXhids) * (hidsXouts)
      rmses = sqrt(sum((targets-outOuts).^2,2)/numOuts);
      % size(rmses);
	  % change to returning SSE as below
      % errTrn(ep) = sum(rmses)/size(targets,1); % aveRMSE
	  errTrn(ep) = .5*sum(sum((targets-outOuts).^2))/size(targets,1);
      maxRMSE = max(rmses);
      
      if ~isempty(testTargets)
          hidOutsTst = sigmoid([ones(size(testTargets,1),1) testset]*We1);
          outOutsTst = sigmoid([ones(size(testTargets,1),1) hidOutsTst]*We2);
          if debug1 > 1 
              dispsize('sztT',testTargets,false);
              dispsize('szoO',outOutsTst,true);
          end
          errTst(ep) = .5*sum(sum((testTargets-outOutsTst).^2))/size(testTargets,1);
      end
      
      if ~isempty(valTargets)
          hidOutsVal = sigmoid([ones(size(valTargets,1),1) valset]*We1);
          outOutsVal = sigmoid([ones(size(valTargets,1),1) hidOutsVal]*We2);
          if debug1 > 1 
              dispsize('szvT',valTargets,false);
              dispsize('szvO',outOutsVal,true);
          end
          errVal(ep) = .5*sum(sum((valTargets-outOutsVal).^2))/size(valTargets,1);
      end
      %% check accuracy
      correct = targets==round(outOuts);
      accuracy = sum(sum(correct))/(numInsts*numOuts);
      accTrn(ep) = accuracy;
      % haven't put in accTst and accVal yet
      
      if (debug1 > 0) || (mod(ep,100)==0)
          fprintf(['Epoch %d, maxRMSE: %7.4g, aveRMSE: %7.4g, Acc: ' ...
                   '%7.4g\n'], ep, maxRMSE, errTrn(ep), accuracy);
      end

      if ~isempty(valTargets) 
        if errVal(ep) < minValError
            minValError = errVal(ep);
            minValErrorEpoch = ep;
            minValErrorWe1 = We1;
            minValErrorWe2 = We2;
            minValDecreasing = true;
        else
            if minValDecreasing 
                disp(sum(error));
                disp(ep);
                
                break;
                disp(['val error increase at epoch: ' num2str(ep)]);
                %minValDecreasing = false;
                if ep > 20
                    minValTargetEpochs = ep * 1.3;
                %end
            end
        end
      end
      
      % if (targetError > 0) && (sum(error) <= targetError)
      % 	disp(sum(error));
      % 	disp(ep);
      % 	break;
      % end
          
  end                                   % of training

  if minValErrorEpoch > 2
      net = struct('We1', minValErrorWe1, 'We2', minValErrorWe2);
      ep = minValErrorEpoch;
  else
      net = struct('We1', We1, 'We2', We2);
  end
  
  errTrn(ep+1:end) = [];
  errTst(ep+1:end) = [];
  errVal(ep+1:end) = [];

end


