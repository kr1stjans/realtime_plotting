function [idx] = evaldetect(fileName)
    % First set coefficients for H1 (assume Fs=250 Hz)
    m = 3; n = 2;
    a1 = [1, -1];
    h1a = [1, zeros(1,m-1), -1]; 
    h1b = [1, zeros(1,n-1), -1];
    b1 = conv(h1a, h1b);
    
    % Now set coefficients for H2 (assume Fs=250 Hz)
    m = 2; n = 2; 
    a2 = [1, -1];
    h2a = [1, zeros(1,m-1), -1]; 
    h2b = [1, zeros(1,n-1), -1];
    b2 = conv( conv(h2a, h2a), h2b);
    
    % For exercise also compute the impulse response of both filters
    h1 = impz(b1,a1)';
    h2 = impz(b2,a2)';
    
    % Load record and store into variables
    %load(fileName);
    %sig = val;
    sig = transpose(textread('input.txt'));
    leads = size(sig, 1); % number of leads 
    sigLen = size(sig, 2); % signal length in samples
    sigX = 1:sigLen; % vector for x-axis (in samples)
    
    % Zero-out output vector (keep dimensions)
    sumh = zeros(1,sigLen);
    % For each lead compute abs(H1) and H2
    for i=1:leads
        h1 = filter(b1,a1,sig(i,:));
        h2 = filter(b2,a2,sig(i,:));
        sumh = sumh + abs(h1 + abs(h2));
    end
    % Square the sum
    sumhsquared = sumh.^2;
    
    % Final moving average / smoothing filter G
    k = 3;
    gb = [1, zeros(1,k-1), -1];
    ga = [1, -1];
    sumfinal = filter(gb,ga,sumhsquared/k);
    
    % It makes sense to take into account the phase/group delay of the 
    % H1/H2 and G filters, and since these are linear-phase, D is constant
    % (although not there is difference between phase and group delay)
    %D1 = grpdelay(b1,a1,3); D1 = D1(2);
    %D2 = grpdelay(gb,ga,3); D2 = D2(2);

    % Plot results, but take into account the filter delays
    GAIN = 5e4;
    hold on;
    plot(sigX, sig(1,:) * GAIN, '-.', 'Color', [0.6,0.6,0.6]);
    %plot(sigX, sumhsquared, 'b'); 
    plot(sigX, sumfinal * 800 , 'k'); 
    meja = ones(1,sigLen) * 30000;
    plot(meja, 'r');
    hold off;

    % ----- IMPLEMENT DECISION RULE HERE (BEGIN) -----
    % i.e. detect the heart beats, start at the beginning
    idx = []; % holds indexes of detected heart beats
    for i=1:sigLen
       % if heart beat (peak) is detected add the index to vector
       % either with idx=[idx,i] or idx=[idx,i-D1-D2];
    end
    % ----- IMPLEMENT DECISION RULE HERE (END) -----

    % Function returns vector of detected indexes
end