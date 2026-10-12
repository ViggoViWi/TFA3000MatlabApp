function updateAxis(app,~,~)
    app.DAUIAxes.Visible ="on";
    % Get selected column names
    xName = app.DADropDown_x1.Value;
    y1Name = app.DADropDown_y1.Value;
    y2Name = app.DADropDown_y2.Value;

    % Get table data (assumes uitable Data is a table)
    t = app.DAUITable2.Data;
    if isempty(t) || ~istable(t)
        yyaxis(app.DAUIAxes,'left'); cla(app.DAUIAxes)   % clears left side
        yyaxis(app.DAUIAxes,'right'); cla(app.DAUIAxes)  % clears right side
        return
    end

    % Guard against invalid names
    if ~ismember(xName, t.Properties.VariableNames) || ~ismember(y1Name, t.Properties.VariableNames)
        yyaxis(app.DAUIAxes,'left'); cla(app.DAUIAxes)   % clears left side
        yyaxis(app.DAUIAxes,'right'); cla(app.DAUIAxes)  % clears right side
        return
    end

    x = t.(xName);
    y1 = t.(y1Name);

    % y2 may be empty/invalid - handle gracefully
    hasY2 = ~isempty(y2Name) && ismember(y2Name, t.Properties.VariableNames);
    if hasY2
        y2 = t.(y2Name);
    end

    % Convert x for plotting
    if isdatetime(x) || isduration(x)
        xplot = datenum(x);
        xlabelStr = xName;
        isXDate = true;
    elseif iscategorical(x) || isstring(x) || iscellstr(x)
        xplot = double(categorical(x));
        xlabelStr = xName;
        isXDate = false;
    else
        xplot = double(x);
        xlabelStr = xName;
        isXDate = false;
    end

    % Convert y1
    if isdatetime(y1) || isduration(y1)
        y1plot = datenum(y1);
    elseif iscategorical(y1) || isstring(y1) || iscellstr(y1)
        y1plot = double(categorical(y1));
    else
        y1plot = double(y1);
    end

    % Convert y2 if present
    if hasY2
        if isdatetime(y2) || isduration(y2)
            y2plot = datenum(y2);
        elseif iscategorical(y2) || isstring(y2) || iscellstr(y2)
            y2plot = double(categorical(y2));
        else
            y2plot = double(y2);
        end
    end

    % Clear axes and plot
    cla(app.DAUIAxes);

    % Left axis: y1
    yyaxis(app.DAUIAxes,'left')
    plot(app.DAUIAxes, xplot, y1plot, '.-');
    ylabel(app.DAUIAxes, y1Name);
    if ~strcmp(app.DAy1LimEdFi.Value,"auto")

        if endsWith(app.DAy1LimEdFi.Value,"'")
            temp=strip(app.DAy1LimEdFi.Value,"both","'");
            ylim(app.DAUIAxes, flip(jsondecode(temp)').*-1)
        else
        ylim(app.DAUIAxes, jsondecode(app.DAy1LimEdFi.Value)')
        end
    else
        app.DAUIAxes.YLimMode = 'auto';
    end

    % If y2 exists, plot on right axis and show its label on the right
    if hasY2
        hold(app.DAUIAxes,'on');           % hold affects both sides
        yyaxis(app.DAUIAxes,'right')
        if ~strcmp(app.DAy2LimEdFi.Value,"auto")
            if endsWith(app.DAy2LimEdFi.Value,"'")
            temp=strip(app.DAy2LimEdFi.Value,"both","'");
            ylim(app.DAUIAxes, flip(jsondecode(temp)').*-1)
        else
            ylim(app.DAUIAxes, jsondecode(app.DAy2LimEdFi.Value)')
        end
        else
            app.DAUIAxes.YLimMode = 'auto';
        end
        plot(app.DAUIAxes, xplot, y2plot, '.-');
        ylabel(app.DAUIAxes, y2Name);      % right-side label
        hold(app.DAUIAxes,'off');
    end

    % Common formatting
    grid(app.DAUIAxes,'on');
    xlabel(app.DAUIAxes, xlabelStr);

    % If x was datetime/duration, convert ticks back to datetime
    if isXDate
        % Convert numeric ticks to datetimes for display
        xt = get(app.DAUIAxes,'XTick');
        xt_dt = datetime(xt,'ConvertFrom','datenum');
        xticklabels(app.DAUIAxes, cellstr(datestr(xt_dt)));
    end
    if ~strcmp(app.DAxLimEdFi.Value,"auto")
        if endsWith(app.DAxLimEdFi.Value,"'")
            temp=strip(app.DAxLimEdFi.Value,"both","'");
            xlim(app.DAUIAxes, flip(jsondecode(temp)').*-1)
        else
            xlim(app.DAUIAxes, jsondecode(app.DAxLimEdFi.Value)')
        end
    else
        app.DAUIAxes.XLimMode = 'auto';
    end

end
