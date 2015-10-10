%Read excel file, extract coordinates as a number classed matrix
[A,B] = xlsread('testsample.xls','testsample');
C = B(:,5);
C = regexprep(C,'[','');
C = regexprep(C,']','');
C=char(C);
C=str2num(C);

%Category extract
D = B(:,6);
D = regexprep(D,'{','');
D = regexprep(D,'}','');
D=char(D);

%Timestamp extract
T = B(:,4);
T = regexprep(T,'"','');
T = regexprep(T,' UTC','');
T=char(T);
T=datevec(T,'yyyy-mm-dd HH:MM:SS');

%Carier extract
K=B(:,2);
carier_tem=char(K);
for i=1:size(K,1)/2
    carier(i,:)= carier_tem(2*i-1,:);
end
    
    
%Delay vector in sec
for i=1:size(T,1)/2
    delay(i,:)=etime(T(2*i,:),T(2*i-1,:));
end

delaytime=delay/3600;

delaytime;

%Merge pickup and dropoff coordinates
for i=1:size(C,1)/2
    m(i,:)=horzcat(C(2*i-1,:),C(2*i,:));
end


%Plot lines
x=[m(:,1) m(:,3)];
y=[m(:,2) m(:,4)];


lat=x';
lon=y';

plot(lon,lat,'.r','MarkerSize',20)
line(lon,lat,'Color','r','LineWidth',1.5)
plot_google_map('APIKey','AIzaSyAuBHKwA173B8el_mvxskPaCfPAgiY9jLs')



%Indicate drop-off points
xx=[m(:,3)];
yy=[m(:,4)];

lat1=xx';
lon1=yy';

plot(lon1,lat1,'*r','MarkerSize',15);


%Indicate pick-up points
xxx=[m(:,1)];
yyy=[m(:,2)];

lat2=xxx';
lon2=yyy';

%Calculate km distance between pickup and dropoff points 

pickup=[y(:,1),x(:,1)];
dropoff=[y(:,2),x(:,2)];

for i=1:size(pickup)
km(i,1)=haversine([pickup(i,:)],[dropoff(i,:)]);
end

%Add km to the lines in the plot
midpoint=[(pickup(:,1)+dropoff(:,1))/2, (pickup(:,2)+dropoff(:,2))/2];
for i=1:size(pickup)
    %plot(midpoint(i,1),midpoint(i,2))
    text(midpoint(i,1),midpoint(i,2),['\leftarrow km=',num2str(km(i,1))],'FontSize',8);
end;

%Indicate delays
for i=1:size(pickup)
    if delaytime(i,1)>=1
        plot(lon1(1,i),lat1(1,i),'or','MarkerSize',18);
        plot(lon2(1,i),lat2(1,i),'or','MarkerSize',18);
    end
end

%Carier types

for i=1:size(pickup)
    if carier(i,:) == 'Tekin ÌĞzanek'
        c1=line([lon1(1,i) lon2(1,i)],[lat1(1,i) lat2(1,i)],'Color','r','LineWidth',1.5);  
        d=plot(lon1(1,i),lat1(1,i),'*r','MarkerSize',20);
        plot(lon1(1,i),lat1(1,i),'.r','MarkerSize',20);
        p=plot(lon2(1,i),lat2(1,i),'.r','MarkerSize',20);
    end
    
        if carier(i,:) == 'Volkan KoÌ¤ak'
        c2=line([lon1(1,i) lon2(1,i)],[lat1(1,i) lat2(1,i)],'Color','b','LineWidth',1.5);
        plot(lon1(1,i),lat1(1,i),'*b','MarkerSize',20);
        plot(lon1(1,i),lat1(1,i),'.b','MarkerSize',20);
        plot(lon2(1,i),lat2(1,i),'.b','MarkerSize',20);
    end
end


x=legend([c1 c2 p d],'Carier = Tekin ÌĞzanek','Carier = Volkan KoÌ¤ak','Pick-up', 'Drop-off');
set(d,'MarkerSize',8);
set(x,'FontSize',8);

