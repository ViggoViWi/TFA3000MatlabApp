function logInit(app)
    if ~exist(app.logDir, "dir")
        mkdir(app.logDir)
    end
    if ~exist(app.expDataDir, "dir")
        mkdir(app.expDataDir)
    end
    if ~exist(app.logPath, "file")
        fid = fopen(app.logPath, "w");
        if fid == -1
            error("Cannot create file: %s", fullpath);
        end
        fclose(fid);
        logText(app,'%s: %s \n%s\n', datestr(now, 0), "Log-File created. Path of Log-File:", app.logPath);
    else
        logText(app,'\n\n\n%s: %s \n%s\n', datestr(now, 0), "Log-Session started. Path of Log-File:", app.logPath);
    end
end
