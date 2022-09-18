clear
load('vibdata.mat')

n=length(data);
SampFreq=2000;
time=(1:n)/SampFreq;
fre=(SampFreq/2)/(n/2):(SampFreq/2)/(n/2):(SampFreq/2);

[Ts tfr]=MSST_Y_new(detrend(data),50,30);

[Cs] = brevridge_mult(abs(Ts), (1:2)/7.8, 3, 1, 5);

n=length(data);
ds=2;
for k=1:3
for j=1:n
Tssig(k,j)=sum(real(Ts(max(1,Cs(k,j)-ds):min(round(n/2),Cs(k,j)+ds),j)));
end
end

figure
suptitle('Fig. 12');
subplot(211)
plot(time,data);
ylabel('Amp / um');
xlabel('Time / Sec');
axis([0 0.5 -100 100]);
subplot(212)
ft=abs(fft(data))/512;
plot(fre,ft(1:end/2));
ylabel('Amp / um');
xlabel('Fre / Hz');
axis([0 1000 0 50]);


figure;
suptitle('Fig. 13');
imagesc(time,fre,log(abs(Ts)));
ylabel('Freq / Hz');
xlabel('Time / Sec');
axis xy


figure
suptitle('Fig. 14');
subplot(211)
plot(time,fre(Cs(1,:)));
ylabel('Fre / Hz');
xlabel('Time / Sec');
axis([0 0.5 80 100]);
subplot(212)
ft=abs(fft(detrend(Cs(1,:))))/512;
plot(fre,ft(1:end/2));
%ylabel('Amp / um');
xlabel('Fre / Hz');
axis([0 1000 0 2]);

figure
suptitle('Fig. 15');
subplot(211)
plot(time,fre(Cs(2,:)));
ylabel('Fre / Hz');
xlabel('Time / Sec');
axis([0 0.5 750 850]);
subplot(212)
ft=abs(fft(detrend(Cs(2,:))))/512;
plot(fre,ft(1:end/2));
%ylabel('Amp / um');
xlabel('Fre / Hz');
axis([0 1000 0 8]);

figure
suptitle('Fig. 16');
subplot(211)
plot(time,fre(Cs(3,:)));
ylabel('Fre / Hz');
xlabel('Time / Sec');
axis([0 0.5 450 600]);
subplot(212)
ft=abs(fft(detrend(Cs(3,:))))/512;
plot(fre,ft(1:end/2));
%ylabel('Amp / um');
xlabel('Fre / Hz');
axis([0 1000 0 8]);




gamma = 10^(-2);
sigma = 0.015;
[~,~,~,~,~,~,Ts2,Ts3,Ts4] = sstn(real(data),gamma,sigma);
[Ts1] = MSST_Y(real(data),50,1);
[RM] = RS_Y(real(data),50);

figure;
suptitle('Fig. 17');
subplot(221)
imagesc(time,fre,log(abs(Ts1)));
ylabel('Freq / Hz');
xlabel('Time / Sec');
axis xy
subplot(222)
imagesc(time,fre,log(abs(RM)));
ylabel('Freq / Hz');
xlabel('Time / Sec');
axis xy
subplot(223)
imagesc(time,fre,log(abs(Ts2)));
ylabel('Freq / Hz');
xlabel('Time / Sec');
axis xy
subplot(224)
imagesc(time,fre,log(abs(Ts4)));
ylabel('Freq / Hz');
xlabel('Time / Sec');
axis xy