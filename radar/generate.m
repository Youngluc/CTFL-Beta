% SampFreq = 100;
% t = 1/SampFreq : 1/SampFreq : 4;
% fc = 200;
% noise = -6:2:14;
% 
% U = 1/4 + (1/2 - 1/4) * rand(1000, 1);
% s = size(noise);
% %CW
% for i=1:1000
%     Sig = cos(2*pi*fc*U(i)*t);
%     p1 = randperm(s(2), 1);
%     p2 = randperm(s(2), 1);
%     Sig1 = awgn(Sig, p1);
%     Sig2 = awgn(Sig, p2);
%     [Ts1, tfr1]=MSST_Y(Sig1',30,10);
%     [Ts2, tfr2]=MSST_Y(Sig2',30,10);
%     h = figure;
%     set(h,'visible','off')
%     imagesc(abs(Ts1))
%     set(gca,'XTick',[]) % Remove the ticks in the x axis!   
%     set(gca,'YTick',[]) % Remove the ticks in the y axis
%     set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
%     saveas(gcf,"./material/t1/" + num2str(i, '%04d'),"png")
%     h = figure;
%     set(h,'visible','off')
%     imagesc(abs(Ts2))
%     set(gca,'XTick',[]) % Remove the ticks in the x axis!   
%     set(gca,'YTick',[]) % Remove the ticks in the y axis
%     set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
%     saveas(gcf,"./material/t2/" + num2str(i, '%04d'),"png")
% end

SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;
f1 = 200;
f2 = 200;
U1 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
U2 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
%LFM
for i=1001:2000
    Sig = sin(2*pi*fc*U1(i-1000)*t - pi*U2(i-1000)*1*t.^2);
    p1 = randperm(s(2), 1);
    p2 = randperm(s(2), 1);
    Sig1 = awgn(Sig, p1);
    Sig2 = awgn(Sig, p2);
    [Ts1, tfr1]=MSST_Y(Sig1',30,10);
    [Ts2, tfr2]=MSST_Y(Sig2',30,10);
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts1))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t1/" + num2str(i, '%04d'),"png")
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts2))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t2/" + num2str(i, '%04d'),"png")
end

SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;
fc = 200;
fm = 200;
U1 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
U2 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
%BPSK
for i=2001:3000
    Sig = sin(2*pi*fc*U1(i-2000)*t);
    m=square(2*pi*fm*U2(i-2000)*t);
    Sig = Sig.*m;
    p1 = randperm(s(2), 1);
    p2 = randperm(s(2), 1);
    Sig1 = awgn(Sig, p1);
    Sig2 = awgn(Sig, p2);
    [Ts1, tfr1]=MSST_Y(Sig1',30,10);
    [Ts2, tfr2]=MSST_Y(Sig2',30,10);
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts1))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t1/" + num2str(i, '%04d'),"png")
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts2))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t2/" + num2str(i, '%04d'),"png")
end


SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;
f1 = 80;
f2 = 60;
Rb = 100;
Ts = 1/SampFreq;
Tb = 1/Rb;
U1 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
U2 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
%FSK
for i=3001:4000
    ss = round(rand(1,20));
    Sig = zeros(1,400);
    res = [];
    for j=1:20
    if ss(j)
        res = [res ones(1,20)];
    else
        res = [res zeros(1,20)];
    end
    end
    S1 = cos(2*pi*f1*U1(i-3000)*t);
    S2 = cos(2*pi*f2*U2(i-3000)*t);
    for j=1:400
    if res(j) == 1
        Sig(j) = S1(j);
    else
        Sig(j) = S2(j);
    end
    end
    p1 = randperm(s(2), 1);
    p2 = randperm(s(2), 1);
    Sig1 = awgn(Sig, p1);
    Sig2 = awgn(Sig, p2);
    [Ts1, tfr1]=MSST_Y(Sig1',30,10);
    [Ts2, tfr2]=MSST_Y(Sig2',30,10);
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts1))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t1/" + num2str(i, '%04d'),"png")
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts2))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t2/" + num2str(i, '%04d'),"png")
end


SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;
fc = 200;
T = 2;
B = 20;
k0 = B/T;
U1 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
U2 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
%NLFM
for i=4001:5000
    Sig = sin(2*pi*fc*U1(i-4000)*t - pi*U2(i-4000)*k0*sin(1.5*t));
    p1 = randperm(s(2), 1);
    p2 = randperm(s(2), 1);
    Sig1 = awgn(Sig, p1);
    Sig2 = awgn(Sig, p2);
    [Ts1, tfr1]=MSST_Y(Sig1',30,10);
    [Ts2, tfr2]=MSST_Y(Sig2',30,10);
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts1))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t1/" + num2str(i, '%04d'),"png")
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts2))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t2/" + num2str(i, '%04d'),"png")
end

SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;
fc = 200;
T = 2;
B = 20;
k0 = B/T;
U1 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
U2 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
U3 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
U4 = 1/4 + (1/2 - 1/4) * rand(1000, 1);
%LFM/NLFM
for i=5001:6000
    Sig = sin(2*pi*fc*U1(i-5000)*t - pi*U2(i-5000)*k0*sin(1.5*t)) + sin(2*pi*fc*U3(i-5000)*t - pi*U4(i-5000)*k0*t.^2);
    p1 = randperm(s(2), 1);
    p2 = randperm(s(2), 1);
    Sig1 = awgn(Sig, p1);
    Sig2 = awgn(Sig, p2);
    [Ts1, tfr1]=MSST_Y(Sig1',30,10);
    [Ts2, tfr2]=MSST_Y(Sig2',30,10);
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts1))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t1/" + num2str(i, '%04d'),"png")
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts2))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./material/t2/" + num2str(i, '%04d'),"png")
end
