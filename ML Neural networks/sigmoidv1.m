function sigmoid = sigmoidv1(x)
    sigmoid = x ./ (1 + abs(x));
end