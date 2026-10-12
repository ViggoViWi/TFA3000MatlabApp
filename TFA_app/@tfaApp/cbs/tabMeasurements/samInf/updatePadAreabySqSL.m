function updatePadAreabySqSL(app,src,event)
    % Map visible value to LaTeX expression

    factor = 1e-6;


    calcArea = app.aEditField.Value.*app.aEditField.Value.*factor;
    app.PadAreaEditField.Value = calcArea;
    app.UnitDropDown.Value = 'mm^2';
    updatePadArea(app,app.PadAreaEditField.Value,true);
end