function result=segmentation(image)
image=double(image);
W=16;
[row,column]=size(image);
result=zeros(row,column);
for i=1:W:row-W+1
    for j=1:W:column-W+1
        block=image(i:i+W-1,j:j+W-1);
        max1=max(max(block));
        min1=min(min(block));
        trans=max1-min1;
        if trans==0
            trans=1;
        end
        num1=sum(sum(block))/(W*W);
        num2=(1/(W*W))*sum(sum((block-num1).^2));
        num3=1/5*num1;
        num4=3/8*trans;
        num5=num3+sign(trans-num4)*((trans-num4)^2/(num4^2))*num3/2;
        if num2>num5
            result(i:i+W-1,j:j+W-1)=image(i:i+W-1,j:j+W-1);
        end
    end
end
result(1,:)=0;
result(row,:)=0;
result(:,1)=0;
result(:,column)=0;
row1=fix(row/32);
row2=zeros(row1,2);
for i=1:32:fix(row/32-1)*32+1
    for j=2:column
        if result(i,j-1)==0&&result(i,j)>0
            row2(round(i/32)+1,1)=j;
        elseif result(i,j-1)>0&&result(i,j)==0;
            row2(round(i/32+1),2)=j;
        end
    end
end
column1=fix(column/32);
column2=zeros(column1,2);
for j=1:32:fix(column/32-1)*32+1
    for i=2:row
        if result(i-1,j)==0&&result(i,j)>0
            column2(round(j/32)+1,1)=i;
        elseif result(i-1,j)>0&&result(i,j)==0;
            column2(round(j/32+1),2)=i;
        end
    end
end

x1=round(sum(row2(4:8,1))/5+sum(row2(4:8,2)-row2(4:8,1))/(5*2));
y1=round(sum(column2(4:8,1))/5+sum(column2(4:8,2)-column2(4:8,1))/(5*2));
xn=round((sum(row2(4:8,2)-row2(4:8,1))/5)/2);
yn=round((sum(column2(4:8,2)-column2(4:8,1))/5)/2);
x2=x1-xn;
x3=x1+xn;
y2=y1-yn;
y3=y1+yn;
if x1-xn<0
    x2=1;
end
if x1+xn>column
    x3=column;
end
if y1-yn<0
    y2=1;
end
if y1+yn>row
    y3=row;
end
result=result(y2:y3,x2:x3);
[row,column]=size(result);
for i=1:row
    for j=1:column
        if result(i,j)==0
            result(i,j)=254;
        end
    end
end