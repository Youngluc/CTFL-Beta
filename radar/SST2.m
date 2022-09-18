function [tfr Ts] = SST2(x,fs,hlength,IF,SIF);
% Computes the PSTFT (tfr) and the SST (Ts)  of the signal x.
% INPUT
%    x      :  Signal needed to be column vector.
%    fs     :  Sampling frequency.
%    hlength:  The hlength of window function.
%    IF     :  The parameter of instantaneous frequency
%    SIF    :  The parameter of phase function of a signal. It can be
%    calculated by the Integration of IF.
% OUTPUT
%    tfr    :  The PSTFT
%    Ts     :  The SST of PSTFT
% NOTE:
% When IF=zeros(1,length(x)),SIF=zeros(1,length(x)), 
%it is equal to the STFT and original SST.
[xrow,xcol] = size(x);

if (xcol~=1),
 error('X must be column vector');
end; 

if (nargin < 1),
error('At least 1 parameter is required');
end;

if (nargin < 2),
fs=1;
end;

if (nargin < 3),
hlength=round(xrow/5);
end;

if (nargin < 4),
IF=zeros(1,xrow);
SIF=zeros(1,xrow);
end;


Siglength=xrow;
hlength=hlength+1-rem(hlength,2);
ht = linspace(-0.5,0.5,hlength);ht=ht';

% Gaussian window
h = exp(-pi/0.32^2*ht.^2);
% derivative of window
dh = -2*pi/0.32^2*ht .* h; % g'

[hrow,hcol]=size(h); Lh=(hrow-1)/2; 

N=xrow;
t=1:xrow;

[trow,tcol] = size(t);

tt=(1:N)/fs;

%    The parameter of phase function of a signal. It can be
%    calculated by the Integration of IF.

if (nargin < 5),
SIF=INT(IF,tt);
end

tfr1= zeros (N,tcol) ; 
tfr2= zeros (N,tcol) ; 

tfr= zeros (round(N/2),tcol) ; 
Ts= zeros (round(N/2),tcol) ; 

for icol=1:tcol,
ti= t(icol); tau=-min([round(N/2)-1,Lh,ti-1]):min([round(N/2)-1,Lh,xrow-ti]);
indices= rem(N+tau,N)+1; 
rSig = x(ti+tau,1);
rSig = hilbert(real(rSig));
tfr1(indices,icol)=rSig.*conj(h(Lh+1+tau)).*exp(-j * 2.0 * pi * (IF(icol) * tt(ti+tau)))'.*exp(j * 2.0 * pi *SIF(ti+tau))';
tfr2(indices,icol)=rSig.*conj(dh(Lh+1+tau)).*exp(-j * 2.0 * pi * (IF(icol) * tt(ti+tau)))'.*exp(j * 2.0 * pi *SIF(ti+tau))';
end;

tfr1=fft(tfr1);
tfr2=fft(tfr2);

tfr1=tfr1(1:round(N/2),:);
tfr2=tfr2(1:round(N/2),:);

ft = 1:round(N/2);
bt = 1:N;

%%operator omega
nb = length(bt);
neta = length(ft);

va=N/hlength;
omega = zeros (round(N/2),tcol);

for b=1:nb
omega(:,b) = (ft-1)'+real(va*1i*tfr2(ft,b)/2/pi./tfr1(ft,b));
end 

%According to the original definition of SST,
%the following code cannot obtain the accurate omega.
%for i=1:round(N/2)
%omega(i,:)=(imag((gradient(tfr1(i,:))./tfr1(i,:))))/(2*pi);
%end

%dt = tt(2) - tt(1);
%Dtfd = (-i/2/pi/dt)*[tfr1(2:end,:) - tfr1(1:end-1,:); tfr1(1,:)-tfr1(end,:)];
%omega = (abs(Dtfd./tfr1));

omega=round(omega);

for b=1:nb%time
    % Reassignment step
    for eta=1:neta%frequency
        if abs(tfr1(eta,b))>0.0001%you can set much lower value than this.
            k = omega(eta,b);
            if k>=1 && k<=neta
                Ts(k,b) = Ts(k,b) + tfr1(eta,b);
            end
        end
    end
end

tfr=tfr1;
Ts = Ts/(xrow/2)/2;;
end