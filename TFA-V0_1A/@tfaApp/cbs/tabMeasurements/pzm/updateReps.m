function updateReps(app,~,~)
    mode = string(app.TabGroup2.SelectedTab.Title);
    sendCmdToClient(app,app.tcpTF, "STRING:para:"+mode+":repetitions", 'value',app.PZMRepsEditField.Value);
end
% Must be between 1 and 1000. Only changable with prepol "switching" if bipolar or "non-switcing" if unipolar. 
% If
% set to >1 and prepol changed back to switching, then reps will be reset
% to 1
