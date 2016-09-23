clear; clc;
origin=imread('0402.pgm');                                 % every time implement an image, just change the name of the image here
%origin=imread('0805.pgm');
%origin=imread('1703.pgm');
%origin=imread('2208.pgm');
%origin=imread('2508.pgm');
%origin=imread('2603.pgm');
%origin=imread('3408.pgm');
%origin=imread('3703.pgm');
%origin=imread('4308.pgm');
%origin=imread('5001.pgm');
[row,column] = size(origin);
image=double(origin);
W = 15;
theta_of_block = [];                                                   % store theta of each block, and its coordinates
[Gx,Gy]=gradient(image);
for m=1:W:row                                                           % loop of row
    for n=1:W:column                                                 % loop of column
        if n+W-1 < column && m+W-1 < row
            sum1 = sum(sum(Gx(m:m+W-1, n:n+W-1).*Gy(m:m+W-1, n:n+W-1)));
            sum2 = sum(sum((Gx(m:m+W-1, n:n+W-1)-Gy(m:m+W-1, n:n+W-1)).*((Gx(m:m+W-1, n:n+W-1)+Gy(m:m+W-1, n:n+W-1)))));
            sum3 = sum(sum(Gx(m:m+W-1, n:n+W-1).*Gx(m:m+W-1, n:n+W-1)+Gy(m:m+W-1, n:n+W-1).*Gy(m:m+W-1, n:n+W-1)));
            theta = 0;          
          if sum3 ~= 0 && sum1 ~=0
             theta = 0.5*atan2(2*sum1,sum2)+pi/2;
             theta_of_block = [theta_of_block;[round(m + (W-1)/2),round(n + (W-1)/2),theta]];
          end;
        end;
    end;
end;

figure(1), imshow(origin), title('The Original Image');
[u,v] = pol2cart(theta_of_block(:,3),8);                                                              % get value of theta, and set the length
figure(2), quiver(theta_of_block(:,2),theta_of_block(:,1),u,v,0,'b'), set(gca,'DataAspectRatio',[1 1 1],'ydir','reverse'), 
title('The Orientation Field Image');
figure(3), imshow(origin), title('The Overlaying Image');
hold on;
quiver(theta_of_block(:,2),theta_of_block(:,1),u,v,0,'b'),
hold off;