function [PIN0,PIN1,PIN2,PIN3,PIN4,PIN5,PIN6] = StringSplit(I)
if ndims(I)==3
   I1 = rgb2gray(I);    %Convert to gray image
else
   I1=I;
end
g_max=double(max(max(I1)));
g_min=double(min(min(I1)));
T=round(g_max-(g_max-g_min)/3);  % T is the threshold value of binaryzation
[m,n]=size(I1);
I1=im2bw(I1,T/256);
subplot(3,2,4);
imshow(I1),title('Image after Binaryzation');

I2=bwareaopen(I1,20);
subplot(3,2,5);
imshow(I2),title('Binary Image after Median Filtering');
[y1,x1,z1]=size(I2);
I3=double(I2);
TT=1;

%%%%%%%Remove the unrelated area%%%%%
Y1=zeros(y1,1);
 for i=1:y1
    for j=1:x1
             if(I3(i,j,1)==1) 
                Y1(i,1)= Y1(i,1)+1 ;
            end  
     end       
 end
Py1=1;
Py0=1;
while ((Y1(Py0,1)<20)&&(Py0<y1))
      Py0=Py0+1;
end
Py1=Py0;
 while((Y1(Py1,1)>=20)&&(Py1<y1))
         Py1=Py1+1;
 end
I2=I2(Py0:Py1,:,:);
subplot(3,2,6);
imshow(I2),title('Target Area of License Plate');

%%%%%% Segment the character by row Cumulative Sum%%%%%%%
X1=zeros(1,x1);
for j=1:x1
    for i=1:y1
             if(I3(i,j,1)==1) 
                X1(1,j)= X1(1,j)+1;
            end  
     end       
end
figure(5);
plot(0:x1-1,X1),title('Cumulative Sum of Gray Value of Pixel by column'),xlabel('column'),ylabel('pixel');
Px0=1;
Px1=1;

%%Character Segmentation%%
for i=1:7
  while ((X1(1,Px0)<3)&&(Px0<x1))
      Px0=Px0+1;
  end
  Px1=Px0;
  while (((X1(1,Px1)>=3)&&(Px1<x1))||((Px1-Px0)<10))
      Px1=Px1+1;
  end
  Z=I2(:,Px0:Px1,:);
  switch strcat('Z',num2str(i))
      case 'Z1'
          PIN0=Z;
      case 'Z2'
          PIN1=Z;
      case 'Z3'
          PIN2=Z;
      case 'Z4'
          PIN3=Z;
      case 'Z5'
          PIN4=Z;
      case 'Z6'
          PIN5=Z;
      otherwise 
          PIN6=Z;
  end
  figure(3);
  subplot(1,7,i);
  imshow(Z);
  Px0=Px1;

end
