function [signals,avgFilter,stdFilter,calcThreshold] = ThresholdingAlgo(y,lag,threshold,influence)
% Initialise signal results
signals = zeros(length(y),1);
% Initialise filtered series
filteredY = y(1:lag+1);
% Initialise filters
avgFilter(lag+1,1) = mean(y(1:lag+1));
stdFilter(lag+1,1) = std(y(1:lag+1));
% added new treshold
calcThreshold = avgFilter + stdFilter;
tmpThreshold = calcThreshold(lag+1,1);
PEAK = 0;
zaznanPeak = 0;
% Loop over all datapoints y(lag+2),...,y(t)
for i=lag+2:length(y)
    % If new value is a specified number of deviations away
    if abs(y(i)-avgFilter(i-1)) > threshold*stdFilter(i-1)
        if y(i) > avgFilter(i-1)
            % Positive signal
            %signals(i) = 1;
            %tmpThreshold = 0.05 *  0.15 * y(i) + (1 - 0.05) * tmpThreshold;
        else
            % Negative signal
            %signals(i) = -1;
        end
        % Adjust the filters
        filteredY(i) = influence*y(i)+(1-influence)*filteredY(i-1);
        avgFilter(i) = mean(filteredY(i-lag:i));
        stdFilter(i) = std(filteredY(i-lag:i));
        %calcThreshold(i) = tmpThreshold;
    else
        % No signal
        %signals(i) = 0;
        % Adjust the filters
        filteredY(i) = y(i);
        avgFilter(i) = mean(filteredY(i-lag:i));
        stdFilter(i) = std(filteredY(i-lag:i));
        %calcThreshold(i) = tmpThreshold;
    end
    if y(i) > tmpThreshold
        zaznanPeak = 1;
        if PEAK < y(i)
            PEAK = y(i)
        end
    elseif y(i) < tmpThreshold && zaznanPeak == 1
        zaznanPeak = 0;
        tmpThreshold = 0.05 *  0.15 * PEAK + (1 - 0.05) * tmpThreshold;
        PEAK = 0;
    end
    signals(i) = zaznanPeak;
    calcThreshold(i) = tmpThreshold;
end
% Done, now return results
end