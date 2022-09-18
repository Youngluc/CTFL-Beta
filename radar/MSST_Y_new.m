function [Ts,tfr,omega2] = MSST_Y_new(x,hlength,num);
% Computes the MSST (Ts)  of the signal x.
% Expression (31)-based Algorithm.
% INPUT
%    x      :  Signal needed to be column vector.
%    hlength:  The hlength of window function.
%    num    :  iteration number.
% OUTPUT
%    Ts     :  The SST
%    tfr     :  The STFT

[xrow,xcol] = size(x);

if (xcol~=1),
    error('X must be column vector');
end;

if (nargin < 3),
    error('At least 3 parameter is required');
end
%
% if (nargin < 2),
% hlength=round(xrow/5);
% num=1;
% else if (nargin < 3),
% num=1;
% end;

hlength=hlength+1-rem(hlength,2);
ht = linspace(-0.5,0.5,hlength);ht=ht';

% Gaussian window
h = exp(-pi/0.32^2*ht.^2);

[hrow,~]=size(h); Lh=(hrow-1)/2;

N=xrow;
t=1:xrow;

[~,tcol] = size(t);

tfr= zeros (round(N/2),tcol) ;
omega = zeros (round(N/2),tcol-1);
omega2 = zeros (round(N/2),tcol);
Ts = zeros (round(N/2),tcol);

for icol=1:tcol,
    ti= t(icol); tau=-min([round(N/2)-1,Lh,ti-1]):min([round(N/2)-1,Lh,xrow-ti]);
    indices= rem(N+tau,N)+1;
    rSig = x(ti+tau,1);
    tfr(indices,icol)=rSig.*conj(h(Lh+1+tau));
end;

tfr=fft(tfr);

tfr=tfr(1:round(N/2),:);

for i=1:round(N/2)
    omega(i,:)=diff(unwrap(angle(tfr(i,:))))*(N)/2/pi;
end
omega(:,end+1)=omega(:,end);
omega=round(omega);

[neta,nb]=size(tfr);

if num>1
    for kk=1:num-1
        for b=1:nb
            for eta=1:neta
                k = omega(eta,b);
                if k>=1 && k<=neta
                    omega2(eta,b)=omega(k,b);
                end
            end
        end
        omega=omega2;
    end
else
    omega2=omega;
end

for b=1:nb%time
    % Reassignment step
    for eta=1:neta%frequency
        if abs(tfr(eta,b))>0.0001%you can set much lower value than this.
            k = omega2(eta,b);
            if k>=1 && k<=neta
                Ts(k,b) = Ts(k,b) + tfr(eta,b);
            end
        end
    end
end
%tfr=tfr/(sum(h)/2);
tfr=tfr/(xrow/2);
Ts=Ts/(xrow/2);
end
%
% function [Ts_f]=SST(tfr_f,omega_f);
% [tfrm,tfrn]=size(tfr_f);
% Ts_f= zeros (tfrm,tfrn) ;
% %mx=max(max(tfr_f));
% for b=1:tfrn%time
%     % Reassignment step
%     for eta=1:tfrm%frequency
%         %if abs(tfr_f(eta,b))>0.001*mx%you can set much lower value than this.
%             k = omega_f(eta,b);
%             if k>=1 && k<=tfrm
%                 Ts_f(k,b) = Ts_f(k,b) + tfr_f(eta,b);
%             end
%         %end
%     end
% end
% end