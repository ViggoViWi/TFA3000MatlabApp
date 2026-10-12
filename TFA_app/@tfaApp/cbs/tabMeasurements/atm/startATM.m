function startATM(app,src,~)
    function fileSaveText=fktFileSaveText(app,cC)
            if app.saveInOneFileCheckBox.Value
                fileSaveText = "" +...
                newline+"STRING:file:save " + """"+app.ATMoutFolderEditField.Value+app.ATMbaseFileNameEditField.Value+""""+...
                newline+"STRING:file:export " + """"+app.ATMoutFolderEditField.Value+app.ATMbaseFileNameEditField.Value+".dat"+"""";
            else
                fileSaveText = "" +...
                newline+"STRING:file:save " + """"+app.ATMoutFolderEditField.Value+app.ATMbaseFileNameEditField.Value+"_Cycle"+cC+""""+...
                newline+"STRING:file:export " + """"+app.ATMoutFolderEditField.Value+app.ATMbaseFileNameEditField.Value+"_Cycle"+cC+".dat"+"""";
            end
    end
    function ReadText = fktReadText(app,ampPos,ampNeg)
        if strcmp(app.ATMEcShiftDropDown.Value ,"M-polarity")
            PMseq = "-Y-PU--";%"0-XU---"; %"0XUNDP-";
            writeAmp = ampNeg;
            readAmp = ampPos;
        elseif strcmp(app.ATMEcShiftDropDown.Value ,"N-polarity")
            PMseq= "-X-ND--";%"1-YD---";%"1YDPUN-";
            writeAmp = ampPos;
            readAmp = ampNeg;
        end
        ReadText= ""+...
                "STRING:para:PM:pulseseq "+PMseq+newline+...
                "STRING:para:PM:waveform 1"+newline+...
                "STRING:para:PM:wam "+abs(writeAmp)+newline+...
                "STRING:para:PM:wpu 25e-8"+newline+...
                "STRING:para:PM:wri "+string(1/(4*app.ATMfTreatEditField.Value*1000))+newline+...
                "STRING:para:PM:read "+string(500e-6)+newline+...
                "STRING:para:PM:amp "+abs(readAmp)+newline+...
                "STRING:para:PM:rri "+string(1/(4*app.ATMfTreatEditField.Value*1000))+newline+...
                "STRING:para:PM:delayt "+string(500e-6)+newline+...
                "STRING:para:PM:curr "+app.ATMCuRangeDropDown.Value+newline;
    end
    function TreatText = fktTreatText(app,treataftread,Vamp,Bias,Reps)
        if strcmp(app.ATMEcShiftDropDown.Value ,"M-polarity")
            Vamp=-1*Vamp;
        end
        if treataftread % Everything has to be set again, since another mode was used.
            if Reps==1
                TreatText = "STRING:mode PZM"+newline+...
                    "STRING:para:PZM:freq "+ string(app.ATMfTreatEditField.Value*1000)+newline+...
                    "STRING:para:PZM:waveform triangle"+newline+...
                    "STRING:para:PZM:amp "+sprintf("%.2f", Vamp)+newline+...
                    "STRING:para:PZM:repetitions 1"+newline+...
                    "STRING:para:PZM:delayt 0.05"+newline+...
                    "STRING:para:PZM:single 1" + newline+...
                    "STRING:para:PZM:prep switching" + newline+...
                    "STRING:para:PZM:unip 0" + newline+...
                    "STRING:para:PZM:bia " + sprintf("%.2f",Bias)+ newline+...
                    "STRING:para:PZM:prep disabled" + newline+...
                    "STRING:para:PZM:curr "+ app.ATMCuRangeDropDown.Value+newline;
            elseif Reps == 2
                TreatText = "STRING:mode PZM"+newline+...
                    "STRING:para:PZM:freq "+ string(app.ATMfTreatEditField.Value*1000)+newline+...
                    "STRING:para:PZM:waveform triangle"+newline+...
                    "STRING:para:PZM:amp "+sprintf("%.2f", Vamp)+newline+...
                    "STRING:para:PZM:repetitions  "+string(Reps-1)+newline+...
                    "STRING:para:PZM:delayt 0.05"+newline+...
                    "STRING:para:PZM:single 1" + newline+...
                    "STRING:para:PZM:prep switching" + newline+...
                    "STRING:para:PZM:unip 0" + newline+...
                    "STRING:para:PZM:bia " + sprintf("%.2f",Bias)+ newline+...
                    "STRING:para:PZM:curr "+ app.ATMCuRangeDropDown.Value+newline;
            else 
                TreatText = "STRING:mode PZM"+newline+...
                    "STRING:para:PZM:freq "+ string(app.ATMfTreatEditField.Value*1000)+newline+...
                    "STRING:para:PZM:waveform triangle"+newline+...
                    "STRING:para:PZM:amp "+sprintf("%.2f", Vamp)+newline+...
                    "STRING:para:PZM:repetitions "+string(Reps-1)+newline+...
                    "STRING:para:PZM:delayt 0"+newline+...
                    "STRING:para:PZM:single 1" + newline+...
                    "STRING:para:PZM:prep switching" + newline+...
                    "STRING:para:PZM:unip 0" + newline+...
                    "STRING:para:PZM:bia " + sprintf("%.2f",Bias)+ newline+...
                    "STRING:para:PZM:curr "+ app.ATMCuRangeDropDown.Value+newline;
            end
        else % Base Parameters are already loaded. Only Bias, Reps, prep and Amp has to be adjusted
            if Reps==1
                TreatText = "STRING:mode PZM"+newline+...
                    "STRING:para:PZM:amp "+sprintf("%.2f", Vamp)+newline+...
                    "STRING:para:PZM:repetitions "+string(Reps)+newline+...
                    "STRING:para:PZM:delayt 0.05"+newline+...
                    "STRING:para:PZM:prep switching" + newline+...
                    "STRING:para:PZM:bia " + sprintf("%.2f",Bias)+ newline+...
                    "STRING:para:PZM:prep disabled" + newline;
            elseif Reps ==2
                TreatText = "STRING:mode PZM"+newline+...
                    "STRING:para:PZM:amp "+sprintf("%.2f", Vamp)+newline+...
                    "STRING:para:PZM:repetitions "+string(Reps-1)+newline+...
                    "STRING:para:PZM:delayt 0.05"+newline+...
                    "STRING:para:PZM:prep switching" + newline+...
                    "STRING:para:PZM:bia " + sprintf("%.2f",Bias)+ newline;
            else 
                TreatText = "STRING:mode PZM"+newline+...
                    "STRING:para:PZM:amp "+sprintf("%.2f", Vamp)+newline+...
                    "STRING:para:PZM:repetitions "+string(Reps-1)+newline+...
                    "STRING:para:PZM:delayt 0"+newline+...
                    "STRING:para:PZM:prep switching" + newline+...
                    "STRING:para:PZM:bia " + sprintf("%.2f",Bias)+ newline;
            end
        end
    end

    function treatLogText(app,reps, cc, Vamp, Bias)
        if reps==1
            logText = sprintf("// CYCLE %s  Amp: %.2f  Bias: %.2f",string(cc),Vamp(cc),Bias(cc))+newline;
        elseif reps==2
            logText = sprintf("// CYCLE %s AND %s  Amp: %.2f  Bias: %.2f",string(cc-reps+1),string(cc),Vamp(cc),Bias(cc))+newline;
        else 
            logText = sprintf("// CYCLE FROM %s TO %s  Amp: %.2f  Bias: %.2f",string(cc-reps+1),string(cc),Vamp(cc),Bias(cc))+newline;
        end
        addToLog(app,logText)
    end
 
    
    
    sampleInf="STRING:sam:para:name "+app.SampleNameEditField.Value+newline + ...
                "STRING:sam:para:are "+app.PadAreaEditField.Value+newline + ...
                "STRING:sam:para:thi "+app.ThicknessEditField.Value+newline+newline;            

    clearAndModePZM=newline + ...
        "STRING:clear" + newline + ...
        "STRING:mode PZM" + newline;

    if app.saveInOneFileCheckBox.Value
        clearAndModePM=newline + ...
        "STRING:clear" + newline + ...
        "STRING:mode PM" + newline+...
        sprintf("STRING:file:OPE ""%s%s.tfp""",app.ATMoutFolderEditField.Value,app.ATMbaseFileNameEditField.Value)+newline+...
        "STRING:file:SELEC pm"+ newline;
    else
        clearAndModePM=newline + ...
        "STRING:clear" + newline + ...
        "STRING:mode PM" + newline + ...
        "STRING:file:SELEC pm"+ newline;
    end
    
    
    if src==app.ATMStartMeasButton % The callback comes from the Start Meas. Button
        if src.Value
            src.Text = "Stop ATM";
        % Safe close of app.logFileID
        % MATLAB fids for opened files are >= 3
        if ~isempty(app.logFileID) && isnumeric(app.logFileID) && app.logFileID >= 3 && any(app.logFileID==openedFiles()) 
            fclose(app.logFileID);
        end
        app.logFileID = fopen(app.logPath, 'a');
        if app.logFileID == -1
            error('Cannot open log file.');
        end

        updateMeasRunningStatus(app,src,true);
        
        decadeSlopePosTreat = (app.ATMAmpnEditFieldPos.Value-app.ATMAmp0EditFieldPos.Value)/log10(str2double(app.ATMCyclesDropDown.Value)); % 
        decadeSlopeNegTreat = (app.ATMAmpnEditFieldNeg.Value-app.ATMAmp0EditFieldNeg.Value)/log10(str2double(app.ATMCyclesDropDown.Value)); % 
        VampPosTreat = log10(1:str2double(app.ATMCyclesDropDown.Value)).*decadeSlopePosTreat+app.ATMAmp0EditFieldPos.Value; %
        VampNegTreat = log10(1:str2double(app.ATMCyclesDropDown.Value)).*decadeSlopeNegTreat+app.ATMAmp0EditFieldNeg.Value; %
        VampTreat = (VampPosTreat-VampNegTreat)./2;
        assignin('base','VampTreat',VampTreat);
        biasTreat = VampPosTreat-VampTreat;
        applVamp = zeros(1,numel(VampTreat));

        cycleCounter = 0;

        scales = 10.^(1:log10(str2double(app.ATMCyclesDropDown.Value)));
        readCycles = unique([1,ceil(reshape((1:app.ATMReadperDecEditField.Value)'*(scales./app.ATMReadperDecEditField.Value),1,[]))]);
        treatModeAfterRead=false;
        readModeAfterTreat=true;
           
        sendCmdToClient(app,app.tcpTF, sampleInf,'logClosedl8r',true)
        w84TF(app);

        
        
        
        % From 1 to NCycles
         app.measStopped = false;
         
         assignin('base','app',app)

         assignin('base','readCycles',readCycles)
         while  cycleCounter<str2double(app.ATMCyclesDropDown.Value)
             if ~src.Value
                 app.measStopped=true;
                break
             end
               
            incr=max(1,min(10^ceil(log10(cycleCounter+1))/10,1000)); % 1 if cycleCounter <101, 10 if cycleCounter<1001, 100 if cycleCounter<1e4 and 1000 if cycleCounter >= 1e5
            
            mask=readCycles>cycleCounter & readCycles<= cycleCounter+incr; % Creates an logic array, at which point exactly is the read cycle
            
            if any(mask)
                value=readCycles(mask); % The CycleNumber of the read cycle.
                reps=value-cycleCounter-1; % Evaluate how many Treatment repetitions are needed until the read cycle
            else
                reps=incr; % If reps > incr, then set reps to incr
            end
            
            app.measRunning = true;
            if reps==0 % Now is the read procedure
                % READ PROCEDURE
                cycleCounter=cycleCounter+1;
                disp("Read Cycle: "+string(cycleCounter))
                readModeAfterTreat=false;
                sendCmdToClient(app,app.tcpTF, clearAndModePM, 'logClosedl8r', true);
                w84TF(app);
                ReadParas = fktReadText(app,VampPosTreat(cycleCounter), VampNegTreat(cycleCounter));

                addToLog(app, "// CYCLE "+cycleCounter+" READ PROCEDURE" + newline);
                sendCmdToClient(app,app.tcpTF, ReadParas, 'logClosedl8r', true);
                pause(0.2);
                w84TF(app);
                sendCmdToClient(app,app.tcpTF, clearAndModePM, 'logClosedl8r', true);
                w84TF(app);
                sendCmdToClient(app,app.tcpTF, ReadParas, 'logClosedl8r', true);
                w84TF(app);
                measComplQuery(app,src);
                w84TF(app);
                pause(0.05);
                [ID, ~, ~] = getSelecFile(app);
                sendCmdToClient(app,app.tcpTF,"STRING:file:selec ", 'value', ID, 'logClosedl8r', true);
                w84TF(app);
                saveFText = fktFileSaveText(app,cycleCounter);
                sendCmdToClient(app,app.tcpTF,saveFText, 'logClosedl8r', true);
                w84TF(app);
                sendCmdToClient(app,app.tcpTF,"STRING:measurem:selec pm,1", 'logClosedl8r', true);
                w84TF(app);
                pause(0.05);
                [~,uint8Data,~]=getASCIIdata(app);
                pause(0.05)
                dataReceived(app,uint8Data,'cycleCounter',cycleCounter,'mode','atm');

                w84TF(app);
                
                treatModeAfterRead=true; 
                gotID = false;
                applVamp(cycleCounter)=VampTreat(cycleCounter);
            else 
                sendCmdToClient(app,app.tcpTF,clearAndModePZM, 'logClosedl8r', true);
                w84TF(app);
                % TREATMENT with calculated repetitions
                    cycleCounter=cycleCounter+reps;
                    treatLogText(app,reps, cycleCounter, VampTreat, biasTreat)
                    if treatModeAfterRead
                        sendCmdToClient(app,app.tcpTF,"STRING:file:selec pzm", 'logClosedl8r', true); 
                    end

                    sendCmdToClient(app,app.tcpTF,"STRING:mode pzm", 'logClosedl8r', true); 
                    w84TF(app);
                    TreatParas=fktTreatText(app,treatModeAfterRead,VampTreat(cycleCounter),biasTreat(cycleCounter),reps);
                    treatModeAfterRead=false;
                    sendCmdToClient(app,app.tcpTF, TreatParas, 'logClosedl8r', true);
                    
                    w84TF(app);
                    if reps ==1
                        cycleSpanText = sprintf("%d, ",(cycleCounter));
                    elseif reps == 2 
                        cycleSpanText = sprintf("%d and %d, ",(cycleCounter-reps+1),cycleCounter);
                    else
                        cycleSpanText = sprintf("%d to %d, ",(cycleCounter-reps+1),cycleCounter);
                    end
                    disp("Treat CYCLE "+ cycleSpanText +sprintf("Amp: %.2f,  Bias: %.2f",VampTreat(cycleCounter),biasTreat(cycleCounter)));
                    pause(0.5)
                    measComplQuery(app,src);
                    readModeAfterTreat=true;
                    
                    applVamp(cycleCounter-reps+1:cycleCounter)=VampTreat(cycleCounter);
                    
                    
                    
            end
         end
        assignin('base','applVamp',applVamp)
        assignin('base','VampPosTreat',VampPosTreat)
        assignin('base','VampNegTreat',VampNegTreat)
         VampTreat(cycleCounter-reps+1:cycleCounter)=VampTreat(cycleCounter);
        biasTreat(cycleCounter-reps+1:cycleCounter)=biasTreat(cycleCounter);
        VampPosTreat(cycleCounter-reps+1:cycleCounter) = biasTreat(cycleCounter) + VampTreat(cycleCounter); 
        VampNegTreat(cycleCounter-reps+1:cycleCounter) = biasTreat(cycleCounter) - VampTreat(cycleCounter); 
        assignin('base','VampPosTreatAppl',VampPosTreat)
        assignin('base','VampNegTreatAppl',VampNegTreat)
        cycNo=10.^(log10(1:str2double(app.ATMCyclesDropDown.Value)));
        assignin('base','cycNo',cycNo)
         if  app.measStopped
                disp("Measurement got stopped");
                app.measStopped =false; %reset to false
                fclose(app.logFileID);
                app.logFileID = [];
                src.Value=0;
                src.Text = "Start ATM";
                return
         elseif ge(cycleCounter,str2double(app.ATMCyclesDropDown.Value))
                    disp("ATM complete");
                    src.Value=0;
                    src.Text = "Start ATM";
                    updateMeasRunningStatus(app,src,false);
                    fclose(app.logFileID);
                    app.logFileID = [];
                    return
         end
        else % STOP PRESSED
            src.Text = "Start ATM";
            updateMeasRunningStatus(app,src, false);
            sendCmdToClient(app,app.tcpTF, "STRING:STOP");
            disp("stop")
        end
        
    end
end