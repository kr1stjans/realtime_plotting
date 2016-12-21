function [idx] = RealTimeQRSDetection ()
    
    % constants
    M = 1;
    summation = 7;
    alpha = 0.05;
    gama = 0.15;
    
    %file = load(fileName);
    %signal = file.val(1,:);
    signal = transpose(textread('input.txt'));
    lenghtSignal = size(signal, 2);
    idx = [];
    
    firstFiltered = zeros(1, lenghtSignal);
    
    % linear high-pass filtering
    for i = 1 : lenghtSignal
        y2n = signal(1, max(1, i - (M + 1)/2));
        y1n = 0;
        for j = 0 : M - 1
            y1n = y1n + signal(1, max(1, i - j));
        end
        firstFiltered(1,i) = y2n - (1/M)*y1n;
    end
    
    % nonlinear low-pass filtering
    secondFiltered = firstFiltered.^2;
    final = zeros(1, lenghtSignal);
    
    for i = 1 : lenghtSignal
        sum = 0;
        for j = 0 : summation
            sum = sum + secondFiltered(1, max(1, i-j));
        end
        final(1,i) = sum;
    end
    
    %threshold
    threshold = 0;
    beat = 0;
    
    i = 1;
    while (i < lenghtSignal)
        % find PEAK in feature
        PEAK = 0;
        for j = i : min(i + 200, lenghtSignal)
            if final(1,j) > PEAK
                PEAK = final(1,j);
            end
        end
        
        threshold = alpha * gama * PEAK + (1 - alpha) * threshold;
        % find beats
        for j = i : min(i + 200, lenghtSignal)
            if ((final(1,j) > threshold) && (beat == 0))
                if(length(idx) < 1 || idx(end) < (j-100))
                    idx(end+1) = j + 25;
                    beat = 1;
                end
            elseif ((final(1,j) < threshold) && (beat == 1))
                beat = 0;
            end
        end
        i = i + 200;
    end
   
    %show graph
    figure(1);
    plot(signal, 'b-*');
    hold on;
    %plot(firstFiltered, '.g');
    %plot(final, 'g');
    %plot(idx, ones(1,length(idx)), 'r*');
    hold off;
    
end