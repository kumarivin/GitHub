function [J, grad] = costFunctionReg(theta, X, y, lambda)
%COSTFUNCTIONREG Compute cost and gradient for logistic regression with regularization
%   J = COSTFUNCTIONREG(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta

J=((-(log(sigmoid(X*theta))'*y)-(log(arrayfun(@(t1)1-t1,sigmoid(X*theta)))'*(arrayfun(@(t2)1-t2,y))))/m)+(lambda/(2*m))*sumsqr(theta(2:size(theta,1),:));
grad=((sigmoid(X*theta)-y)'*X)/m;
for i=2:size(grad,2)
    %grad=(((sigmoid(X*theta)-y)'*X)/m)+((lambda/m)*sum(theta(2:size(theta,1),:)));
     grad(1,i)=grad(1,i)+((lambda/m)*theta(i,1));
end
% =============================================================

end
