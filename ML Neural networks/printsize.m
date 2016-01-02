function printsize (varargin)
  for i = 1:2:length(varargin)
	printf("  Var: %s, Size: ", varargin{i});
	disp(size(varargin{i+1}));
  endfor
  end function