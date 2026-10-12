    function SKFieldsWithTime(app,src,~)
if src==app.SKwpu0EditField    
    [~,app.SKwpu0EditField.Value,app.SKwpu0Unit.Text] = convertSeconds(app.SKwpu0EditField.Value,app.SKwpu0Unit.Text);
elseif src==app.SKwpuNEditField    
    [~,app.SKwpuNEditField.Value,app.SKwpuNUnit.Text] = convertSeconds(app.SKwpuNEditField.Value,app.SKwpuNUnit.Text);
elseif src==app.SKwriEditField    
    [~,app.SKwriEditField.Value,app.SKwriUnit.Text] = convertSeconds(app.SKwriEditField.Value,app.SKwriUnit.Text);
elseif src==app.SKdel2readEditField    
    [~,app.SKdel2readEditField.Value,app.SKdel2readUnit.Text] = convertSeconds(app.SKdel2readEditField.Value,app.SKdel2readUnit.Text);
elseif src==app.SKrpuEditField    
    [~,app.SKrpuEditField.Value,app.SKrpuUnit.Text] = convertSeconds(app.SKrpuEditField.Value,app.SKrpuUnit.Text);
    if app.SKResetWaveformDropDown.Value == 0
        [~,app.SKrriEditField.Value,app.SKrriUnit.Text] = convertSeconds(app.SKrpuEditField.Value,app.SKrpuUnit.Text);
    end
elseif src==app.SKrriEditField    
    [~,app.SKrriEditField.Value,app.SKrriUnit.Text] = convertSeconds(app.SKrriEditField.Value,app.SKrriUnit.Text);
elseif src==app.SKdelaytEditField    
    [~,app.SKdelaytEditField.Value,app.SKdelaytUnit.Text] = convertSeconds(app.SKdelaytEditField.Value,app.SKdelaytUnit.Text);

elseif src==app.SKSmAmprpuEditField
    [~,app.SKSmAmprpuEditField.Value,app.SKSmAmprpuUnit.Text] = convertSeconds(app.SKSmAmprpuEditField.Value,app.SKSmAmprpuUnit.Text);
    if app.SKResetWaveformDropDown.Value==0
        [~,app.SKSmAmprriEditField.Value,app.SKSmAmprriUnit.Text] = convertSeconds(app.SKSmAmprpuEditField.Value,app.SKSmAmprpuUnit.Text);
    end
        
    if app.SKWaveformDropDown.Value == 0
        [~,app.SKSmAmprriEditField.Value,app.SKSmAmprriUnit.Text] = convertSeconds(app.SKSmAmprpuEditField.Value,app.SKSmAmprpuUnit.Text);
    end
elseif src==app.SKSmAmprriEditField    
    [~,app.SKSmAmprriEditField.Value,app.SKSmAmprriUnit.Text] = convertSeconds(app.SKSmAmprriEditField.Value,app.SKSmAmprriUnit.Text);
elseif src==app.SKSmAmpdelaytEditField    
    [~,app.SKSmAmpdelaytEditField.Value,app.SKSmAmpdelaytUnit.Text] = convertSeconds(app.SKSmAmpdelaytEditField.Value,app.SKSmAmpdelaytUnit.Text);
end
end