origin=imread('0402.pgm');
%origin=imread('0805.pgm');
%origin=imread('1703.pgm');
%origin=imread('2208.pgm');
%origin=imread('2508.pgm');
%origin=imread('2603.pgm');
%origin=imread('3408.pgm');
%origin=imread('3703.pgm');
%origin=imread('4308.pgm');
%origin=imread('5001.pgm');
image=segmentation(origin);
[m1,n1]=size(image);
image1=zeros(m1+8,n1+8);
image1(5:4+m1,5:4+n1)=image;
for i1=5:m1+4
    for j1=5:n1+4
        neighbor=image1(i1-4:i1+4,j1-4:j1+4);
        direction1(1)=neighbor(5,1)+neighbor(5,3)+neighbor(5,7)+neighbor(5,9);
		direction1(8)=neighbor(3,1)+neighbor(4,3)+neighbor(6,7)+neighbor(7,9);
		direction1(7)=neighbor(1,1)+neighbor(3,3)+neighbor(7,7)+neighbor(9,9);
		direction1(6)=neighbor(1,3)+neighbor(3,4)+neighbor(7,6)+neighbor(9,7);
		direction1(5)=neighbor(1,5)+neighbor(3,5)+neighbor(7,5)+neighbor(9,5);
		direction1(4)=neighbor(1,7)+neighbor(3,6)+neighbor(7,4)+neighbor(9,3);
		direction1(3)=neighbor(1,9)+neighbor(3,7)+neighbor(7,3)+neighbor(9,1);
		direction1(2)=neighbor(3,9)+neighbor(4,7)+neighbor(6,3)+neighbor(8,1);
		for k1=1:4
			trans(k1)=abs(direction1(k1)-direction1(k1+4));
		end
		[value,direction]=max(trans);
        if (abs(neighbor(5,5)-direction1(direction)/4)<abs(neighbor(5,5)-direction1(direction+4)/4))
			pointdirection(i1-4,j1-4)=direction-1;
		else pointdirection(i1-4,j1-4)=direction+3;
        end
    end
end

condition=1;
while(condition)
[m2,n2]=size(pointdirection);
image2=zeros(m2+16,n2+16);
image2(9:8+m2,9:8+n2)=pointdirection;
for i2=9:m2+8
    for j2=9:n2+8
        block=image2(i2-8:i2+8,j2-8:j2+8);
         [x,y]=size(block);
          direction2=zeros(1,8);
          direction2(1)=length(find(0==block));
          direction2(2)=length(find(1==block));
          direction2(3)=length(find(2==block));
          direction2(4)=length(find(3==block));
          direction2(5)=length(find(4==block));
          direction2(6)=length(find(5==block));
          direction2(7)=length(find(6==block));
          direction2(8)=length(find(7==block));
          [valu,sbdi]=max(direction2);
          direction4(i2-8,j2-8)=sbdi-1;
    end
end

[m3,n3]=size(direction4);
ponitcare1=zeros(m3,n3);
for i3=5:m3-4
    for j3=5:n3-4
        direction3(1)=direction4(i3,j3);
        direction3(2)=direction4(i3,j3+1);
        direction3(3)=direction4(i3-1,j3+1);
        direction3(4)=direction4(i3-1,j3);
        direction3(5)=direction4(i3,j3);
        for k2=1:4
            delta1=direction3(mod(k2+1,6))-direction3(k2);
           if abs(delta1)<4
            delta2(k2)=delta1;
           elseif delta1<=-4
            delta2(k2)=delta1+8;
           else delta2(k2)=delta1-8;
           end
       end
       poincare1(i3,j3)=sum(delta2)/16;
   end
end
       
ponitcare2=zeros(m3,n3);
for i4=5:m3-4
    for j4=5:n3-4
        direction3(1)=direction4(i4-4,j4);
        direction3(2)=direction4(i4-4,j4-1);
        direction3(3)=direction4(i4-4,j4-2);
        direction3(4)=direction4(i4-3,j4-3);
        direction3(5)=direction4(i4-2,j4-4);
        direction3(6)=direction4(i4-1,j4-4);
        direction3(7)=direction4(i4,j4-4);
        direction3(8)=direction4(i4+1,j4-4);
        direction3(9)=direction4(i4+2,j4-4);
        direction3(10)=direction4(i4+3,j4-3);
        direction3(11)=direction4(i4+4,j4-2);
        direction3(12)=direction4(i4+4,j4-1);
        direction3(13)=direction4(i4+4,j4);
        direction3(14)=direction4(i4+4,j4+1);
        direction3(15)=direction4(i4+4,j4+2);
        direction3(16)=direction4(i4+3,j4+3);
        direction3(17)=direction4(i4+2,j4+4);
        direction3(18)=direction4(i4+1,j4+4);
        direction3(19)=direction4(i4,j4+4);
        direction3(20)=direction4(i4-1,j4+4);
        direction3(21)=direction4(i4-2,j4+4);
        direction3(22)=direction4(i4-3,j4+3);
        direction3(23)=direction4(i4-4,j4+2);
        direction3(24)=direction4(i4-4,j4+1);
        direction3(25)=direction4(i4-4,j4);
        for k3=1:24
            delta1=direction3(mod(k3+1,26))-direction3(k3);
           if abs(delta1)<4
            delta2(k3)=delta1;
           elseif delta1<=-4
            delta2(k3)=delta1+8;
           else delta2(k3)=delta1-8;
           end
       end
       poincare2(i4,j4)=sum(delta2)/16;
   end
end
[loopx,loopy,condition]=judgement(poincare1,poincare2,condition);
end
image(loopx:loopx+9,loopy:loopy+9)=255;
subplot(1,2,1), imshow(origin);
subplot(1,2,2), imshow(image,[]);