function y = altsign(x)

% y = altsign(x)

y = x;
y(2:2:numel(y)) = -y(2:2:numel(y));

