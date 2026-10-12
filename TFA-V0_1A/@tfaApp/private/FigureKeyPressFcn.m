function FigureKeyPressFcn(app, event)
    if strcmp(event.Key, 'return') && ismember('control', event.Modifier)
        if app.UIFigure.CurrentObject == app.Skript
            focus(app.SendscripttoTFA300Button);
            pause(0.05);
            focus(app.Skript);
            pause(0.05);
            SendScriptButtonPushed(app, event);
        elseif app.UIFigure.CurrentObject == app.AddtoLogTextArea
            focus(app.AddtoLogTextAreaButton);
            pause(0.05);
            focus(app.AddtoLogTextArea);
            pause(0.05);
            addToLogButtonPushed(app, event);
        else
            return
        end
    elseif strcmp(event.Key, 'return')
        if app.UIFigure.CurrentObject == app.IPv4AdressEditField 
            focus(app.PortEditField);
            app.UIFigure.CurrentObject = app.PortEditField;
        elseif app.UIFigure.CurrentObject == app.PortEditField
            focus(app.ConnectButton);
        end

    end
end
