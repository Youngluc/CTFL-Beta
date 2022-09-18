clear
load('vib_data1.mat')
fs = 12000; N = 1200;      % sampling frequency and points
time = (1:N)/fs;              % time sequence
fre = (fs/2)/(N/2):(fs/2)/(N/2):(fs/2);    % frequency sequence
data=data(1:N);
[MTs tfr]=MSST_Y_new(data,95,50);

gamma = 10^(-2);
sigma = 0.025;

[~,~,~,~,~,Ts1,Ts2,Ts3,Ts4] = sstn(data,gamma,sigma);
.................................................................
figure
suptitle('Fig. 19');
subplot(211)
plot(time,data);
ylabel('Amp / g');
xlabel('Time / s');
axis([0 0.1 -4 4]);
subplot(212)
ft=abs(fft(data))/600;
plot(fre,ft(1:end/2));
ylabel('Amp / g');
xlabel('Fre / Hz');
axis([0 6000 0 0.3]);
...........................................................................
x1=0.06; x2=0.065;
y1=2.6;   y2=3.7;
dd=0.1;

figure
suptitle('Fig. 20');
subplot(511);
imagesc(time,fre/1000,abs(tfr));
%xlabel('Time / s');
ylabel('Fre / kHz');
axis xy;axis ([0 0.1 y1-dd y2+dd]);
rectangle('Position',[x1 y1 x2-x1 y2-y1],'EdgeColor','red','Linewidth',1);
axes('position',[0.92,0.805,0.07,0.15]); 
imagesc(time,fre/1000,abs(tfr));
%xlabel('Time / s');
ylabel('Fre / kHz');
axis xy
axis off;
%set(ha,'xlim',[x1 x2],'ylim',[y1 y2]);
xlim([x1,x2]);ylim([y1,y2]);

subplot(512);
imagesc(time,fre/1000,abs(Ts1));
%xlabel('Time / s');
ylabel('Fre / kHz');
axis xy;axis ([0 0.1 y1-dd y2+dd]);
rectangle('Position',[x1 y1 x2-x1 y2-y1],'EdgeColor','red','Linewidth',1);
axes('position',[0.92,0.61,0.07,0.15]); 
imagesc(time,fre/1000,abs(Ts1));
%xlabel('Time / s');
ylabel('Fre / kHz');
axis xy
axis off;
%set(ha,'xlim',[x1 x2],'ylim',[y1 y2]);
xlim([x1,x2]);ylim([y1,y2]);

subplot(513);
imagesc(time,fre/1000,abs(Ts2));
%xlabel('Time / s');
ylabel('Fre / kHz');
axis xy;axis ([0 0.1 y1-dd y2+dd]);
rectangle('Position',[x1 y1 x2-x1 y2-y1],'EdgeColor','red','Linewidth',1);
axes('position',[0.92,0.44,0.07,0.15]); 
imagesc(time,fre/1000,abs(Ts2));
%xlabel('Time / s');
ylabel('Fre / kHz');
axis xy
axis off;
%set(ha,'xlim',[x1 x2],'ylim',[y1 y2]);
xlim([x1,x2]);ylim([y1,y2]);

subplot(514);
imagesc(time,fre/1000,abs(Ts4));
%xlabel('Time / s');
ylabel('Fre / kHz');
rectangle('Position',[x1 y1 x2-x1 y2-y1],'EdgeColor','red','Linewidth',1);
axis xy;axis ([0 0.1 y1-dd y2+dd]);
axes('position',[0.92,0.26,0.07,0.15]); 
imagesc(time,fre/1000,abs(Ts4));
%xlabel('Time / s');
ylabel('Fre / kHz');
axis off;
%set(ha,'xlim',[x1 x2],'ylim',[y1 y2]);
xlim([x1,x2]);ylim([y1,y2]);

subplot(515);
imagesc(time,fre/1000,abs(MTs));
%xlabel('Time / s');
ylabel('Fre / kHz');
axis xy;axis ([0 0.1 y1-dd y2+dd]);
rectangle('Position',[x1 y1 x2-x1 y2-y1],'EdgeColor','red','Linewidth',1);
axes('position',[0.92,0.09,0.07,0.15]); 
imagesc(time,fre/1000,abs(MTs));
%xlabel('Time / s');
ylabel('Fre / kHz');
axis xy
axis off;
%set(ha,'xlim',[x1 x2],'ylim',[y1 y2]);
xlim([x1,x2]);ylim([y1,y2]);

..........................................................................
MTs1=MTs;
MTs1(1:310,:)=0;
MTs1(360:end,:)=0;

MTs2=MTs;
MTs2(1:260,:)=0;
MTs2(310:end,:)=0;

[Cs2] = brevridge_mult(abs(MTs2), (1:2)/13.9, 2, 1, 5);
[Cs1] = brevridge_mult(abs(MTs1), (1:2)/13.9, 2, 1, 5);

IF1=[Cs1(1,1:1130) Cs1(2,1131:end)];
IF2=[Cs2(2,1:176) Cs2(1,177:end)];

Cs(1,:)=IF1;Cs(2,:)=IF2;

n=1200;
ds=3;
for k=1:2
for j=1:n
MTs_sig(k,j)=sum(real(MTs(max(1,Cs(k,j)-ds):min(round(n/2),Cs(k,j)+ds),j)));
end
end

figure
suptitle('Fig. 21');
subplot(411)
plot(time,fre(IF1)/1000,'b-');hold on;plot(time,fre(IF2)/1000,'b-');
axis ([0 0.1 y1-dd y2+dd]);
ylabel('Fre / kHz');
subplot(412)
plot(time,MTs_sig(1,:),'b-');
ylabel('Amp / g');
axis ([0 0.1 -2.5 2.5]);
subplot(413)
plot(time,MTs_sig(2,:),'b-');
ylabel('Amp / g');
axis ([0 0.1 -1.5 1.5]);
subplot(414)
plot(time,data,'k-','linewidth',1);hold on;
plot(time,sum(MTs_sig),'r-');
ylabel('Amp / g');
axis ([0 0.1 -2.5 2.5]);
legend('Measured signal','S1 + S2');
.......................................................
figure
suptitle('Fig. 22');
subplot(211)
plot(time,real(MTs_sig(1,:))/max(real(MTs_sig(1,:))),'b-','Linewidth',2);hold on;
plot(time,detrend(fre(Cs(1,:)))/max(detrend(fre(Cs(1,:))))/1.25,'r-','Linewidth',1.5);
axis ([0 0.1 -1 1]);
xlabel('Time / s');
subplot(212)
plot(time,real(MTs_sig(2,:))/max(real(MTs_sig(2,:))),'b-','Linewidth',2);hold on;
plot(time,detrend(fre(Cs(2,:)))/max(detrend(fre(Cs(2,:))))/1.25,'r-','Linewidth',1.5);
axis ([0 0.1 -1 1]);
legend('Mono-component mode','Detected IF');
xlabel('Time / s');