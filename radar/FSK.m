SampFreq = 100;
t = 1/SampFreq : 1/SampFreq : 4;
f1 = 80;
f2 = 60;
Rb = 100;
Ts = 1/SampFreq;
Tb = 1/Rb;




for k = -6:2:14
    U1 = 1/4 + (1/2 - 1/4) * rand(500, 1);
    U2 = 1/4 + (1/2 - 1/4) * rand(500, 1);

for i = 1:200
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
    S1 = cos(2*pi*f1*U1(i)*t);
    S2 = cos(2*pi*f2*U2(i)*t);
    for j=1:400
    if res(j) == 1
        Sig(j) = S1(j);
    else
        Sig(j) = S2(j);
    end
    end
    Sig_n = awgn(Sig, k);
    [Ts1, tfr]=MSST_Y(Sig_n',50,6);
    h = figure;
    set(h,'visible','off')
    imagesc(abs(Ts1))
    set(gca,'XTick',[]) % Remove the ticks in the x axis!   
    set(gca,'YTick',[]) % Remove the ticks in the y axis
    set(gca,'Position',[0 0 1 1]) % Make the axes occupy the hole figure
    saveas(gcf,"./FSK/" + num2str(k) + "_dB" + num2str(i),"png")
end
end 