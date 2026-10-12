function deveBtn(app,~,~)
    
    % resetData = app.swKinResetDataBuffer;
    % if app.SKSmAmpCheckBox.Value
    %     setData = app.swKinSetDataBuffer;
    % else
    %     setData = cell(1,numel(resetData));
    % end
    % if app.SKSmAmpCheckBox.Value
    %     smAmpData = app.swKinSmAmpDataBuffer;
    % else
    %     smAmpData = cell(1,numel(resetData));
    % end
    % 
    % 
    % concatData = cat(1,setData,smAmpData,resetData);
    % assignin('base,'"concatData",concatData)
    % 
    % 
    % dataObj = SwKinData(concatData);





    %% Find peaks of y1
    xName = app.DADropDown_x1.Value;
    yName = app.DADropDown_y1.Value;
    y2Name = app.DADropDown_y2.Value;
    xVals =zeros(length(app.DAListBox.Items),1);
    yVals =zeros(length(app.DAListBox.Items),1);
    x2Vals =zeros(length(app.DAListBox.Items),1);
    calPols = zeros(length(app.DAListBox.Items),1);
    calPolSets = zeros(length(app.DAListBox.Items),1);
    notCompcalPols= zeros(length(app.DAListBox.Items),1);
    allTables = cell(2,length(app.DAListBox.Items));
    wrPulseAmps =  zeros(length(app.DAListBox.Items),1);

    for idx=1:length(app.DAListBox.Items)
        ID = app.DAListBox.ItemsData{idx};
        dataFromBuffer=app.dataBuffer{ID};
        [metaTable, dataTable] = processData(dataFromBuffer);

        metaVarNames = metaTable.Properties.VariableNames;
        mask= contains(metaVarNames,"Write","IgnoreCase",true)&contains(metaVarNames,"Pulse","IgnoreCase",true)&contains(metaVarNames,"amp","IgnoreCase",true)&~contains(metaVarNames,"rise","IgnoreCase",true);
        wrPulseAmp = metaTable.(string(metaVarNames(mask)));
        wrPulseAmps(idx)=wrPulseAmp;
        % Guard against invalid names
        if ~ismember(xName, dataTable.Properties.VariableNames) || ~ismember(yName, dataTable.Properties.VariableNames)
            cla(app.DAUIAxes); return
        end
        x = dataTable.V1;
        x2 = dataTable.V2;
        y1 = dataTable.I1;
        y2 = dataTable.I2;
        I1= dataTable.I1;
        I2= dataTable.I2;
        I3= dataTable.I3;
        t=dataTable.Time1;
        
        
        areainCm=20e-6*1e2*20e-6*1e2;
        calPol = 1/areainCm*(trapz(t,I2)-trapz(t,I3))*1e6;
        
        notCompcalPol= 1/areainCm*(trapz(t,I2))*1e6;
        calPolSet = 1/areainCm*(trapz(t,I1))*1e6;
        
        

        mask=max(abs(y1))==abs(y1);

        mask2=max(abs(I2-I3))==abs(I2-I3);
        x2Val = x2(mask2);
        xVal = x(mask);
        yVal = y1(mask);
        if ~all(size(xVal)==[1 1])
            xVal = xVal(1);
            yVal = yVal(1);
            x2Val = x2Val(1);
        end
        yVals(idx) = yVal; % Store the peak y value
        xVals(idx) = xVal; % Store the corresponding x value
        x2Vals(idx) =x2Val;
        calPols(idx) = calPol;
        calPolSets(idx) =calPolSet;
        notCompcalPols(idx)=notCompcalPol;
        allTables(1,idx) =  app.DAListBox.Items(idx);
        allTables(2,idx) = {dataTable};
        allTables(3,idx) = {metaTable};
    end
    extraTable = table(xVals,yVals,calPols);
    app.DAextraTable.Data = extraTable;
    assignin("base","xVals",xVals)
    assignin("base","x2Vals",x2Vals)
    assignin("base","calPols",calPols)
    assignin("base","calPolSets",calPolSets)
    assignin("base","allTables",allTables)
    assignin("base","notCompcalPols",notCompcalPols)
    assignin("base","wrPulseAmps",wrPulseAmps)

end