function dispsize (name, val, eol)
  fprintf(' sz(%s): [%d %d]', name, size(val,1), size(val,2));
  if eol
      fprintf('\n');
  end
end