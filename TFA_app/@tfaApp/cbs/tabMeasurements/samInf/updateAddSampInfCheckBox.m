function updateAddSampInfCheckBox(app,src,event)
    if app.ShowadditionalsampleInfCheckBox.Value
        app.AdditionalsampleInformationPanel.Visible = 'on';
    else 
        app.AdditionalsampleInformationPanel.Visible = 'off';
    end

end