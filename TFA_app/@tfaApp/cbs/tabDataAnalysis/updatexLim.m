function  updatexLim(app,src,~)
    if src.Value == "auto" || src.Value == "Auto"
        src.Value = "auto";
        updateAxis(app,[],[])
    else
        try 
            if endsWith(src.Value,"'")
                    input = strip(src.Value,"both","'");
                    lim = jsondecode(input)';
                    lim=flip(lim).*-1;
                else
                    lim = jsondecode(src.Value)';
                end
            if ~all(size(lim)==[1,2])
                uialert(app.UIFigure,"x-Limits must be ""auto"" or ""[x0,xn]""","Wrong x-Limits");
                src.Value = "auto";
                updateAxis(app,[],[])
            else
                updateAxis(app,[],[])
            end
        catch
            uialert(app.UIFigure,"x-Limits must be ""auto"" or ""[x0,xn]""","Wrong x-Limits");
            src.Value = "auto";
            updateAxis(app,[],[])
        end
    end
end