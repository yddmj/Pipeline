% This function expects a column vector of strings.

% The function finds time points as long as they appear as numeric values followed by a delimiter and then by either 'hr' or 'min', for instance.
% The complete list of accepted labels for time units appears in function ExtractTimePoint further below.

% Example input:
% Matrix={'AAAAA_BBB_CCC_25.3hrs_DDD_XXXX', 'AAAAA_BBB_CCC_3435.3min_DDD_XXXX', 'AAAAA_BBB_CCC_65.3hrs_DDD_XXXX'}'

% Example output:
% [25.3, 57.26, 65.3]

function timePoints = ExtractTimePoints(Matrix)

  timePoints = [];
  
  [numberOfRows,numberOfColumns] = size(Matrix);

  format bank;
  
  % The following block of nested for loops simply goes through the matrix cells looking for the time points and saving them in variable timePoints. In the ends, all values stored in timePoints are measured in hours.
  for i=1:numberOfRows
    for j=1:numberOfColumns
      stringToSearch = Matrix{i,j};
      timePoint = ExtractTimePoint(stringToSearch);
      timePoint = num2str(timePoint);
      timePoints = cat(2, timePoints, {timePoint});
    end
  end
  timePoints = (str2double(timePoints));  
end


% The following are a few examples that illustrate what this function receives as arguments and what it returns.

% With the following arguments, the function returns 25.3.
% stringToSearch = 'AAAAA_BBB_CCC_25.3hrs_DDD_XXXX'
% timeLabelUsed = 'hrs'

% With the following arguments, the function returns 25.3.
% stringToSearch = 'AAAAA_BBB_CCC_25.3 hrs_DDD_XXXX'
% timeLabelUsed = 'hrs'

% With the following arguments, the function returns 25.3.
% stringToSearch = 'AAAAA_BBB_CCC_25.3mins_DDD_XXXX'
% timeLabelUsed = 'mins'

% With the following arguments, the function returns 25.3.
% stringToSearch = 'AAAAA_BBB_CCC_25.3 mins_DDD_XXXX'
% timeLabelUsed = 'mins'

function timePoint = ExtractTimePoint(stringToSearch)

  timePoint = [];
  
  % The time point may be in hours and the units may appear written as 'hours' or 'hrs', for instance. The following section searches the input string to determine whether the time appears in hours and the label used.
  hourLabelUsed = '';
  possibleHourLabels = {'hour', 'hours', 'hr', 'hrs'};
  for i=1:length(possibleHourLabels)
    indexOfHourLabelInString=strfind(stringToSearch, possibleHourLabels{i});
    if not(isempty(indexOfHourLabelInString))
      hourLabelUsed = possibleHourLabels{i};
      break;
    end
  end

  % The time point may be in minutes and the units may appear written as 'minutes' or 'mins', for instance. The following section searches the input string to determine whether the time appears in minutes and the label used.
  minuteLabelUsed = '';
  possibleMinuteLabels = {'minute', 'minutes', 'min', 'mins'};
  for i=1:length(possibleMinuteLabels)
    indexOfMinuteLabelInString=strfind(stringToSearch, possibleMinuteLabels{i});
    if not(isempty(indexOfMinuteLabelInString))
      minuteLabelUsed = possibleMinuteLabels{i};
      break;
    end
  end
  

  if not(isempty(hourLabelUsed))
    timePoint = ExtractNumericValueBeforeTimeLabel(stringToSearch, hourLabelUsed);
  elseif not(isempty(minuteLabelUsed))
    timePoint = ExtractNumericValueBeforeTimeLabel(stringToSearch, minuteLabelUsed);
    timePoint = timePoint / 60;
  end
end


% The following are a few examples that illustrate what this function receives as arguments and what it returns.

% With the following arguments, the function returns 25.3.
% stringToSearch = 'AAAAA_BBB_CCC_25.3hrs_DDD_XXXX'
% timeLabelUsed = 'hrs'

% With the following arguments, the function returns 25.3.
% stringToSearch = 'AAAAA_BBB_CCC_25.3 hrs_DDD_XXXX'
% timeLabelUsed = 'hrs'

function numericValueBeforeTimeLabel = ExtractNumericValueBeforeTimeLabel(stringToSearch, timeLabelUsed)

  indexWhereNumericValueShouldEnd = strfind(stringToSearch, timeLabelUsed) - 1;
  indexWhereNumericValueShouldStart = indexWhereNumericValueShouldEnd;
  
  while true
    indexWhereNumericValueShouldStart = indexWhereNumericValueShouldStart - 1;
    
    if indexWhereNumericValueShouldStart <= 0
      break;
    end
    
    if not(isempty(str2num(strcat('0',str2num(stringToSearch(indexWhereNumericValueShouldStart:indexWhereNumericValueShouldEnd))))))
      if isempty(str2num(strcat('0',str2num(stringToSearch(indexWhereNumericValueShouldStart:indexWhereNumericValueShouldStart)))))
	indexWhereNumericValueShouldStart = indexWhereNumericValueShouldStart + 1;
	break;
      end
    end
    
    numericValueBeforeTimeLabel = str2num(TrimString(stringToSearch(indexWhereNumericValueShouldStart:indexWhereNumericValueShouldEnd)));
    if isempty(numericValueBeforeTimeLabel)
      indexWhereNumericValueShouldStart = indexWhereNumericValueShouldStart + 1;
      break;
    end
  end
  
  numericValueBeforeTimeLabel = str2num(TrimString(stringToSearch(indexWhereNumericValueShouldStart:indexWhereNumericValueShouldEnd)));  
end


function trimmedString = TrimString(stringToTrim)
  
  charactersToRemove = {'_', ' ', '-', '/'};
  
  trimmedString = stringToTrim;
  
  for i=1:length(charactersToRemove)
    trimmedString=strrep(trimmedString, charactersToRemove{i}, '');
  end  
end

%  function timePoint = ExtractTimePoint(stringToSearch)
%    delimiters = {' ', ',', '_'};
%    splitString = strsplit(stringToSearch, delimiters);
%        
%    % The following lines attempt to find the time point measured in hours. The time units may appears as 'hr' or 'hours', for instance.
%    indexWhereHourIndicatorIsLocated = find(strcmp([splitString], 'hr'));
%    if isempty(indexWhereHourIndicatorIsLocated)
%      indexWhereHourIndicatorIsLocated = find(strcmp([splitString], 'hour'));
%    end
%    if isempty(indexWhereHourIndicatorIsLocated)
%      indexWhereHourIndicatorIsLocated = find(strcmp([splitString], 'hours'));
%    end
%  
%    % The following line attempts to find the time point measured in minutes.
%    indexWhereMinIndicatorIsLocated  = find(strcmp([splitString], 'min'));
%  
%    if not(isempty(indexWhereHourIndicatorIsLocated))
%      timePoint = splitString{indexWhereHourIndicatorIsLocated-1};
%    elseif not(isempty(indexWhereMinIndicatorIsLocated))
%      % The time point found is in minutes and needs to be changed to hours.
%      timePoint = num2str(str2num(splitString{indexWhereMinIndicatorIsLocated-1}) / 60);
%    end
%  end