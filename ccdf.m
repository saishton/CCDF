input = 'journal.pone.0136497.s002.CSV';
fid = fopen(input);
rawdata = textscan(fid,'%f %f %f %*s %*s','Delimiter',',');
fclose(fid);

data = cell2mat(rawdata);
data(:,1) = data(:,1)-data(1,1);

number_rows = size(data,1);
parfor i=1:number_rows
    thisrow = data(i,:);
    col2 = thisrow(1,2);
    col3 = thisrow(1,3);
    if col2 > col3
        thisrow(1,2) = col3;
        thisrow(1,3) = col2;
        data(i,:) = thisrow;
    end
end

[~, order] = sort(data(:,3));
partsorteddata = data(order,:);

[~, order] = sort(partsorteddata(:,2));
sorteddata = partsorteddata(order,:);

times = zeros(1,number_rows);
j = 1;
k = 1;
while j<number_rows+1
    contact_time = 20;
    step_vector = [20 0 0];
    current_row = sorteddata(j,:);
    if j == number_rows
        next_row = [0 0 0];
    else
        next_row = sorteddata(j+1,:);
    end
    while isequal(next_row,current_row+step_vector)
        contact_time = contact_time+20;
        j = j+1;
        current_row = sorteddata(j,:);
        if j == number_rows
            next_row = [0 0 0];
        else
            next_row = sorteddata(j+1,:);
        end
    end
    times(k) = contact_time;
    j = j+1;
    k = k+1;
end

all_zero = find(~times);
times(all_zero) = [];

sortedtimes = sort(times);

[F,X]=ecdf(times);
CCDF=1-F;

loglog(X,CCDF,'o')
xlabel('Contact Time (s)')
ylabel('CCDF')