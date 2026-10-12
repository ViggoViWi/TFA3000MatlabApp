function  updatePrePol(app,~,~)
    mode = string(app.TabGroup2.SelectedTab.Title);
    sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":prep", 'value',lower(app.PZMPrePolDropDown.Value));
end
% If prepol disabled, than 
    % repetitions must be 1 greyed out
    % delay 1s. 
    % Bias greyed out, but keeps its value
    % If Bipolar
        % Single loop changable
    % If Unipolar
        % Single loop true and not changable (greyed out)

% If not-switching && bipolar: Repetitions must be  1 (+greyed out): 
    % If not-switching &&bipolar && single loop true,
        % than delay can be changed. 
    % If not-switching &&bipolar && single loop false
        % Delay must be 1 s
% If not-switfching && unipolar: 
    %  Repetitions changable from 1 to 1000
        % If Repetitions 1: Delay can be between 50 ms and 1000s
        % If Repetitions >1: Delay can be exactly 0 or between 50ms and
        % 1000s
    % Single loop is true and not changable (greyed out)

% If switching:
    % Unipolar must be false (if set true again, then prepol will be switch
    % to non-switching and  disabled and non-switching are only items of
    % drop down.
    %  
    % Everything else changable (delay 50ms-1000s except if reps >1 than
    % also exactly 0 possible.)