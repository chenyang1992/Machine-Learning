function [loopx,loopy,condition]=judgement(poincare1,poincare2,condition)
[row,column]=size(poincare1);
point=zeros(row,column);
count=0;
loopx=0;
loopy=0;
for i=20:row-20
    for j=20:column-20
        if poincare1(i,j)==0.5&&poincare2(i,j)>=0.5
            count=count+1;
            loopx=i;
            loopy=j;
        end
    end
end
if count>1
    condition=condition+1;
else condition=0;
end
if condition>=2
    condition=0;
    poincare=(poincare1+poincare2);
    num=0;
    for location=20:20:round(min(row,column)/20-1)*20        
        row1=round(row/2)-location;
        row2=round(row/2)+location;
        column1=round(column/2)-location;
        column2=round(column/2)+location;
        if row1<1
            row1=1;
        end
        if row2>row
            row2=row;
        end
        if column1<1
            column1=1;
        end
        if column2>column
            column2=column;
        end
       point(row1:row2,column1:column2)=poincare(row1:row2,column1:column2);
       [corex,corey]=find(1==point);
       if length(find(corex))==1&&sum(sum(poincare(corex-4:corex+3,corey-3:corey+4)))>=22
           loopx=corex;
           loopy=corey;
           break;
       elseif length(find(corex))>=2
           for num=1:length(corex)
               if sum(sum(poincare(corex(num)-4:corex(num)+3,corey(num)-3:corey(num)+4)))>=22
                   loopx=corex(num);
                   loopy=corey(num);
                   num=1;
                   break;
              else poincare(corex(num),corey(num))=0;
              end
              
          end
       end
        if num==1
                  break;
        end
    end
end