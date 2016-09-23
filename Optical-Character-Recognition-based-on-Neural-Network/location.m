function LLP=location(I)
figure();
subplot(3,2,1),imshow(I),title('Original Image');
I1=rgb2gray(I);%Convert to gray image
subplot(3,2,2),imshow(I1),title('Gray Image');
I2=edge(I1,'roberts',0.09,'both');%Extracte the edge by Robert Operator
subplot(3,2,3),imshow(I2),title('Image after Edge Extraction');
se=[1;1;1];
I3=imerode(I2,se);    %Corrode the image
subplot(3,2,4),imshow(I3),title('Edge Image after Corrosion');
se=strel('rectangle',[25,25]);
I4=imclose(I3,se);      %Fill the image
subplot(3,2,5),imshow(I4),title('Image after filling');
I5=bwareaopen(I4,2000);  %Remove the agglomeration which gray value is less than 2000
subplot(3,2,6),imshow(I5),title('Image after Morphological Filtering');
[y,x,z]=size(I5);
I6=double(I5);
 Y1=zeros(y,1);
 for i=1:y
    for j=1:x
             if(I6(i,j,1)==1) 
                Y1(i,1)= Y1(i,1)+1; 
            end  
     end       
 end
 [temp MaxY]=max(Y1);
 figure();
 subplot(3,2,1),plot(0:y-1,Y1),title('Cumulative Sum of Gray Value of Pixel by row'),xlabel('row'),ylabel('pixel');
 
 %% Determine the beginning and end position of the license plate by row%%
 PY1=MaxY;
 while ((Y1(PY1,1)>=50)&&(PY1>1))
        PY1=PY1-1;
 end    
 PY2=MaxY;
 while ((Y1(PY2,1)>=50)&&(PY2<y))
        PY2=PY2+1;
 end
 IY=I(PY1:PY2,:,:);
 X1=zeros(1,x);
 for j=1:x
     for i=PY1:PY2
            if(I6(i,j,1)==1)
                X1(1,j)= X1(1,j)+1;               
            end  
     end       
 end
 subplot(3,2,2),plot(0:x-1,X1),title('Cumulative Sum of Gray Value of Pixel by column'),xlabel('column'),ylabel('pixel');
 
 %% Determine the beginning and end position of the license plate by column%% 
 PX1=1;
 while ((X1(1,PX1)<3)&&(PX1<x))
       PX1=PX1+1;
 end    
 PX2=x;
 while ((X1(1,PX2)<3)&&(PX2>PX1))
        PX2=PX2-1;
 end
 PX1=PX1-1;
 PX2=PX2+1;
 
 %Extracte the license plate%
LLP=I(PY1:PY2,PX1:PX2,:); 
subplot(3,2,3),imshow(LLP),title('Locate the colorful license plate after extraction')