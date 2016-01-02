function sigmoid = sigmoidv2(x)
    sigmoid = (2 ./ (1 + exp(-2*x)) - 1);
end