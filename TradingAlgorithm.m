load("USDTDAI_series.mat");   %Load price series for USDT/DAI for January 2021

%Calculate Volatility of the price series
for k=2:length(price_series)
    return1(k)=(price_series(k)-price_series(k-1))./price_series(k-1);
end
volatility=sqrt(var(return1)*length(return1))

Results=[];
for j=0:1800
    alpha=0.002+0.00001*j;  %Profit margin, optimal=0.0035 for sample price series
    Pb=1-alpha;             %Buy price
    Ps=1+alpha;             %Sell price  %Ps=1+alpha for STA, Ps=1 for ATA              
    QA1=0;                  %Quantity of the first asset
    QA2=100;                %Quantity of the second asset
    Tf = 0.001;             %Trading fee (0.1%)
    for i=1:length(price_series) 
        Cp=price_series(i); %current price    
        if Cp<Pb
           Cp=Pb;
        end  
        if Cp>Ps
            Cp=Ps;
        end
        if  QA2>1 && Cp<=Pb
            QA1=(QA2/Cp)*(1-Tf);
            QA2=0;
        end
        if QA1>1 && Cp>=Ps
            QA2=(QA1*Cp)*(1-Tf);
            QA1=0;
        end      
    end
    profit=QA1+QA2-100;                 % profit=Total_final_quantity-100
    if profit>0                         % No trading case eliminated
        Results=[Results; alpha, profit];
    end
end
average_profit=mean(Results(:,2))
maximum_profit=max(max(Results(:,2)))

plot(price_series,'-b','Linewidth',1)   % Plot price series
axis([0 length(price_series) min(price_series)*0.999 max(price_series)*1.001])
xlabel('Time [min]','Fontsize', 14)
ylabel('Price ratio (USDT/DAI)','Fontsize', 14)