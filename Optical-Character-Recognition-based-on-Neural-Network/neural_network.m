function  inpt  = neural_network(I)
if ndims(I)==3
   I1 = rgb2gray(I);
else
   I1=I;
end
I1=imresize(I1,[50 20]); %Unify all the images to 50X20
I1=im2bw(I1,0.9);
[m,n]=size(I1);
inpt=zeros(1,m*n);

%convert the images to row vectors by column%
for j=1:n
    for i=1:m
        inpt(1,m*(j-1)+i)=I1(i,j);
    end
end


        

