function [Cs, Es] = brevridge_mult(Tx, fs, nr, lambda, clwin)
% Function brevridge_mult : extracts the ridges of a multicomponent signal
% Inputs:
%   Tx TF transform of s (SST, STFT, RM...)
%   lfs : log(fs) frequencies
%   nr : number of ridges
%   lambda : lambda parameter
%   clwin : frequency clearing window
% Outputs:
%   Cs Cs(:,j) is the j-th ridge location

if nargin<4
    lambda=0.001;
    clwin=1;
elseif nargin<5
    clwin=1;
end

Txs = Tx;

[na,N] = size(Txs);

Cs = zeros(N, nr);
Es = zeros(nr, 1);

for j=1:nr
    [Cs(:,j), Es(j)] = brevridge(Txs, fs, lambda);

    % Remove this curve from the representation
    % Max/min frequencies for each time step
    for b=1:N
        Txs(max(1,Cs(b,j)-clwin):min(na,Cs(b,j)+clwin),b)=0;
    end
end

Cs = Cs';

end
