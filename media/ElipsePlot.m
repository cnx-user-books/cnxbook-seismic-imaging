% Code For Image Interpolation of Multi-offset Migration
% Ben Weidman - November - December 2004
% input paramters
%
% A - time series matrix with dimensions mxn where m is the number of samples and n is the
% number of receivers.
% Ts - time between time samples
% v - velocity of sound in medium
% Rpos - vector of receivers
% Spos - vector of sources
% Xs - space of one grid square

function image = ElipsePlot(A, Ts, v, RposVect, SposVect, Xs, XRange, YRange)
    
%    Xn = 640; % parameters for size of grid
%   Yn = 480;
    Xn = XRange(2) - XRange(1) + 1;
    Yn = YRange(2) - YRange(1) + 1;

    B = zeros(480,640);

    temp = size(A);
    NTs = temp(2); % number of offsets - number of receivers

    TimeVector = 0;
    Rpos = 0;
    Spos = SposVect(1);
    
    %h = waitbar(0,'Please wait...');
    for i = 1:1:NTs
        TimeVector = A(:,i);
        
        startPoint = 0;
        count = 1;
        while(startPoint == 0 & count < 128)
            if(TimeVector(count) > .1)
                startPoint = count;
            end
            count = count+1;
        end
            
        Rpos = RposVect(i);
        %for k = 1:length(SposVect)
         
        %   Spos = SposVect(k);
      
        %%%waitbar(i/128,h)

        %%%        disp('now processing time vector #' + i);
        
        i
            for x = XRange(1):XRange(2)
                
                for y = YRange(1):YRange(2)
                    %y = b + YRange(1) - 1;
                    d = sqrt(y^2+(x-Spos)^2)+sqrt(y^2+(x-Rpos)^2); % position in X coordinates
                    dx = d*Xs; % position in absolute units
                    t = dx/v;
                    Tminus = floor(t/Ts);
                    Tplus = ceil(t/Ts);
                    val = 0;
                   
                    if(Tminus == startPoint)
                        val = TimeVector(Tplus)*(t/Ts);
                    end
                    
                    if(Tplus <= length(TimeVector) & Tminus > startPoint)
                        val = TimeVector(Tminus)*(1-(t/Ts - Tminus));
                        val = val+ TimeVector(Tplus)*(t/Ts - Tminus);
                    else
                        val = 0;
                    end
                     B(y,x) = B(y,x) + val;
                end
            end
            % end
    end
    
    
    %spy(B)
    
    
    image = B;
    
   % close(h);