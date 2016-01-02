function printsizem (varargin)
  for i = 1:2:length(varargin)
	fprintf('  Var: %s, Size: ', varargin{i});
	disp(size(varargin{i+1}));
  end
end