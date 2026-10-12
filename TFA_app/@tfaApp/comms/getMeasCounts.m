function measurementCount = getMeasCounts(app)
    try
        try_count = 0;
        error_count=0;
        max_tries=10;
        while error_count<max_tries && try_count==error_count
            
            timeout = 5; t0 = tic;
            sendCmdToClient(app,app.tcpTF, "STRING:MEASUREM:COUNT?");
            while app.tcpTF.NumBytesAvailable == 0 && toc(t0) < timeout
                pause(0.05);    % short pause so UI callbacks run
                drawnow;        % ensure UI updates and callbacks execute
            end
            if app.tcpTF.NumBytesAvailable>0
                countResp = strtrim(char(read(app.tcpTF)));
                idcs = strfind(strtrim(countResp), 'STRING:');
                lastIdx = idcs(end); 
                countResp = countResp(lastIdx+length('STRING:'):end); 
                if ~isempty(regexp(strtrim(countResp), '^[0-9]+$', 'once'))
                    measurementCount = double(string(countResp));
                    break
                else
                    error_count = error_count+1;
                end
            end
            try_count=try_count+1;
        end
        



        % try_count = 0;
        % error_count=0;
        % max_tries=10;
        % while error_count<max_tries && try_count==error_count
        %     sendCmdToClient(app,app.tcpTF, "STRING:MEASUREM:COUNT?");
        %     pause(0.5);  
        %     countResp = strtrim(char(read(app.tcpTF)));
        % 
        %     idcs = strfind(strtrim(countResp), 'STRING:');
        %     lastIdx = idcs(end); 
        %     countResp = countResp(lastIdx+length('STRING:'):end); 
        %     if ~isempty(regexp(strtrim(countResp), '^[0-9]+$', 'once'))
        %         measurementCount = double(string(countResp));
        %         break
        %     else
        %         error_count = error_count+1;
        %     end
        %     try_count = try_count +1;
        %     pause(0.5)
        % end
        if isnan(measurementCount)
            warning('Failed to parse measurement count; defaulting to 1.');
            measurementCount = 1;
        end
        % ddMeasIndex.Items = arrayfun(@num2str, 1:measurementCount, 'UniformOutput', false);
    catch ME_m1
        warning('Block M1 failed: %s', ME_m1.message);
        measurementCount = 1;
    end
end