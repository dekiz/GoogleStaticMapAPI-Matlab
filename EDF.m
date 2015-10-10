%Read excel file, extract coordinates as a number classed matrix
[A,B] = xlsread('testsample.xls','testsample');
C = B(:,5);
C = regexprep(C,'[','');
C = regexprep(C,']','');
C=char(C);
C=str2num(C);

format long;

%Timestamp extract
T = B(:,4);
T = regexprep(T,'"','');
T = regexprep(T,' UTC','');
T=char(T);
T=datestr(T);
T=datenum(T);

%Delay vector in sec
X=datevec(T,'yyyy-mm-dd HH:MM:SS');
for i=1:size(X,1)/2
    delay(i,:)=etime(X(2*i,:),X(2*i-1,:));
end

delaytime=delay/3600;

%Create pickuptimes and dropofftimes vectors

for i=1:size(T,1)/2
    pickuptimes(i,1)=T(2*i-1,1);
    dropofftimes(i,1)=T(2*i,1);
end
pickuptimes=datestr(pickuptimes);
dropofftimes=datestr(dropofftimes);

%T=datevec(T,'yyyy-mm-dd HH:MM:SS');
%T=datenum(T);

pickuptimes_tem=datenum(pickuptimes);

%Create deadline vector
for i=1:size(pickuptimes)
    deadline(i,1)=addtodate(pickuptimes_tem(i,1),1,'hour');
end

deadline=datestr(deadline);

%Reorganize excel matrix with deadline values
for i=1:size(pickuptimes)
    pickupmatrix(i,:)=B(2*i-1,:);
end

deadlinetable=[pickupmatrix cellstr(deadline)];

%Earliest Deadline First Algorithm

%Let d[1] ? . . . ? d[n] be the jobs sorted by increasing deadline
%Let f = s
%For i = 1, . . . , n:
%Schedule job i starting from time f to f + t[i]
%Let f = f + t[i]

%Sort jobs by increasing deadline
[sorted, indices]=sort(datenum(deadline));
sorteddeadline=datestr(sorted);

%Let f = s
f=pickuptimes_tem;

%Calculate f+t[i]
for i=1:size(pickuptimes,1)
ft(i,1)=addtodate(pickuptimes_tem(i,1),delay(i,1),'second');
end

ftm=datestr(ft);
deadlinetable=[pickupmatrix cellstr(deadline) cellstr(ftm)];

ID=char(pickupmatrix(:,1));

for i=1:size(pickuptimes,1)
sch_jobs(i,:)= ID(indices(i,1),:);
end

for i=1:size(pickuptimes,1)
sch_jobs_matrix(i,:)= deadlinetable(indices(i,1),:);
end

cdes={'ID','Carier','Pickup/Dropoff','Start time','Coordinates','Category','Deadline','Finish time'};
sch_jobs_matrix;
sch_jobs_matrix_N=[cdes;sch_jobs_matrix];
disp(sch_jobs_matrix_N);


