%***************Dont use this code again *************** %
% trainFile = 'OriginalData.csv';
% data = csvread(trainFile,0,0);
% ncol=size(data,2)
% for i = 1:ncol
% data(:,i) = mat2gray(data(:,i));
% end
%trainTargets=csvread('OriginalDataTargets.csv');
%data1=[data trainTargets];
%csvwrite('fOriginalData.csv',data1);
%x=findgroups(trainTargets);
%***************Dont use this code again - End *************** %

%***************Code to read train, test & val data into a matrix vector*************** %
%the data is a 784 input vector of multiple records in training, test & val data 
 trainMat= csvread('trainDataFinal.csv',0,0);
 testMat= csvread('testDataFinal.csv',0,0);
 valMat= csvread('valDataFinal.csv',0,0);
 %***************End of Code to read train, test & val data into a matrix vector*************** %
 
 %***************Code to read train, test & val data targets into a matrix vector*************** %
   trainTargets= csvread('trainTargetsFinal.csv',0,0);
   testTargets= csvread('testTargetsFinal.csv',0,0);
   valTargets= csvread('valTargetsFinal.csv',0,0);   
 %***************End of Code to read train, test & val data targets into a matrix vector******** % 
 
 
%***************Code to encode train, test & val data targets *************** % 
%The below code encodes the one class 10 range[0-9] output of targets to 10
%class one range output where only 1 out of 10 row vector will be '1' for
%example 1 will be represented in a 1by 10 vector as [0100000000]

%   trainTargetsFin=zeros(size(trainTargets,1),10);
%  testTargetsFin=zeros(size(testTargets,1),10);
%  valTargetsFin=zeros(size(valTargets,1),10);
% for r=1:size(trainTargets,1)
%     if isequal(trainTargets(r),0);
%         trainTargetsFin(r,:)=[1 0 0 0 0 0 0 0 0 0];
%     elseif isequal(trainTargets(r),1);
%          trainTargetsFin(r,:)=[0 1 0 0 0 0 0 0 0 0];
%     elseif isequal(trainTargets(r),2);
%          trainTargetsFin(r,:)=[0 0 1 0 0 0 0 0 0 0];
%     elseif isequal(trainTargets(r),3);
%          trainTargetsFin(r,:)=[0 0 0 1 0 0 0 0 0 0];
%     elseif isequal(trainTargets(r),4);
%          trainTargetsFin(r,:)=[0 0 0 0 1 0 0 0 0 0];
%     elseif isequal(trainTargets(r),5);
%          trainTargetsFin(r,:)=[0 0 0 0 0 1 0 0 0 0];
%     elseif isequal(trainTargets(r),6);
%          trainTargetsFin(r,:)=[0 0 0 0 0 0 1 0 0 0];
%     elseif isequal(trainTargets(r),7);
%          trainTargetsFin(r,:)=[0 0 0 0 0 0 0 1 0 0];
%     elseif isequal(trainTargets(r),8);
%          trainTargetsFin(r,:)=[0 0 0 0 0 0 0 0 1 0];     
%     else isequal(trainTargets(r),9);
%          trainTargetsFin(r,:)=[0 0 0 0 0 0 0 0 0 1];
%     end     
% end
% for r=1:size(testTargets,1)
%     if isequal(testTargets(r),0);
%         testTargetsFin(r,:)=[1 0 0 0 0 0 0 0 0 0];
%     elseif isequal(testTargets(r),1);
%          testTargetsFin(r,:)=[0 1 0 0 0 0 0 0 0 0];
%     elseif isequal(testTargets(r),2);
%          testTargetsFin(r,:)=[0 0 1 0 0 0 0 0 0 0];
%     elseif isequal(testTargets(r),3);
%          testTargetsFin(r,:)=[0 0 0 1 0 0 0 0 0 0];
%     elseif isequal(testTargets(r),4);
%          testTargetsFin(r,:)=[0 0 0 0 1 0 0 0 0 0];
%     elseif isequal(testTargets(r),5);
%          testTargetsFin(r,:)=[0 0 0 0 0 1 0 0 0 0];
%     elseif isequal(testTargets(r),6);
%          testTargetsFin(r,:)=[0 0 0 0 0 0 1 0 0 0];
%     elseif isequal(testTargets(r),7);
%          testTargetsFin(r,:)=[0 0 0 0 0 0 0 1 0 0];
%     elseif isequal(testTargets(r),8);
%          testTargetsFin(r,:)=[0 0 0 0 0 0 0 0 1 0];     
%     else isequal(testTargets(r),9);
%          testTargetsFin(r,:)=[0 0 0 0 0 0 0 0 0 1];
%     end     
% end
% for r=1:size(valTargets,1)
%     if isequal(valTargets(r),0);
%         valTargetsFin(r,:)=[1 0 0 0 0 0 0 0 0 0];
%     elseif isequal(valTargets(r),1);
%          valTargetsFin(r,:)=[0 1 0 0 0 0 0 0 0 0];
%     elseif isequal(valTargets(r),2);
%          valTargetsFin(r,:)=[0 0 1 0 0 0 0 0 0 0];
%     elseif isequal(valTargets(r),3);
%          valTargetsFin(r,:)=[0 0 0 1 0 0 0 0 0 0];
%     elseif isequal(valTargets(r),4);
%          valTargetsFin(r,:)=[0 0 0 0 1 0 0 0 0 0];
%     elseif isequal(valTargets(r),5);
%          valTargetsFin(r,:)=[0 0 0 0 0 1 0 0 0 0];
%     elseif isequal(valTargets(r),6);
%          valTargetsFin(r,:)=[0 0 0 0 0 0 1 0 0 0];
%     elseif isequal(valTargets(r),7);
%          valTargetsFin(r,:)=[0 0 0 0 0 0 0 1 0 0];
%     elseif isequal(valTargets(r),8);
%          valTargetsFin(r,:)=[0 0 0 0 0 0 0 0 1 0];     
%     else isequal(valTargets(r),9);
%          valTargetsFin(r,:)=[0 0 0 0 0 0 0 0 0 1];
%     end     
% end
%***************End of Code to encode train, test & val data targets *************** % 
tic;
%***************Function to invoke 2(1 hid& 1 out) layer neural network with standard sigmoid activation******* % 
gesturetrainFinal([], trainMat,trainTargetsFin,testMat,testTargetsFin,valMat,valTargetsFin,100,0.1, 0)
%***************Function to invoke 3 layer (2 hid& 1 out) neural network with standard sigmoid activation******* % 
gesturetrainFinalv1([], trainMat,trainTargetsFin,testMat,testTargetsFin,valMat,valTargetsFin,100,0.1, 0)
%***************Function to invoke 3 layer(2 hid& 1 out) neural network with fastsig or logsigmoid activation***** % 
gesturetrainFinalv2([], trainMat,trainTargetsFin,testMat,testTargetsFin,valMat,valTargetsFin,100,0.1, 0)
%***************Function to invoke 3 layer(2 hid& 1 out) neural network with tansig activation*************** % 
gesturetrainFinalv3([], trainMat,trainTargetsFin,testMat,testTargetsFin,valMat,valTargetsFin,100,0.1, 0)
time=toc
