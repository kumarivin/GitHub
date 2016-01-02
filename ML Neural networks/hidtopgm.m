function hidtopgm (outfile, weights, height, width)

  graymat = mat2gray(weights);
  graymat1=graymat';
  for i = 1:size(graymat1,1)
	filename = [outfile num2str(i) '.pgm'];
	imwrite(reshape(graymat1(i,1:960),height, width),filename);
  end
end

