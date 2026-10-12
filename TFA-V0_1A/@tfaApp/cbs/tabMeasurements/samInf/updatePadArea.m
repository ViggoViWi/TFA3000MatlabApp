function updatePadArea(app,src,event)
    % Map visible value to LaTeX expression
    if app.UnitDropDown.Value == 'µm^2'
            factor = 1e-6;
    elseif app.UnitDropDown.Value=='mm^2'
            factor=1;
    elseif app.UnitDropDown.Value=='cm^2'
            factor=100;
    else
        factor=0;
    end
    app.padArea = app.PadAreaEditField.Value.*factor;
    app.aEditField.Value = sqrt(app.padArea*1e6);
    app.rEditField.Value = sqrt(app.padArea*1e6/pi);
    
    sendCmdToClient(app,app.tcpTF, "STRING:sam:para:area", 'value',app.padArea);
end