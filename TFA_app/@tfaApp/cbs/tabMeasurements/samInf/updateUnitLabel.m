
function updateUnitLabel(app,src,event)
    % Map visible value to LaTeX expression
    if strcmp(src.Value, 'µm^2')
            tex = 'µ$\mathrm{m^2}$';
    elseif strcmp(src.Value, 'mm^2')
            tex = '$\mathrm{mm^2}$';
    elseif strcmp(src.Value, 'cm^2')
            tex = '$\mathrm{cm^2}$';
    else
            tex = src.Value; % fallback
    end
    app.UnitLabel.Text = ['[' tex ']'];   % Interpreter = 'latex' renders it%default'$\mathrm{mm^2}$';
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