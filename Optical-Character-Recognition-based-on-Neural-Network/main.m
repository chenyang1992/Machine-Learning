close all;
clear all;
%%%% build up BP neural network %%%%%%
I0=neural_network(imread('Templates\0.jpg'));
I1=neural_network(imread('Templates\1.jpg'));
I2=neural_network(imread('Templates\2.jpg'));
I3=neural_network(imread('Templates\3.jpg'));
I4=neural_network(imread('Templates\4.jpg'));
I5=neural_network(imread('Templates\5.jpg'));
I6=neural_network(imread('Templates\6.jpg'));
I7=neural_network(imread('Templates\7.jpg'));
I8=neural_network(imread('Templates\8.jpg'));
I9=neural_network(imread('Templates\9.jpg'));
I10=neural_network(imread('Templates\A.jpg'));
I11=neural_network(imread('Templates\B.jpg'));
I12=neural_network(imread('Templates\C.jpg'));
I13=neural_network(imread('Templates\D.jpg'));
I14=neural_network(imread('Templates\E.jpg'));
I15=neural_network(imread('Templates\F.jpg'));
I16=neural_network(imread('Templates\G.jpg'));
I17=neural_network(imread('Templates\H.jpg'));
I18=neural_network(imread('Templates\J.jpg'));
I19=neural_network(imread('Templates\K.jpg'));
I20=neural_network(imread('Templates\L.jpg'));
I21=neural_network(imread('Templates\M.jpg'));
I22=neural_network(imread('Templates\N.jpg'));
I23=neural_network(imread('Templates\P.jpg'));
I24=neural_network(imread('Templates\Q.jpg'));
I25=neural_network(imread('Templates\R.jpg'));
I26=neural_network(imread('Templates\S.jpg'));
I27=neural_network(imread('Templates\T.jpg'));
I28=neural_network(imread('Templates\U.jpg'));
I29=neural_network(imread('Templates\V.jpg'));
I30=neural_network(imread('Templates\W.jpg'));
I31=neural_network(imread('Templates\X.jpg'));
I32=neural_network(imread('Templates\Y.jpg'));
I33=neural_network(imread('Templates\Z.jpg'));
% Inuput Templates %
P=[I0',I1',I2',I3',I4',I5',I6',I7',I8',I9',I10',I11',I12',I13',I14',I15',I16',I17',I18',I19',I20',I21',I22',I23',I24',I25',I26',I27',I28',I29',I30',I31',I32',I33'];
% Output Templates %
T=eye(34,34);
% parameter setting of neural network %
net=newff(minmax(P),[1000,32,34],{'logsig','logsig','logsig'},'trainrp');
net.inputWeights{1,1}.initFcn ='randnr';
net.layerWeights{2,1}.initFcn ='randnr';
net.trainparam.epochs=5000;
net.trainparam.show=150;
net.trainparam.lr=0.003;
net.trainparam.goal=0.00000000000001;
net=init(net);
[net,tr]=train(net,P,T);

% TEST %
I=imread('Sample01.JPG');
LLP=location(I); %Locate the License Plate
[PIN0,PIN1,PIN2,PIN3,PIN4,PIN5,PIN6]=Segmentation(LLP); %Character Segmentation

%% character recognition %%
PIN0=neural_network(PIN0);
PIN1=neural_network(PIN1);
PIN2=neural_network(PIN2);
PIN3=neural_network(PIN3);
PIN4=neural_network(PIN4);
PIN5=neural_network(PIN5);
PIN6=neural_network(PIN6);
P0=[PIN0',PIN1',PIN2',PIN3',PIN4',PIN5',PIN6'];
for i=2:7
  T0= sim(net ,P0(:,i));
  T1 = compet (T0) ;
  d =find(T1 == 1) - 1
if (d==10)
    str='A';
 elseif (d==11)
     str='B';
 elseif (d==12)
     str='C';
 elseif (d==13)
     str='D';
 elseif (d==14)
     str='E';
 elseif (d==15)
     str='F';
 elseif (d==16)
     str='G';
 elseif (d==17)
     str='H';
 elseif (d==18)
     str='J';
  elseif (d==19)
     str='K';
   elseif (d==20)
     str='L';
   elseif (d==21)
     str='M';
   elseif (d==22)
     str='N';
   elseif (d==23)
     str='P';
    elseif (d==24)
     str='Q';
    elseif (d==25)
     str='R';
     elseif (d==26)
     str='S';
    elseif (d==27)
     str='T';
   elseif (d==28)
     str='U';
    elseif (d==29)
     str='V';
      elseif (d==30)
     str='W';
    elseif (d==31)
     str='X';
    elseif (d==32)
     str='Y';
    elseif (d==33)
     str='Z';
 else
    str=num2str(d);
 end
 switch i
     case 2
         str1=str;
     case 3
         str2=str;
     case 4
         str3=str;
     case 5
         str4=str;
     case 6
         str5=str;
     otherwise
         str6=str;
  end
end 

%% Output Result %%
s=strcat('License Number is Σε',str1,str2,str3,str4,str5,str6);
figure();
imshow(I),title(s);