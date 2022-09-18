clear
SampFreq = 1024;
t = 1/SampFreq : 1/SampFreq : 1;

Sig=sin(2*pi*(75*t+30*t.^3))+sin(2*pi*(340*t-2*exp(-2*(t-0.2)).*sin(14*pi*(t-0.2))));
[m,n]=size(Sig);
time=(1:n)/SampFreq;
fre=(SampFreq/2)/(n/2):(SampFreq/2)/(n/2):(SampFreq/2);

x11=0.17; x22=0.23;
y11=245;   y22=281;

[Ts1_6]=MSST_Y_new((Sig)',35,6);

gamma = 0;
sigma = 0.05;
[~,~,~,~,~,Ts1,Ts2,Ts3,Ts4] = sstn(Sig,gamma,sigma);

..................................................

figure
subtitle('Fig. 8');
subplot(421)
imagesc(time,fre,abs(Ts1));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(422);
imagesc(time,fre,abs(Ts1));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

subplot(423)
imagesc(time,fre,abs(Ts2));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(424);
imagesc(time,fre,abs(Ts2));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

subplot(425)
imagesc(time,fre,abs(Ts4));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(426);
imagesc(time,fre,abs(Ts4));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

subplot(427)
imagesc(time,fre,abs(Ts1_6));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(428);
imagesc(time,fre,abs(Ts1_6));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

..................................................
t1=204;
figure
subtitle('Fig. 9');
subplot(211)
plot(fre,abs(Ts1(:,t1)),'b-','linewidth',2);hold on;
plot(fre,abs(Ts2(:,t1)),'k-','linewidth',2);
plot(fre,abs(Ts4(:,t1)),'g-','linewidth',2);
plot(fre,abs(Ts1_6(:,t1)),'r-','linewidth',2);
axis([250 270 0 1]);
legend('SST','2nd-SST','4th-SST','MSST')
xlabel('Fre / Hz');
ylabel('Amp / V');

subplot(212)
%plot(fre,abs(tfr(:,300)));hold on;
plot(fre,abs(Ts1(:,t1)),'b-','linewidth',2);hold on;
plot(fre,abs(Ts2(:,t1)),'k-','linewidth',2);
plot(fre,abs(Ts4(:,t1)),'g-','linewidth',2);
plot(fre,abs(Ts1_6(:,t1)),'r-','linewidth',2);
axis([70 90 0 1]);
legend('SST','2nd-SST','4th-SST','MSST')
xlabel('Fre / Hz');
ylabel('Amp / V');