function updateUserName(app,src,~)
    dateStr = datestr(datetime('today'),'yyyymmdd');
    user = src.Value;
    app.SKoutFolderEditField.Value = sprintf("D:/Measurements/%s/SwitchingKinetics/%s/",user,dateStr);
end