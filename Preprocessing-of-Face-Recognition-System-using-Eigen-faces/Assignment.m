folder1=('gallery_set/');
Imdir=dir(folder1);
yconumber=[0 0 0 0 0 0 0 0];
t=1;
for number_of_coefficients = 30:10:100
    image1=[];
    for i = 1:100
        for j=2:3
            impath=strcat(folder1,'subject',num2str(i),'_img',num2str(j),'.pgm');
            image2=imread(impath);
            image3=double(reshape(image2',[2500,1]));
            image1=[image1,image3];
        end
    end  
    meanface=mean(image1,2);
    submean=image1;
    for i=1:200
        submean(:,i)=image1(:,i)-meanface;
    end
    cov=submean'*submean;
    [U,D]=eigs(cov,100);  
    vector=submean*U;
    eigenface=vector./(ones(size(vector,1),1)*sqrt(sum(vector.*vector)));
    if number_of_coefficients==30
    for i=1:10
        figure(1)
        subplot(2,5,i);
        imagesc(imrotate(reshape(eigenface(:,i),[50, 50]),270));  
        colormap('gray');
    end  
    for i=1:30
        figure(2)
        subplot(5,6,i);
        imagesc(imrotate(reshape(eigenface(:,i),[50, 50]),270));  
        colormap('gray');
    end  
    end
    folder2=('probe_set/');
    Imdir=dir(folder2);
    image4=[];
    for i=1:100
        impath=strcat(folder2,'subject',num2str(i),'_img1.pgm');
        image2=imread(impath);
        image3=double(reshape(image2',[2500,1]));
        image4=[image4,image3];
    end
    F=bsxfun(@minus, image4, meanface);
    test=eigenface(:,1:number_of_coefficients)'*F;    
    F=bsxfun(@minus,image1,meanface);
    train=eigenface(:,1:number_of_coefficients)'*F;
    distance=zeros(100, 200);
    for i=1:100
        for j=1:200
            distance(i,j)=pdist([(test(:,i))';(train(:,j))'],'correlation');
            %distance(i,j)=pdist([(cotest(:,i))';(cotrain(:,j))'],'cosine');
            %distance(i,j)=pdist([(cotest(:,i))';(cotrain(:,j))'],'euclidean');            
            %distance(i,j)=pdist([(cotest(:,i))';(cotrain(:,j))'],'chebychev');
        end
    end	
    genuine=zeros(1,100);
    k=1;
    for i=1:100
        score=min(distance(i, 2*i-1),distance(i, 2*i));
        genuine(k)=score;
        k=k+1;
    end
    [ng,xg]=hist(genuine,100);  
    ng=ng/sum(ng);
    if number_of_coefficients==30
        figure(3)
        plot(xg,ng,'r');
        title('Match Score Distribution');
        hold on;
        impostor=zeros(1,19800);
        k=1;
        for i=1:100
            for j=1:200
                   impostor(k)= distance(i,j);
                   k=k+1;
            end
        end   
        [ni,xi] = hist(impostor, 100);  
        ni=ni/sum(ni);
        plot(xi,ni,'b');
        xlabel('Match Score (s)'); 
        ylabel('Probability p(s)'); 
        legend('Genuine distribution', 'Impostor distribution');
        hold off
    end        
top = zeros(1, 100);
for i=1:100
    k = genuine(i);        
    for j = 1:200
        if distance(i,j)<=k
            t=t+1;
        end
    end
    top(i)=t;
    t=0;
end
top_data=tabulate(top);
rank=zeros(1,100);
rank(1)=top_data(1,3);
yconumber(number_of_coefficients/10-2)=rank(1); 
for i = 2:100
    if i <= size(top_data,1)
        rank(i) = rank(i-1) + top_data(i,3);
    else
        rank(i) = 100;
    end
end
if number_of_coefficients == 30
    figure(4)
    plot(rank);
    xlabel('Rank (t)'); 
    ylabel('Rank-t Identification Rate (%)');
    title('CMC curve');
end
start1= find(ni<0.001,1);
start2=xi(start1);
[m,n]=min(abs(xg-start2));
GAR=zeros(1,100-n+1);
FAR=zeros(2,100-n+1);
k=1;
for i=n:100
    GAR(k)=sum(ng(1:i));
    test_value=xg(i);
    [m,n]=min(abs(xi-test_value));
    if n==1
        FAR(k)=0.001;
    else
        FAR(1,k)=sum(ni(1:n));
        FAR(2,k)=n;
    end
    k=k+1;
end
if number_of_coefficients==30
    figure(5)
    plot(4*FAR(1,:),GAR); axis([0,1,0,1]);
    title('ROC (GAR vs FAR)');
end
t=t+1;
end
xconumber=[30 40 50 60 70 80 90 100];
figure(6)
bar(xconumber, yconumber);
title('Rank One Recognition Rate');