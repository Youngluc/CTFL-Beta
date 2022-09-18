load('Sig_noise.mat');

SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;
f1 = 30;
f2 = 15;
Rb = 100;
Ts = 1/SampFreq;
Tb = 1/Rb;
ss = round(rand(1,20));
res = [];
for i=1:20
    if ss(i)
        res = [res ones(1,20)];
    else
        res = [res zeros(1,20)];
    end
end

N = length(res);
Sig = zeros(1, 400);
S1 = sin(2*pi*f1*t);
S2 = sin(2*pi*f2*t);
for i=1:N
if res(i) == 1
    Sig(i) = 4*S1(i);
else
    Sig(i) = 4*S2(i);
end
end
plot(t, Sig);

%Sig = sin(2*pi*(40*t - 5*t.^2))+sin(2*pi*(17*t + 6*sin(1.5*t)));
%Sig = sin(2*pi*(40*t - 5*t.^2))+sin(2*pi*(17*t + 6*sin(1.5*t)));

Sig1 = awgn(Sig, -10);
n=length(Sig);
time=(1:n)/SampFreq;
fre=(SampFreq/2)/(n/2):(SampFreq/2)/(n/2):(SampFreq/2);

[Ts1, tfr]=MSST_Y(Sig1',25,6);
% [Ts] = MSST_Y(Sig1', 50, 6);

figure
subtitle('Fig. 10');
x = imagesc(time,fre,abs(Ts1));axis xy;
%imagesc(abs(Ts1));
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy
% subtitle('Fig. 11');
% subplot(222)
% imagesc(time,fre,abs(Ts));axis xy;
% xlabel('Time / s');
% ylabel('Fre / Hz');
% axis xy