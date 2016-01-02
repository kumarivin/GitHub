function names = readfilenames (nameFile)

  names = cell(1,300);
  fid1 = fopen(nameFile);
  counter = 1;

  while ~feof(fid1)
    names{1,counter} = fgetl(fid1);              % get a line from file
    counter = counter + 1;
  end;

  fclose(fid1);
  names(counter:end) = [];

  end
