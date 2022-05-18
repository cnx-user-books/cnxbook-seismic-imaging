% TimeEllipse.m - 
% A function for Kirchhoff Migration imaging. 
% Takes a matrix of raw time sample data and converts it into a picture of specified dimensions. 
% Designed to take the same inputs as ElipsePlot.m
% Written by Wing-kei Yu.
% For ELEC 301 Project with group Ben Weidman, Lisa Qian, Aditya Nag.
% 
% A - time series matrix with dimensions m x n where m is the number of samples and n is the
% number of receivers.
% Ts - time between time samples
% v - velocity of wave in medium
% RposVect - vector of receiver positions
% SposVect - vector of source positions
% Xs - space of one grid square

function image = TimeEllipse(A, Ts, v, RposVect, SposVect, Xs)
    Xn = 640;
    Yn = 480;                           % Image size 640x480
    image = zeros(Yn,Xn);               % blank image
    
    num_time_series = length(RposVect); % how many time series there are per source
    
    theta = [pi:pi/480:2*pi];           % A simple vector for the angles the ellipse covers - pi to 2pi
    
    Rpos = 0;                           % initialize - Rpos is the current receiver position
    Recv_offset = 0;                    % Recv_offset is the number of the receiver we're currently processing
    
    for h = 1:length(SposVect)          % for each source
        
        Spos = SposVect(h)                  % current source position
    
        AB = A(:,Recv_offset*length(RposVect)+1:(Recv_offset+1)*length(RposVect)); % extracts relevant time vectors for this source
    
        Recv_offset = Recv_offset+1;        % increment offset for next loop
        r = ones(1,length(theta));          % initialize radii vector for ellipse
    
                                            % run thru a time vector;
        for i = 1:num_time_series           % for each time vector; 
            
            TimeVector = AB(:,i);           % extract one time vector from the block of them
            Rpos = RposVect(i);             % current receiver position
            for time = 1:length(TimeVector);% for each sample in the time vector
               
             if (abs(TimeVector(time)) > 0) % if the value is not zero, calculate; if it is 0 skip
                    cc = abs(Rpos - Spos);     % dist between receiver and source
                    dist = time*Ts*v/Xs;       % distance represented by the time sample
                    if (dist > cc)             % if time sample distance > dist between r and s, continue
                        c = cc/2;              % ellipse parameter a,b,c and e calculation
                        hypotenuse = dist/2;
                        angle = acos(c/hypotenuse);
                        b = hypotenuse*sin(angle);
                        a = (b*b+c*c)^0.5;
                        e = c/a;
                        r = a*(1-e*e)./(1+e.*cos(theta));  % locus of ellipse points relative to rightmost focus
                        [X,Y] = pol2cart(theta,r);         % convert to cartesian
                        if (Rpos < Spos)                   % normalize position to rightmost focus position
                            X = round(X+Spos);             % and round off values to grid
                        else
                            X = round(X+Rpos);
                        end 
                        Y = -round(Y);                     % round off values to grid
                        for m=1:length(X);                 % for each ellipse point in the picture 
                            if (Y(m) > 0 & X(m) > 0 & Y(m) < Yn & X(m) < Xn)
                                image(Y(m),X(m)) = image(Y(m),X(m)) + TimeVector(time); % add the timevector sample value to it
                            end
                        end 
                    end
                end
            end 
        end
    end