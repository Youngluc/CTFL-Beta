clear
load('Sig_noise.mat');

SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;

Sig = sin(2*pi*(17*t + 6*sin(1.5*t)))+sin(2*pi*(40*t + 1*sin(1.5*t)));
S1 = sin(2*pi*(40*t + 1*sin(1.5*t)));
S2 = sin(2*pi*(17*t + 6*sin(1.5*t)));

n=length(Sig);
time=(1:n)/SampFreq;
fre=(SampFreq/2)/(n/2):(SampFreq/2)/(n/2):(SampFreq/2);

IF1=40 + 1.5*cos(1.5*t);
IF2=17 + 6*1.5*cos(1.5*t);

x11=3.05; x22=3.55;
y11=13.5;   y22=23.5;

x1=3.05; x2=3.55;
y1=35.5;   y2=45.5;
[Ts1]=MSST_Y(Sig_noise(12,:)',50,1);
[Ts1_6]=MSST_Y_new(Sig_noise(12,:)',50,6);

gamma = 10^(-2);
sigma = 0.055;
SIF1=INT(IF1,time);
SIF2=INT(IF2,time);


[~,~,~,~,~,~,Ts2,Ts3,Ts4] = sstn(Sig_noise(12,:),gamma,sigma);
[RM]=RS_Y(Sig_noise(12,:)',50);
[~, DTs1] = SST2(Sig_noise(12,:)',100,150,IF1,SIF1);
[~, DTs2] = SST2(Sig_noise(12,:)',100,150,IF2,SIF2);
.................................................................
figure
subtitle('Fig. 2');
subplot(621)
imagesc(time,fre,abs(Ts1));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(622);
imagesc(time,fre,abs(Ts1));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

subplot(623)
imagesc(time,fre,abs(Ts1_6));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(624);
imagesc(time,fre,abs(Ts1_6));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

subplot(625)
imagesc(time,fre,abs(Ts2));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(626);
imagesc(time,fre,abs(Ts2));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

subplot(627)
imagesc(time,fre,abs(Ts4));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(628);
imagesc(time,fre,abs(Ts4));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

subplot(629)
imagesc(time,fre,abs(RM));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(6,2,10);
imagesc(time,fre,abs(RM));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

subplot(6,2,11)
imagesc(time,fre,abs(DTs1));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
rectangle('Position',[x11 y11 x22-x11 y22-y11],'EdgeColor','red','Linewidth',1);
ha=subplot(6,2,12);
imagesc(time,fre,abs(DTs1));axis xy;
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;
set(ha,'xlim',[x11 x22],'ylim',[y11 y22]);

...........................................................
t1=331;
figure
subtitle('Fig. 3');
subplot(211)
%plot(fre,abs(tfr(:,100)));hold on;
plot(fre,abs(Ts1(:,t1)),'b-','linewidth',2);hold on;
plot(fre,abs(RM(:,t1)),'k-','linewidth',2);
plot(fre,abs(Ts2(:,t1)),'c-','linewidth',2);
plot(fre,abs(Ts4(:,t1)),'g-','linewidth',2);
plot(fre,abs(DTs1(:,t1)),'m-','linewidth',2);
plot(fre,abs(Ts1_6(:,t1)),'r-','linewidth',2);
axis([39 42 0 1.5]);
legend('SST','RM','2nd-SST','4th-SST','DSST','MSST')
xlabel('Fre / Hz');
ylabel('Amp / V');

subplot(212)
%plot(fre,abs(tfr(:,300)));hold on;
plot(fre,abs(Ts1(:,t1)),'b-','linewidth',2);hold on;
plot(fre,abs(RM(:,t1)),'k-','linewidth',2);
plot(fre,abs(Ts2(:,t1)),'c-','linewidth',2);
plot(fre,abs(Ts4(:,t1)),'g-','linewidth',2);
plot(fre,abs(DTs1(:,t1)),'m-','linewidth',2);
plot(fre,abs(Ts1_6(:,t1)),'r-','linewidth',2);
axis([18 21 0 1.5]);
legend('SST','RM','2nd-SST','4th-SST','DSST','MSST')
xlabel('Fre / Hz');
ylabel('Amp / V');

..............................................................
Sig2 = Sig_noise(12,:)-Sig+sin(pi*(17*t + 6*sin(1.5*t)))+sin(pi*(40*t + 1*sin(1.5*t)));
[tfr_wv] = tfrwv(Sig2');
[tfr_pwv] = tfrpwv(Sig2');
[tfr_ridt] = tfrridt(Sig2');
[tfr_ridh] = tfrridh(Sig2');

tfr_wv=abs(tfr_wv(1:200,:));
tfr_pwv=abs(tfr_pwv(1:200,:));
tfr_ridt=abs(tfr_ridt(1:200,:));
tfr_ridh=abs(tfr_ridh(1:200,:));


figure;
subtitle('Fig. 4');
subplot(221);
imagesc(time,fre,abs(tfr_wv));
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;

subplot(222);
imagesc(time,fre,abs(tfr_pwv));
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;

subplot(223);
imagesc(time,fre,abs(tfr_ridt));
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;

subplot(224);
imagesc(time,fre,abs(tfr_ridh));
xlabel('Time / s');
ylabel('Fre / Hz');
axis xy;

.................................................................
[Cs1] = Ridge_mult_detection_Y(abs(Ts1), 1:2, 2, 1, 5);
[Cs1_6] = Ridge_mult_detection_Y(abs(Ts1_6), 1:2, 2, 1, 5);

Cs1=sort(Cs1,'descend');
Cs1_6=sort(Cs1_6,'descend');

ds=1;
for k=1:2
for j=1:n
Ts1_sig(k,j)=sum(real(Ts1(max(1,Cs1(k,j)-ds):min(round(n/2),Cs1(k,j)+ds),j)));
Ts1_6_sig(k,j)=sum(real(Ts1_6(max(1,Cs1_6(k,j)-ds):min(round(n/2),Cs1_6(k,j)+ds),j)));
end
end

figure;
subtitle('Fig. 5');
subplot(121)
plot(time,IF1,'k-','linewidth',4);hold on;
plot(time,fre(Cs1),'r-','linewidth',1.5);
plot(time,IF2,'k-','linewidth',4);
plot(time,fre(Cs1),'r-','linewidth',1.5);
legend('True IF','Estimated IF');
axis ([0 4 0 50]);
xlabel('Time / s');
ylabel('Fre / Hz');

subplot(122)
plot(time,IF1,'k-','linewidth',4);hold on;
plot(time,fre(Cs1_6),'r-','linewidth',1.5);
plot(time,IF2,'k-','linewidth',4);
plot(time,fre(Cs1_6),'r-','linewidth',1.5);
axis ([0 4 0 50]);
xlabel('Time / s');
ylabel('Fre / Hz');
legend('True IF','Estimated IF');

figure;
subtitle('Fig. 6');
subplot(221)
plot(time,S1,'k-','linewidth',1.5);hold on;plot(time,Ts1_sig(1,:),'r-','linewidth',1);xlabel('Time / s');ylabel('Amp / V');axis ([0 4 -1.5 1.5]);
subplot(222)
plot(time,S2,'k-','linewidth',1.5);hold on;plot(time,Ts1_sig(2,:),'r-','linewidth',1);xlabel('Time / s');ylabel('Amp / V');axis ([0 4 -1.5 1.5]);
subplot(223)
plot(time,S1,'k-','linewidth',1.5);hold on;plot(time,Ts1_6_sig(1,:),'r-','linewidth',1);xlabel('Time / s');ylabel('Amp / V');axis ([0 4 -1.5 1.5]);
subplot(224)
plot(time,S2,'k-','linewidth',1.5);hold on;plot(time,Ts1_6_sig(2,:),'r-','linewidth',1);xlabel('Time / s');ylabel('Amp / V');axis ([0 4 -1.5 1.5]);
legend('Original signal','Reconstructed signal');