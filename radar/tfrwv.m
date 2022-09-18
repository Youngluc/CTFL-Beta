function [tfr,t,f] = tfrwv(x,t,N,trace);
%TFRWV	Wigner-Ville time-frequency distribution.


if (nargin == 0),
 error('At least one parameter required');
end;
[xrow,xcol] = size(x);

if (nargin == 1),
 t=1:xrow; N=xrow ; trace=0;
elseif (nargin == 2),
 N=xrow ; trace=0;
elseif (nargin == 3),
 trace = 0;
end;

if (N<0),
 error('N must be greater than zero');
end;

[trow,tcol] = size(t);
if (xcol==0)|(xcol>2),
 error('X must have one or two columns');
elseif (trow~=1),
 error('T must only have one row'); 
elseif (2^nextpow2(N)~=N),
 fprintf('For a faster computation, N should be a power of two\n');
end; 

tfr= zeros (N,tcol);  
if trace, disp('Wigner-Ville distribution'); end;
for icol=1:tcol,
 ti= t(icol); taumax=min([ti-1,xrow-ti,round(N/2)-1]);
 tau=-taumax:taumax; indices= rem(N+tau,N)+1;
 tfr(indices,icol) = x(ti+tau,1) .* conj(x(ti-tau,xcol));
 tau=round(N/2); 
 if (ti<=xrow-tau)&(ti>=tau+1),
  tfr(tau+1,icol) = 0.5 * (x(ti+tau,1) * conj(x(ti-tau,xcol))  + ...
                           x(ti-tau,1) * conj(x(ti+tau,xcol))) ;
 end;
 if trace, disprog(icol,tcol,10); end;
end; 
tfr= fft(tfr); 
if (xcol==1), tfr=real(tfr); end ;

if (nargout==0),
 tfrqview(tfr,x,t,'tfrwv');
elseif (nargout==3),
 f=(0.5*(0:N-1)/N)';
end;
