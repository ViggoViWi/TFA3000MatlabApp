function updatePadAreaCircR(app,src,event)
    % Map visible value to LaTeX expression

    factor = 1e-6;

    calcArea = pi*app.rEditField.Value.*app.rEditField.Value.*factor;
    app.PadAreaEditField.Value = calcArea;
    app.UnitDropDown.Value = 'mm^2';
    updatePadArea(app,app.PadAreaEditField.Value,true);

end