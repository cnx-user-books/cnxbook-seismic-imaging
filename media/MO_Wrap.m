function image77 = MO_Wrap(A, Ts, v, RposVect, SposVect, Xs)

%test_by_row = zeros(480,1);
%test_by_col = zeros(640,1);
XRange = [1 640];
YRange = [1 480];
% perform computations for first shot.
	FirstShot = A(:,1:128);
	B = ElipsePlot(FirstShot, Ts, v, RposVect, SposVect, Xs, XRange, YRange);
    
 % now calculate which rows we can truncate
 count = 1;
 while(count <= 480 & YRange(1) == 1)
     if(max(abs(B(count,:))) > 3)
         YRange(1) = count;
     end
     count = count + 1;
 end
 
 
 
 count = 480;
 while(count >= 1 & YRange(2) == 480)
     if(max(abs(B(count,:)))>3)
         YRange(2) = count;
     end
     count = count - 1;
 end
 
 YRange
 
 SposVect = SposVect + 310;
 LastShot = A(:,3969:4096);
 B = B + ElipsePlot(LastShot, Ts, v, RposVect, SposVect, Xs, XRange, YRange);
 
 % now truncate columns
 count = 100;
 while(count <= 640 & XRange(1) == 1)
     if(max(B(:,count)) > 10)
         XRange(1) = count;
     end
     count = count + 1;
 end
 
 count = 550;
 while(count >= 1 & XRange(2) == 640)
     if(max(B(:,count)) > 10)
         XRange(2) = count;
     end
     count = count - 1;
 end
 
 XRange
 
 SposVect = SposVect - 300;
   
 for i = 2:31
     crap = A(:,1+(i-1)*128:(i)*128);
     B = B + ElipsePlot(crap, Ts, v, RposVect, SposVect, Xs, XRange, YRange);
     SposVect = SposVect + 10
 end
 
 image77 = B;
 
