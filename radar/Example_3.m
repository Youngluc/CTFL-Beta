

clear

SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;

Sig = sin(2*pi*(40*t - 5*t.^2))+sin(2*pi*(17*t + 6*sin(1.5*t)));

n=length(Sig);
time=(1:n)/SampFreq;
fre=(SampFreq/2)/(n/2):(SampFreq/2)/(n/2):(SampFreq/2);

x11=2.4; x22=3.1;
y11=6;   y22=18;

IF1=40-10*t;
IF2=17 + 6*1.5*cos(1.5*t);

[Ts1, tfr]=MSST_Y(Sig',50,1);
[Ts1_6]=MSST_Y_new(Sig',50,6);

figure
subtitle('Fig. 10');
subplot(321)
plot(time,IF1,'b-');hold on;
plot(time,IF2,'b-');
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
axis([0 4 0 50 ]);
subplot(322)
imagesc(time,fre,abs(tfr));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;

subplot(323)
imagesc(time,fre,abs(Ts1));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(324);
imagesc(time,fre,abs(Ts1));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

subplot(325)
imagesc(time,fre,abs(Ts1_6));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(326);
imagesc(time,fre,abs(Ts1_6));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);