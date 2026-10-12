function  SKwaveform(app,src,~)
    if src.Value ==0
        [~,app.SKrpuEditField.Value,app.SKrpuUnit.Text] = convertSeconds(app.SKrriEditField.Value,app.SKrriUnit.Text);
        app.SKrriEditField.Enable = 'off';
        app.SKrpuEditField.Enable = 'on';
    elseif src.Value ==1
        [~,app.SKrriEditField.Value,app.SKrriUnit.Text] = convertSeconds(app.SKrriEditField.Value,app.SKrriUnit.Text);
        [~,app.SKrpuEditField.Value,app.SKrpuUnit.Text] = convertSeconds(0,app.SKrpuUnit.Text);
        app.SKrriEditField.Enable = 'on';
        app.SKrpuEditField.Enable = 'off';
    end
end