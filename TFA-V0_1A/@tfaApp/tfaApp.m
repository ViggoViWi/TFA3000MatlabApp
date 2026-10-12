%% 
classdef tfaApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure matlab.ui.Figure
        GridLayout matlab.ui.container.GridLayout

        TabGroup matlab.ui.container.TabGroup

        
        statusGrid matlab.ui.container.GridLayout
        StatusLampUIFig matlab.ui.control.Lamp
        StatusLampUIFigLabel matlab.ui.control.Label
        StatusButtonUIFig matlab.ui.control.Button

        Controller matlab.ui.container.Tab
        LogsTextArea matlab.ui.control.TextArea
        Skript matlab.ui.control.TextArea
        LogsTextAreaLabel matlab.ui.control.Label
        AddtoLogTextAreaButton matlab.ui.control.Button
        AddtoLogTextArea matlab.ui.control.TextArea
        ConnectPanel matlab.ui.container.Panel
        StatusLampControl matlab.ui.control.Lamp
        StatusLabel matlab.ui.control.Label
        StatusLampLabelControl matlab.ui.control.Label
        PortLabel matlab.ui.control.Label
        IPv4AdresseLabel matlab.ui.control.Label
        SendscripttoTFA300Button matlab.ui.control.Button
        ConnectButton matlab.ui.control.Button
        IPv4AdressEditField matlab.ui.control.EditField
        PortEditField matlab.ui.control.NumericEditField

        Measurements matlab.ui.container.Tab
        MeasurementGridLayout matlab.ui.container.GridLayout

        %%%%%%%%%%%%%%%%%%% Samp Inf %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SampInfGridLayout           matlab.ui.container.GridLayout
        SampleInformationPanel     matlab.ui.container.Panel
        UnitDropDown                 matlab.ui.control.DropDown
        UnitLabel                      matlab.ui.control.Label
        clc           matlab.ui.control.NumericEditField
        PadAreaEditField           matlab.ui.control.NumericEditField
        PadAreaLabel               matlab.ui.control.Label
        ThicknessEditField       matlab.ui.control.NumericEditField
        ThicknessEditFieldLabel  matlab.ui.control.Label
        SampleNameEditField        matlab.ui.control.EditField
        SampleNameEditFieldLabel   matlab.ui.control.Label
        % Components added for radius / side-length inputs
        rEditFieldLabel              matlab.ui.control.Label
        rEditField                   matlab.ui.control.NumericEditField
        aEditFieldLabel              matlab.ui.control.Label
        aEditField                   matlab.ui.control.NumericEditField
        micromrLabel                 matlab.ui.control.Label
        micromaLabel                 matlab.ui.control.Label
        lorRadiusLabel               matlab.ui.control.Label
        lorSqsidelengthLabel         matlab.ui.control.Label
        AdditionalsampleInformationPanel  matlab.ui.container.Panel
        ShowadditionalsampleInfCheckBox  matlab.ui.control.CheckBox

        UserNameEditField        matlab.ui.control.EditField
        UserNameEditFieldLabel   matlab.ui.control.Label
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%v

        TabGroup2                  matlab.ui.container.TabGroup

        PZMTab                        matlab.ui.container.Tab
        PZMGridLayout               matlab.ui.container.GridLayout
        
        PZMLoadWaveFormButton matlab.ui.control.Button
        PZMLoadWaveFormEditField matlab.ui.control.EditField
        
        PZMWaveFormDropDown   matlab.ui.control.DropDown
        PZMWaveFormDropDownLabel matlab.ui.control.Label

        PZMCuRangeDropDown           matlab.ui.control.DropDown
        PZMCuRangeDropDownLabel      matlab.ui.control.Label
     
        PZMPrePolDropDown            matlab.ui.control.DropDown
        PZMPrePolDropDownLabel       matlab.ui.control.Label
     
        PZMUnipCheckBox              matlab.ui.control.CheckBox

        PZMSingleLoopCheckBox        matlab.ui.control.CheckBox

        PZMFreqEditField      matlab.ui.control.NumericEditField
        PZMFreqEditFieldLabel matlab.ui.control.Label
        PZMFreqUnit            matlab.ui.control.Label

        PZMAmpEditField      matlab.ui.control.NumericEditField
        PZMAmpEditFieldLabel matlab.ui.control.Label
        PZMAmpUnit            matlab.ui.control.Label

        PZMBiasEditField      matlab.ui.control.NumericEditField
        PZMBiasEditFieldLabel matlab.ui.control.Label
        PZMBiasUnit            matlab.ui.control.Label

        PZMDelayEditField      matlab.ui.control.NumericEditField
        PZMDelayEditFieldLabel matlab.ui.control.Label
        PZMDelayUnit            matlab.ui.control.Label

        PZMRepsEditField      matlab.ui.control.NumericEditField
        PZMRepsEditFieldLabel matlab.ui.control.Label
        PZMStartMeasButton    matlab.ui.control.Button



        %DHMTab                       matlab.ui.container.Tab
        PMTab                       matlab.ui.container.Tab
        PMGridLayout                matlab.ui.container.GridLayout
        PMAmplifierDropDown         matlab.ui.control.DropDown
        PMAmplifierDropDownLabel    matlab.ui.control.Label
        PMMode                    matlab.ui.control.DropDown
        PMModeLabel               matlab.ui.control.Label
        PMSeqLabel                matlab.ui.control.Label
        PMSeqButton1                 matlab.ui.control.Button
        PMSeqButton2                 matlab.ui.control.Button
        PMSeqButton3                 matlab.ui.control.Button
        PMSeqButton4                 matlab.ui.control.Button
        PMSeqButton5                 matlab.ui.control.Button
        PMSeqButton6                 matlab.ui.control.Button
        PMSeqButton7                 matlab.ui.control.Button

        PMWaveformDropDownLabel     matlab.ui.control.Label
        PMWaveformDropDown          matlab.ui.control.DropDown

        PMWritePulsePanLabel       matlab.ui.control.Label
        PMwamLabel        matlab.ui.control.Label
        PMwamEditField    matlab.ui.control.NumericEditField
        PMwamUnit         matlab.ui.control.Label
        PMwpuLabel        matlab.ui.control.Label
        PMwpuEditField    matlab.ui.control.NumericEditField
        PMwpuUnit         matlab.ui.control.Label
        PMwriLabel        matlab.ui.control.Label
        PMwriEditField    matlab.ui.control.NumericEditField
        PMwriUnit         matlab.ui.control.Label
        PMdel2readLabel        matlab.ui.control.Label
        PMdel2readEditField    matlab.ui.control.NumericEditField
        PMdel2readUnit         matlab.ui.control.Label

        PMReadPulsePanLabel       matlab.ui.control.Label
        PMampLabel        matlab.ui.control.Label
        PMampEditField    matlab.ui.control.NumericEditField
        PMampUnit         matlab.ui.control.Label
        PMrpuLabel        matlab.ui.control.Label
        PMrpuEditField    matlab.ui.control.NumericEditField
        PMrpuUnit         matlab.ui.control.Label
        PMrriLabel        matlab.ui.control.Label
        PMrriEditField    matlab.ui.control.NumericEditField
        PMrriUnit         matlab.ui.control.Label
        PMdelaytLabel        matlab.ui.control.Label
        PMdelaytEditField    matlab.ui.control.NumericEditField
        PMdelaytUnit         matlab.ui.control.Label

        PMMonitoringPanLabel       matlab.ui.control.Label
        PMCuRangeDropDown         matlab.ui.control.DropDown
        PMCuRangeDropDownLabel    matlab.ui.control.Label

        PMStartMeasButton    matlab.ui.control.Button

        ATMTab                       matlab.ui.container.Tab
        ATMGridLayout                matlab.ui.container.GridLayout
        ATMWaveformTreatDropDownLabel     matlab.ui.control.Label
        ATMWaveformTreatDropDown          matlab.ui.control.DropDown
        ATMEcShiftLabel                   matlab.ui.control.Label
        ATMEcShiftDropDown          matlab.ui.control.DropDown
        ATMfTreatLabel             matlab.ui.control.Label
        ATMfTreatEditField        matlab.ui.control.NumericEditField
        ATMfTreatImage             matlab.ui.control.Label

        ATMCyclesLabel               matlab.ui.control.Label
        ATMCyclesDropDown           matlab.ui.control.DropDown

        ATMAmp0LabelPos               matlab.ui.control.Label
        ATMAmp0EditFieldPos           matlab.ui.control.NumericEditField
        ATMAmp0LabelNeg            matlab.ui.control.Label
        ATMAmp0EditFieldNeg           matlab.ui.control.NumericEditField
        ATMAmpnLabelPos               matlab.ui.control.Label
        ATMAmpnEditFieldPos           matlab.ui.control.NumericEditField
        ATMAmpnLabelNeg               matlab.ui.control.Label
        ATMAmpnEditFieldNeg           matlab.ui.control.NumericEditField
        ATMAmpnUnit                matlab.ui.control.Label
        ATMAmpShiftperDecLabel               matlab.ui.control.Label
        ATMAmpShiftperDecEditField           matlab.ui.control.NumericEditField
        ATMAmpShiftperDecUnit                matlab.ui.control.Label

        ATMReadperDecLabel               matlab.ui.control.Label
        ATMReadperDecEditField           matlab.ui.control.NumericEditField
        ATMresetAmpReadLabel         matlab.ui.control.Label
        ATMresetAmpReadEditField     matlab.ui.control.NumericEditField
        
        ATMCuRangeDropDown         matlab.ui.control.DropDown
        ATMCuRangeDropDownLabel    matlab.ui.control.Label
        ATMoutFolderLabel         matlab.ui.control.Label
        ATMoutFolderEditField     matlab.ui.control.EditField
        ATMbaseFileNameLabel         matlab.ui.control.Label
        ATMbaseFileNameEditField     matlab.ui.control.EditField
        
        ATMReadSeqLabel              matlab.ui.control.Label
        ATMSeqImage1                 matlab.ui.control.Image
        ATMSeqImage2                 matlab.ui.control.Image
        ATMSeqImage3                 matlab.ui.control.Image
        ATMSeqImage4                 matlab.ui.control.Image
        ATMSeqImage5                 matlab.ui.control.Image
        ATMSeqImage6                 matlab.ui.control.Image
        ATMSeqImage7                 matlab.ui.control.Image

        saveInOneFileCheckBox        matlab.ui.control.CheckBox

        ATMStartMeasButton    matlab.ui.control.StateButton

        ATMImage              matlab.ui.control.Image

        SKMTab                       matlab.ui.container.Tab
        SKGridLayout                matlab.ui.container.GridLayout
        SKAmplifierDropDown         matlab.ui.control.DropDown
        SKAmplifierDropDownLabel    matlab.ui.control.Label
        SKMode                      matlab.ui.control.DropDown
        SKModeLabel                 matlab.ui.control.Label
        SKSetDir                    matlab.ui.control.DropDown
        SKSetDirLabel                 matlab.ui.control.Label
        SKSeqLabel                  matlab.ui.control.Label
        SKSeqButton1                 matlab.ui.control.Button
        SKSeqButton2                 matlab.ui.control.Button
        SKSeqButton3                 matlab.ui.control.Button
        SKSeqButton4                 matlab.ui.control.Button
        SKSeqButton5                 matlab.ui.control.Button
        SKSeqButton6                 matlab.ui.control.Button
        SKSeqButton7                 matlab.ui.control.Button
        SKWaveformDropDownLabel     matlab.ui.control.Label
        SKWaveformDropDown          matlab.ui.control.DropDown
        SKSmAmpWaveformDropDownLabel     matlab.ui.control.Label
        SKSmAmpWaveformDropDown          matlab.ui.control.DropDown
        SKResetWaveformDropDownLabel     matlab.ui.control.Label
        SKResetWaveformDropDown          matlab.ui.control.DropDown

        SKProcPerPWEditField     matlab.ui.control.NumericEditField
        SKProcPerPWDecadeEditField matlab.ui.control.NumericEditField
        SKProcPerPWLabel     matlab.ui.control.Label
        SKProcPerPWDecadeLabel matlab.ui.control.Label

        SKWritePulsePanLabel       matlab.ui.control.Label
        SKwamLabel        matlab.ui.control.Label
        SKwamEditField    matlab.ui.control.NumericEditField
        SKwamUnit         matlab.ui.control.Label
        SKwpu0Label        matlab.ui.control.Label
        SKwpu0EditField    matlab.ui.control.NumericEditField
        SKwpu0Unit         matlab.ui.control.Label
        SKwpuNLabel        matlab.ui.control.Label
        SKwpuNEditField    matlab.ui.control.NumericEditField
        SKwpuNUnit         matlab.ui.control.Label
        SKwriLabel        matlab.ui.control.Label
        SKwriEditField    matlab.ui.control.NumericEditField
        SKwriUnit         matlab.ui.control.Label
        SKdel2readLabel        matlab.ui.control.Label
        SKdel2readEditField    matlab.ui.control.NumericEditField
        SKdel2readUnit         matlab.ui.control.Label
        
        SKSmAmpPanLabel       matlab.ui.control.Label
        SKSmAmpampLabel        matlab.ui.control.Label
        SKSmAmpampEditField    matlab.ui.control.NumericEditField
        SKSmAmpampUnit         matlab.ui.control.Label
        SKSmAmprpuLabel        matlab.ui.control.Label
        SKSmAmprpuEditField    matlab.ui.control.NumericEditField
        SKSmAmprpuUnit         matlab.ui.control.Label
        SKSmAmprriLabel        matlab.ui.control.Label
        SKSmAmprriEditField    matlab.ui.control.NumericEditField
        SKSmAmprriUnit         matlab.ui.control.Label
        SKSmAmpdelaytLabel        matlab.ui.control.Label
        SKSmAmpdelaytEditField    matlab.ui.control.NumericEditField
        SKSmAmpdelaytUnit         matlab.ui.control.Label

        SKReadPulsePanLabel       matlab.ui.control.Label
        SKampLabel        matlab.ui.control.Label
        SKampEditField    matlab.ui.control.NumericEditField
        SKampUnit         matlab.ui.control.Label
        SKrpuLabel        matlab.ui.control.Label
        SKrpuEditField    matlab.ui.control.NumericEditField
        SKrpuUnit         matlab.ui.control.Label
        SKrriLabel        matlab.ui.control.Label
        SKrriEditField    matlab.ui.control.NumericEditField
        SKrriUnit         matlab.ui.control.Label
        SKdelaytLabel        matlab.ui.control.Label
        SKdelaytEditField    matlab.ui.control.NumericEditField
        SKdelaytUnit         matlab.ui.control.Label

        SKMonitoringPanLabel       matlab.ui.control.Label
        SKCuRangeDropDown         matlab.ui.control.DropDown
        SKCuRangeDropDownLabel    matlab.ui.control.Label
        SKSmAmpCuRangeDropDown         matlab.ui.control.DropDown
        SKSmAmpCuRangeDropDownLabel    matlab.ui.control.Label
        SKResetCuRangeDropDown         matlab.ui.control.DropDown
        SKResetCuRangeDropDownLabel    matlab.ui.control.Label
        SKoutFolderLabel         matlab.ui.control.Label
        SKoutFolderEditField     matlab.ui.control.EditField
        SKbaseFileNameLabel         matlab.ui.control.Label
        SKbaseFileNameEditField     matlab.ui.control.EditField
        SKSmAmpCheckBox             matlab.ui.control.CheckBox

        SKQuickView             matlab.ui.control.UIAxes                 

        SKStartMeasButton       matlab.ui.control.Button
        
        DataAnalysis matlab.ui.container.Tab
        DAGridLayout                 matlab.ui.container.GridLayout
        DAXAxisLabel                 matlab.ui.control.Label
        DAYAxisLabel                 matlab.ui.control.Label
        DADropDown_y1                 matlab.ui.control.DropDown
        DADropDown_y2                 matlab.ui.control.DropDown
        DADropDown_x1                  matlab.ui.control.DropDown
        DAxLimLabel                 matlab.ui.control.Label
        DAxLimEdFi                  matlab.ui.control.EditField
        DAyLimLabel                 matlab.ui.control.Label
        DAy1LimEdFi                  matlab.ui.control.EditField
        DAy2LimEdFi                  matlab.ui.control.EditField
        DASelTFADataLabel       matlab.ui.control.Label
        DASelTFADataEditField        matlab.ui.control.EditField
        DASelLocalDataEditField      matlab.ui.control.EditField
        DASelLocalDataButton         matlab.ui.control.Button

        DAListBox                    matlab.ui.control.ListBox
        DAListBoxLabel               matlab.ui.control.Label
        
        DAUITable2                   matlab.ui.control.Table
        DAUITable                    matlab.ui.control.Table
        DAUIAxes                     matlab.ui.control.UIAxes
        DAClearButton                matlab.ui.control.Button
        DAClearAllButton             matlab.ui.control.Button
        DAdeveBtn                   matlab.ui.control.Button
        DAextraTable                matlab.ui.control.Table

        DASaveButton                matlab.ui.control.Button
        DASaveAllButton                matlab.ui.control.Button
    end

    properties (Access = private)
        connectionStatus = false; % Description
        tcpTF;
        padArea double;
        PMwpu double;
        PMwri double;
        PMdel2read double;
        PMrpu double;
        PMdelayt double;
        
        dataBuffer cell;
        swKinSetDataBuffer cell;
        swKinSmAmpDataBuffer cell;
        swKinResetDataBuffer cell;
        logFileID;
    end

    properties (Access = public)
        measRunning logical=false;
        measStopped logical=false;
        currPWD = fileparts(mfilename("fullpath"));
        logDir = fileparts(mfilename("fullpath")) + "/logs";
        expDataDir = fileparts(mfilename("fullpath")) + "/expData";
        logPath = fullfile(fileparts(mfilename("fullpath")) + "/logs", "log.txt"); %<
        echo logical=false; % This Deafult variable is important. True if you want to write code not connected with the TFA3000 and false if you are connected with it.
        returnEcho logical=false;
        WaveFormLoadedStatus logical=false;
        WaveFormLoadedName ="";
        WaveFormLoadedPath ="";
        PMSeq (1,7) char = '-------';
    end

    methods (Access = public)
        function app = tfaApp
            createComponents(app)
            try
                dirs = genpath(app.currPWD);
                dirsCell = regexp(dirs, pathsep, 'split');
                dirsCell = dirsCell(~cellfun('isempty', dirsCell));
                dirsCell = dirsCell(cellfun('isempty', regexp(dirsCell, '[\\/]\@[^\\/]+$', 'once')));
                dirs = strjoin(dirsCell, pathsep);
                addpath(dirs)
            catch ME
                error("Error for addpath",ME.msg)
            end

            registerApp(app, app.UIFigure)
            logInit(app)
            focus(app.IPv4AdressEditField);
            

            if nargout == 0
                clear app
            end
        end

        function delete(app)
            delete(app.UIFigure)
        end
    end
end
