%LFM
SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;
fc = 200;
T = 2;
B = 20;
k0 = B/T;


for k = -6:2:14
    U1 = 1/4 + (1/2 - 1/4) * rand(500, 1);
    U2 = 1/4 + (1/2 - 1/4) * rand(500, 1);
    U3 = 1/4 + (1/2 - 1/4) * rand(500, 1);
    U4 = 1/4 + (1/2 - 1/4) * rand(500, 1);
for i = 1:200
    Sig = sin(2*pi*fc*U1(i)*t - pi*U2(i)*k0*sin(1.5*t)) + sin(2*pi*fc*U3(i)*t - pi*U4(i)*k0*t.^2);
    Sig_n = awgn(Sig, k);
    [Ts1, tfr]=MSST_Y(Sig_n',50,6);
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts1))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./MIX/" + num2str(k) + "_dB" + num2str(i),"png")
end
end 
    