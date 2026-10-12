function createComponents(app)
    app.UIFigure = uifigure('Visible', 'off');
    pause(0.05)
    app.UIFigure.WindowState="maximized";
    app.UIFigure.Name = 'MATLAB Refractored App';
    app.UIFigure.WindowKeyPressFcn = createCallbackFcn(app, @FigureKeyPressFcn, true);
    % app.UIFigure.CloseRequestFcn = @(src,event) delete(app);

    % Top-level horizontal layout: TabGroup left (stretch), status area right (auto)
    app.GridLayout = uigridlayout(app.UIFigure, [1 2]);
    app.GridLayout.RowHeight      = {'1x'};
    app.GridLayout.ColumnWidth   = {'1x','fit'};   % left stretches, right sized to content
    app.GridLayout.Padding       = [6 6 6 6];
    app.GridLayout.ColumnSpacing = 8;
    
    % Put the TabGroup into the left column (stretch)
    app.TabGroup = uitabgroup(app.GridLayout);
    app.TabGroup.Layout.Row = 1;
    app.TabGroup.Layout.Column = 1;
    
    % Create a small grid in the right (auto) column for label + lamp, aligned top
    statusGrid = uigridlayout(app.GridLayout, [2 2]);
    statusGrid.Layout.Row    = 1;
    statusGrid.Layout.Column = 2;
    statusGrid.ColumnWidth     = {50,'fit'};
    statusGrid.RowHeight   = {110,'fit'};   % label + lamp sized to content
    statusGrid.Padding       = [0 0 0 0];
    statusGrid.ColumnSpacing = 1;
    
    app.StatusButtonUIFig = uibutton(statusGrid);
    app.StatusButtonUIFig.Layout.Row = 1;
    app.StatusButtonUIFig.Layout.Column = 1;
    app.StatusButtonUIFig.Tooltip = "Status: Disconnected";
    app.StatusButtonUIFig.Icon = fullfile(app.currPWD, 'images', 'disconnected.png');
    app.StatusButtonUIFig.Text ="";
    app.StatusButtonUIFig.ButtonPushedFcn = createCallbackFcn(app, @ConnectButtonPushed, true);




    app.Controller = uitab(app.TabGroup);
    app.Controller.Title = 'Controller';

    app.ConnectPanel = uipanel(app.Controller);
    app.ConnectPanel.Title = 'Connect';
    app.ConnectPanel.Position = [45 413 260 147];

    app.IPv4AdressEditField = uieditfield(app.ConnectPanel, 'text');
    app.IPv4AdressEditField.HorizontalAlignment = 'right';
    app.IPv4AdressEditField.Position = [151 96 102 22];
    if app.echo
        app.IPv4AdressEditField.Value = 'localhost';
    else
        app.IPv4AdressEditField.Value = '192.168.6.2';
    end
    
    app.IPv4AdressEditField.ValueChangedFcn=@(src,event) focus(app.PortEditField);
    

    app.PortEditField = uieditfield(app.ConnectPanel, 'numeric');
    app.PortEditField.Position = [151 64 102 22];
    app.PortEditField.Value = 2000;

    app.ConnectButton = uibutton(app.ConnectPanel, 'push');
    app.ConnectButton.ButtonPushedFcn = createCallbackFcn(app, @ConnectButtonPushed, true);
    app.ConnectButton.Position = [81 19 100 22];
    app.ConnectButton.Text = 'Connect';

    app.PortEditField.ValueChangedFcn=@(src,event) focus(app.ConnectButton);
    
    
    app.IPv4AdresseLabel = uilabel(app.ConnectPanel);
    app.IPv4AdresseLabel.Tooltip = "Currently: " + string(app.IPv4AdressEditField.Value);
    app.IPv4AdresseLabel.Position = [18 97 79 22];
    app.IPv4AdresseLabel.Text = 'IPv4 Adresse:';

    app.PortLabel = uilabel(app.ConnectPanel);
    app.PortLabel.Tooltip = "Currently: " + string(app.PortEditField.Value);
    app.PortLabel.Position = [18 65 30 22];
    app.PortLabel.Text = 'Port:';

    app.StatusLabel = uilabel(app.ConnectPanel);
    app.StatusLabel.HorizontalAlignment = 'center';
    app.StatusLabel.Position = [81 19 100 22];
    app.StatusLabel.Text = 'Connected';
    app.StatusLabel.Visible = 'off';

    app.StatusLampLabelControl = uilabel(app.ConnectPanel);
    app.StatusLampLabelControl.HorizontalAlignment = 'right';
    app.StatusLampLabelControl.Position = [2 20 42 22];
    app.StatusLampLabelControl.Text = 'Status:';

    app.StatusLampControl = uilamp(app.ConnectPanel);
    app.StatusLampControl.Position = [59 20 20 20];
    app.StatusLampControl.Color = [0.651 0.651 0.651];

    app.LogsTextAreaLabel = uilabel(app.Controller);
    app.LogsTextAreaLabel.HorizontalAlignment = 'right';
    app.LogsTextAreaLabel.Position = [12 392 34 22];
    app.LogsTextAreaLabel.Text = 'Logs:';

    app.LogsTextArea = uitextarea(app.Controller);
    app.LogsTextArea.Position = [12 89 323 295];
    app.LogsTextArea.Editable = "off";
    app.LogsTextArea.BackgroundColor = [0.90,0.90,0.90];

    app.AddtoLogTextAreaButton = uibutton(app.Controller, 'push');
    app.AddtoLogTextAreaButton.HorizontalAlignment = 'right';
    app.AddtoLogTextAreaButton.Position = [12 58 66 22];
    app.AddtoLogTextAreaButton.Text = 'Add to Log:';
    app.AddtoLogTextAreaButton.ButtonPushedFcn =@(src,event)  addToLogButtonPushed(app, src, event); 

    app.AddtoLogTextArea = uitextarea(app.Controller);
    app.AddtoLogTextArea.Position = [12 33 325 26];

    app.Skript = uitextarea(app.Controller);
    app.Skript.Position = [385 30 644 482];
    app.Skript.BackgroundColor = [0.651 0.651 0.651];
    app.Skript.Editable = "off";

    app.SendscripttoTFA300Button = uibutton(app.Controller, 'push');
    app.SendscripttoTFA300Button.Position = [495 523 424 37];
    app.SendscripttoTFA300Button.Text = 'Send script to TFA-3000';
    app.SendscripttoTFA300Button.ButtonPushedFcn = createCallbackFcn(app, @SendScriptButtonPushed);
    app.SendscripttoTFA300Button.Enable = "off";


    app.Measurements = uitab(app.TabGroup);
    app.Measurements.Title = 'Measurements';

    
    % Create grid that fills the UIFigure
    app.MeasurementGridLayout = uigridlayout(app.Measurements, [1 2]); % 1 row, 2 cols
    app.MeasurementGridLayout.RowHeight = {'1x'};            % single stretch row
    app.MeasurementGridLayout.ColumnWidth = {'1x', '2x'};   % first = 1 part, second = 3 parts -> 25%/75%
    app.MeasurementGridLayout.Padding = [0 0 0 0];
    app.MeasurementGridLayout.RowSpacing = 0;
    app.MeasurementGridLayout.ColumnSpacing = 0;


     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create SampleInformationPanel
    app.SampleInformationPanel = uipanel(app.MeasurementGridLayout);
    app.SampleInformationPanel.Layout.Row = 1;
    app.SampleInformationPanel.Layout.Column = 1;
    app.SampleInformationPanel.Title = 'Sample Information';

    % Create GridLayout for SampleInformationPanel
    app.SampInfGridLayout = uigridlayout(app.SampleInformationPanel, [1 1]);
    app.SampInfGridLayout.RowHeight      = {'fit','fit','fit','fit','fit','fit','fit','fit','fit','fit'};
    app.SampInfGridLayout.ColumnWidth   = {'fit','fit','fit','fit','fit','fit'};   % left stretches, right sized to content
    app.SampInfGridLayout.Scrollable = 1;
    % Create SampleNameEditFieldLabel
    app.SampleNameEditFieldLabel = uilabel(app.SampInfGridLayout);
    app.SampleNameEditFieldLabel.HorizontalAlignment = 'center';
    app.SampleNameEditFieldLabel.Text = 'Sample Name:';
    app.SampleNameEditFieldLabel.Layout.Row = 1;
    app.SampleNameEditFieldLabel.Layout.Column = [1, 6];

    % Create SampleNameEditField
    app.SampleNameEditField = uieditfield(app.SampInfGridLayout, 'text');
    app.SampleNameEditField.HorizontalAlignment = 'center';
    app.SampleNameEditField.Value='unnamed';
    app.SampleNameEditField.Layout.Row = 2;
    app.SampleNameEditField.Layout.Column = [1, 6];

    % Create ThicknessEditFieldLabel
    app.ThicknessEditFieldLabel = uilabel(app.SampInfGridLayout);
    app.ThicknessEditFieldLabel.HorizontalAlignment = 'center';
    app.ThicknessEditFieldLabel.Text = 'Thickness [nm]';
    app.ThicknessEditFieldLabel.Layout.Row = 3;
    app.ThicknessEditFieldLabel.Layout.Column = [1, 6];

    % Create ThicknessnEditField
    app.ThicknessEditField = uieditfield(app.SampInfGridLayout, 'numeric');
    app.ThicknessEditField.Value=200;
    app.ThicknessEditField.Layout.Row = 4;
    app.ThicknessEditField.Layout.Column = [1, 6];

    % Create PadAreaLabel
    app.PadAreaLabel = uilabel(app.SampInfGridLayout);
    app.PadAreaLabel.HorizontalAlignment = 'center';
    app.PadAreaLabel.Text = 'Pad Area ';
    app.PadAreaLabel.Layout.Row = 5;
    app.PadAreaLabel.Layout.Column = [1, 3];

    % Create PadAreaEditField
    app.PadAreaEditField = uieditfield(app.SampInfGridLayout, 'numeric');
    app.PadAreaEditField.Layout.Row = 6;
    app.PadAreaEditField.Layout.Column = [1, 3];
    app.PadAreaEditField.Value = 1e6;
    
    
    % Create UnitDropDown
    app.UnitDropDown = uidropdown(app.SampInfGridLayout);
    app.UnitDropDown.Items = {'µm^2','mm^2','cm^2'};   % readable items
    app.UnitDropDown.Layout.Row = 6;
    app.UnitDropDown.Layout.Column = [4, 6];
    app.UnitDropDown.Value = 'µm^2';


    % Create Label
    app.UnitLabel = uilabel(app.SampInfGridLayout);
    app.UnitLabel.HorizontalAlignment = 'center';
    app.UnitLabel.VerticalAlignment = 'bottom';
    app.UnitLabel.Layout.Row = 5;
    app.UnitLabel.Layout.Column = [4, 6];
    app.UnitLabel.Interpreter = 'latex';    % enable LaTeX rendering
    app.UnitLabel.Text = '[µ$\mathrm{m^2}$]';   % Interpreter = 'latex' renders it%default'$\mathrm{mm^2}$';


    % Create rEditFieldLabel
    app.rEditFieldLabel = uilabel(app.SampInfGridLayout);
    app.rEditFieldLabel.Interpreter = 'latex';
    app.rEditFieldLabel.Layout.Row = 8;
    app.rEditFieldLabel.Layout.Column = 1;
    app.rEditFieldLabel.Text = '$r=$';

    % Create rEditField
    app.rEditField = uieditfield(app.SampInfGridLayout, 'numeric');
    app.rEditField.HorizontalAlignment = 'left';
    app.rEditField.Layout.Row = 8;
    app.rEditField.Layout.Column = 2;
    app.rEditField.Value = sqrt(1e6/pi); 

    % Create aEditFieldLabel
    app.aEditFieldLabel = uilabel(app.SampInfGridLayout);
    app.aEditFieldLabel.Interpreter = 'latex';
    app.aEditFieldLabel.Layout.Row = 8;
    app.aEditFieldLabel.Layout.Column = 4;
    app.aEditFieldLabel.Text = '$a=$';

    % Create aEditField
    app.aEditField = uieditfield(app.SampInfGridLayout, 'numeric');
    app.aEditField.HorizontalAlignment = 'left';
    app.aEditField.Layout.Row = 8;
    app.aEditField.Layout.Column = 5;
    app.aEditField.Value = 1000;

    % Create mLabel
    app.micromrLabel = uilabel(app.SampInfGridLayout);
    app.micromrLabel.Interpreter = 'latex';
    app.micromrLabel.Layout.Row = 8;
    app.micromrLabel.Layout.Column = 3;
    app.micromrLabel.Text = 'µm';

    % Create mLabel_2
    app.micromaLabel = uilabel(app.SampInfGridLayout);
    app.micromaLabel.Interpreter = 'latex';
    app.micromaLabel.Layout.Row = 8;
    app.micromaLabel.Layout.Column = 6;
    app.micromaLabel.Text = 'µm';

    % Create lorRadiusLabel
    app.lorRadiusLabel = uilabel(app.SampInfGridLayout);
    app.lorRadiusLabel.FontSize = 8;
    app.lorRadiusLabel.Interpreter = 'latex';
    app.lorRadiusLabel.Layout.Row = 7;
    app.lorRadiusLabel.Layout.Column = [1,3];
    app.lorRadiusLabel.Text = '$\lor$ Radius';

    % Create lorSqsidelengthLabel
    app.lorSqsidelengthLabel = uilabel(app.SampInfGridLayout);
    app.lorSqsidelengthLabel.FontSize = 8;
    app.lorSqsidelengthLabel.Interpreter = 'latex';
    app.lorSqsidelengthLabel.Layout.Row = 7;
    app.lorSqsidelengthLabel.Layout.Column = [4,6];
    app.lorSqsidelengthLabel.Text = '$\lor$ Sq. side length';

    app.SampleNameEditField.ValueChangedFcn=@(src,event)  updateSampleName(app, src, event);
    app.ThicknessEditField.ValueChangedFcn= @(src,event) updateThickness(app, src, event);
    app.PadAreaEditField.ValueChangedFcn =  @(src,event) updatePadArea(app, src, event); 
    app.UnitDropDown.ValueChangedFcn = @(src,event) updateUnitLabel(app, src, event);
    app.rEditField.ValueChangedFcn = @(src,event) updatePadAreaCircR(app, src, event);
    app.aEditField.ValueChangedFcn = @(src,event) updatePadAreabySqSL(app, src, event);
    
    

    % Create UserNameEditFieldLabel
    app.UserNameEditFieldLabel = uilabel(app.SampInfGridLayout);
    app.UserNameEditFieldLabel.HorizontalAlignment = 'center';
    app.UserNameEditFieldLabel.Text = 'User Name:';
    app.UserNameEditFieldLabel.Layout.Row = 9;
    app.UserNameEditFieldLabel.Layout.Column = [1, 6];

    % Create SampleNameEditField
    app.UserNameEditField = uieditfield(app.SampInfGridLayout, 'text');
    app.UserNameEditField.HorizontalAlignment = 'center';
    app.UserNameEditField.Value='viwi';
    app.UserNameEditField.Layout.Row = 10;
    app.UserNameEditField.Layout.Column = [1, 6];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    % Create TabGroup2
    app.TabGroup2 = uitabgroup(app.MeasurementGridLayout);
    app.TabGroup2.Layout.Row = 1;
    app.TabGroup2.Layout.Column = 2;
    

    % Create Tab
    app.PZMTab = uitab(app.TabGroup2);
    app.PZMTab.Title = 'PZM';

    % Create GridLayout
    app.PZMGridLayout = uigridlayout(app.PZMTab);
    app.PZMGridLayout.ColumnWidth = {120, 120, 30, 100, 120, 22}; % 512
    app.PZMGridLayout.RowHeight = {22, 22, 22, 22, 22, 15, 50};
    app.PZMGridLayout.ColumnSpacing = 1;
    app.PZMGridLayout.RowSpacing = 5;
    app.PZMGridLayout.Padding = [10 10 10 10];
    app.PZMGridLayout.Scrollable = 1;

    % LoadWaveForm Button
    app.PZMLoadWaveFormEditField = uieditfield(app.PZMGridLayout);
    app.PZMLoadWaveFormEditField.Layout.Row = 1;
    app.PZMLoadWaveFormEditField.Layout.Column = 1;
    app.PZMLoadWaveFormEditField.Value = "Load WaveForm:";
    app.PZMLoadWaveFormEditField.Editable = "on";
    app.PZMLoadWaveFormEditField.HorizontalAlignment = 'right';
    app.PZMLoadWaveFormEditField.ValueChangedFcn =@(src,event) changedPZMLoadWaveFormEditField(app,src,event);
    app.PZMLoadWaveFormEditField.Enable = 'off';

    % LoadWaveForm Button
    app.PZMLoadWaveFormButton = uibutton(app.PZMGridLayout);
    app.PZMLoadWaveFormButton.Layout.Row = 1;
    app.PZMLoadWaveFormButton.Layout.Column = 2;
    app.PZMLoadWaveFormButton.Text = "Browse";
    app.PZMLoadWaveFormButton.ButtonPushedFcn = @(src,event) loadWaveFormBrowseButton(app,src,event);
    app.PZMLoadWaveFormButton.Enable = 'off';

    % Wavefor dropdownlabel:
    app.PZMWaveFormDropDownLabel = uilabel(app.PZMGridLayout);
    app.PZMWaveFormDropDownLabel.HorizontalAlignment = 'left';
    app.PZMWaveFormDropDownLabel.Layout.Row = 2;
    app.PZMWaveFormDropDownLabel.Layout.Column = 1;
    app.PZMWaveFormDropDownLabel.Text = 'Waveform: ';

    % Wavefor dropdown:
    app.PZMWaveFormDropDown = uidropdown(app.PZMGridLayout);
    app.PZMWaveFormDropDown.Items = {'triangle','sine'};   % readable items
    app.PZMWaveFormDropDown.Value = 'triangle';
    app.PZMWaveFormDropDown.Layout.Row = 2;
    app.PZMWaveFormDropDown.Layout.Column = 2;

    
    % Create PZMCuRangeDropDownLabel
    app.PZMCuRangeDropDownLabel=uilabel(app.PZMGridLayout);
    app.PZMCuRangeDropDownLabel.Layout.Row =3;
    app.PZMCuRangeDropDownLabel.Layout.Column =1;
    app.PZMCuRangeDropDownLabel.HorizontalAlignment = 'left';
    app.PZMCuRangeDropDownLabel.Text='Current range: ';
    % Create PZMCuRangeDropDown (correct control and placement)
    app.PZMCuRangeDropDown = uidropdown(app.PZMGridLayout);
    app.PZMCuRangeDropDown.Layout.Row = 3;
    app.PZMCuRangeDropDown.Layout.Column = 2;
    app.PZMCuRangeDropDown.Items = {'auto', '1 A', '100 mA', '10 mA', '1 mA','100 µA', '10 µA', '1 µA', '100 nA', '10 nA', '1 nA', '100 pA', '10 pA'};
    app.PZMCuRangeDropDown.Value = 'auto';
    app.PZMCuRangeDropDown.ItemsData ={-1,0,1,4,5,6,7,8,9,10,11,12,13};
    app.PZMCuRangeDropDown.Enable = 'on';
    
        
    % Create PZMPrePolDropDownLabel
    app.PZMPrePolDropDownLabel = uilabel(app.PZMGridLayout);
    app.PZMPrePolDropDownLabel.HorizontalAlignment = 'left';
    app.PZMPrePolDropDownLabel.Layout.Row = 4;
    app.PZMPrePolDropDownLabel.Layout.Column = 1;
    app.PZMPrePolDropDownLabel.Text = 'Pre-polarization: ';
    
    % Create PZMPrePolDropDown
    app.PZMPrePolDropDown = uidropdown(app.PZMGridLayout);
    app.PZMPrePolDropDown.Items = {'Switching','Non-Switching','Disabled'};
    app.PZMPrePolDropDown.Value = 'Switching';
    app.PZMPrePolDropDown.Layout.Row = 4;
    app.PZMPrePolDropDown.Layout.Column = 2;
    
    
    % Create PZMUnipCheckBox
    app.PZMUnipCheckBox = uicheckbox(app.PZMGridLayout);
    app.PZMUnipCheckBox.Layout.Row = 5;
    app.PZMUnipCheckBox.Layout.Column = 1;
    app.PZMUnipCheckBox.Value = false;
    app.PZMUnipCheckBox.Text ="Unipolar";
    
    
    % Create PZMSingleLoopCheckBox
    app.PZMSingleLoopCheckBox = uicheckbox(app.PZMGridLayout);
    app.PZMSingleLoopCheckBox.Layout.Row = 5;
    app.PZMSingleLoopCheckBox.Layout.Column = 2;
    app.PZMSingleLoopCheckBox.Value = false;
    app.PZMSingleLoopCheckBox.Text ="Single loop";


    % Create EditFieldLabel
    app.PZMFreqEditFieldLabel = uilabel(app.PZMGridLayout);
    app.PZMFreqEditFieldLabel.HorizontalAlignment = 'right';
    app.PZMFreqEditFieldLabel.Layout.Row = 1;
    app.PZMFreqEditFieldLabel.Layout.Column = 4;
    app.PZMFreqEditFieldLabel.Text = 'Frequency: ';
    app.PZMFreqEditFieldLabel.Tooltip = "Values are limited between 10 mHz and 1 MHz";

    % Create EditField
    app.PZMFreqEditField = uieditfield(app.PZMGridLayout, 'numeric');
    app.PZMFreqEditField.Layout.Row = 1;
    app.PZMFreqEditField.Layout.Column = 5;
    app.PZMFreqEditField.Value=0.1;
    app.PZMFreqEditField.Tooltip = "Values are limited between 10 mHz and 1 MHz";

    % Create EditFieldLabel
    app.PZMFreqUnit = uilabel(app.PZMGridLayout);
    app.PZMFreqUnit.HorizontalAlignment = 'left';
    app.PZMFreqUnit.Layout.Row = 1;
    app.PZMFreqUnit.Layout.Column = 6;
    app.PZMFreqUnit.Text = 'kHz';
    

    % Create AmpEditField
    app.PZMAmpEditField  = uieditfield(app.PZMGridLayout,'numeric');
    app.PZMAmpEditField.Layout.Row = 2;
    app.PZMAmpEditField.Layout.Column = 5;
    app.PZMAmpEditField.Value = 3;
    app.PZMAmpEditField.Tooltip = "Values are limited between -126 V and 126 V";

    % Create AmpEditFieldLabel
    app.PZMAmpEditFieldLabel = uilabel(app.PZMGridLayout);
    app.PZMAmpEditFieldLabel.HorizontalAlignment = 'right';
    app.PZMAmpEditFieldLabel.Layout.Row = 2;
    app.PZMAmpEditFieldLabel.Layout.Column = 4;
    app.PZMAmpEditFieldLabel.Text = 'Amplitude: ';
    app.PZMAmpEditFieldLabel.Tooltip = "Values are limited between -126 V and 126 V";

    % Create Amp Unit Label
    app.PZMAmpUnit = uilabel(app.PZMGridLayout);
    app.PZMAmpUnit.HorizontalAlignment = 'left';
    app.PZMAmpUnit.Layout.Row = 2;
    app.PZMAmpUnit.Layout.Column = 6;
    app.PZMAmpUnit.Text = 'V';

    % Create BiasEditField
    app.PZMBiasEditField  = uieditfield(app.PZMGridLayout,'numeric');
    app.PZMBiasEditField.Layout.Row = 3;
    app.PZMBiasEditField.Layout.Column = 5;
    % Create BiasEditFieldLabel
    app.PZMBiasEditFieldLabel = uilabel(app.PZMGridLayout);
    app.PZMBiasEditFieldLabel.HorizontalAlignment = 'right';
    app.PZMBiasEditFieldLabel.Layout.Row = 3;
    app.PZMBiasEditFieldLabel.Layout.Column = 4;
    app.PZMBiasEditFieldLabel.Text = 'Bias: ';

    % Create Bias Unit Lbel
    app.PZMBiasUnit = uilabel(app.PZMGridLayout);
    app.PZMBiasUnit.HorizontalAlignment = 'left';
    app.PZMBiasUnit.Layout.Row = 3;
    app.PZMBiasUnit.Layout.Column = 6;
    app.PZMBiasUnit.Text = 'V';

    % Create DelayEditField
    app.PZMDelayEditField  = uieditfield(app.PZMGridLayout,'numeric');
    app.PZMDelayEditField.Layout.Row = 4;
    app.PZMDelayEditField.Layout.Column = 5;
    app.PZMDelayEditField.Value=1000;

    % Create Delay Edit Field Label
    app.PZMDelayEditFieldLabel = uilabel(app.PZMGridLayout);
    app.PZMDelayEditFieldLabel.HorizontalAlignment = 'right';
    app.PZMDelayEditFieldLabel.Layout.Row = 4;
    app.PZMDelayEditFieldLabel.Layout.Column = 4;
    app.PZMDelayEditFieldLabel.Text = 'Delay: ';
    
    % Create Delay Unit Label
    app.PZMDelayUnit = uilabel(app.PZMGridLayout);
    app.PZMDelayUnit.HorizontalAlignment = 'left';
    app.PZMDelayUnit.Layout.Row = 4;
    app.PZMDelayUnit.Layout.Column = 6;
    app.PZMDelayUnit.Text = 'ms';
    
    % Create Repetitions Edit Field
    app.PZMRepsEditField = uieditfield(app.PZMGridLayout, 'numeric');
    app.PZMRepsEditField.Layout.Row = 5;
    app.PZMRepsEditField.Layout.Column = 5;
    app.PZMRepsEditField.Value=1;
    
    % Create Repetitions Edit Field Label
    app.PZMRepsEditFieldLabel = uilabel(app.PZMGridLayout);
    app.PZMRepsEditFieldLabel.HorizontalAlignment = 'right';
    app.PZMRepsEditFieldLabel.Layout.Row = 5;
    app.PZMRepsEditFieldLabel.Layout.Column = 4;
    app.PZMRepsEditFieldLabel.Text = 'Repetitions: ';
    
    % Create Start PZM Button
    app.PZMStartMeasButton = uibutton(app.PZMGridLayout);
    app.PZMStartMeasButton.Layout.Row = 7 ;
    app.PZMStartMeasButton.Layout.Column = [1,6] ;
    app.PZMStartMeasButton.Text = 'Start PZM';
    

    
    
    % Init Default Values BZW. 
    % app.TabGroup2.SelectionChangedFcn
    
    app.PZMWaveFormDropDown.ValueChangedFcn = @(src,event) updateWaveForm(app,src,event);
    app.PZMCuRangeDropDown.ValueChangedFcn = @(src,event) updateCuRange(app,src,event);
    app.PZMPrePolDropDown.ValueChangedFcn = @(src,event) updatePrePol(app,src,event);
    app.PZMUnipCheckBox.ValueChangedFcn = @(src,event) updateUnipCheckBox(app,src,event);
    app.PZMSingleLoopCheckBox.ValueChangedFcn = @(src,event) updateSingleLoopCheckBox(app,src,event);
    app.PZMFreqEditField.ValueChangedFcn = @(src,event) updateFreq(app,src,event);
    app.PZMAmpEditField.ValueChangedFcn = @(src,event) updateAmp(app,src,event);
    app.PZMBiasEditField.ValueChangedFcn = @(src,event) updateBias(app,src,event);
    app.PZMDelayEditField.ValueChangedFcn = @(src,event) updateDelay(app,src,event);
    app.PZMRepsEditField.ValueChangedFcn = @(src,event) updateReps(app,src,event);
    app.PZMStartMeasButton.ButtonPushedFcn = @(src,event) startPZM(app,src,event);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    % Create Tab2
    app.PMTab = uitab(app.TabGroup2);
    app.PMTab.Title = 'PM';
    app.PMTab.Scrollable = 'on';


    % Create GridLayout
    app.PMGridLayout = uigridlayout(app.PMTab);
    app.PMGridLayout.ColumnWidth = {80, 134, 40, 104, 22, 22, 22, 22, 22, 22, 22}; % 512
    app.PMGridLayout.RowHeight = {22, 22, 22, 15, 15, 22, 22, 22, 22,15,15, 22, 22, 22, 22,15,22,50};
    app.PMGridLayout.ColumnSpacing = 1;
    app.PMGridLayout.RowSpacing = 5;
    app.PMGridLayout.Padding = [10 10 10 10];
    app.PMGridLayout.Scrollable = 'on';

    % Create AmplifierDropDownLabel
    app.PMAmplifierDropDownLabel = uilabel(app.PMGridLayout);
    app.PMAmplifierDropDownLabel.HorizontalAlignment = 'left';
    app.PMAmplifierDropDownLabel.Layout.Row = 1;
    app.PMAmplifierDropDownLabel.Layout.Column = 1;
    app.PMAmplifierDropDownLabel.Text = 'Amplifier: ';
    % Create AmplifierDropDown
    app.PMAmplifierDropDown = uidropdown(app.PMGridLayout);
    app.PMAmplifierDropDown.Items = {'FE-HeadAmp','HV-Amp'};
    app.PMAmplifierDropDown.Value = 'FE-HeadAmp';
    app.PMAmplifierDropDown.Layout.Row = 1;
    app.PMAmplifierDropDown.Layout.Column = 2;
    app.PMAmplifierDropDown.Enable = 'off';

    % Create PMModeLabel
    app.PMModeLabel = uilabel(app.PMGridLayout);
    app.PMModeLabel.HorizontalAlignment = 'left';
    app.PMModeLabel.Layout.Row = 2;
    app.PMModeLabel.Layout.Column = 1;
    app.PMModeLabel.Text = 'PM Mode: ';
    
    % Create PMMode
    app.PMMode = uidropdown(app.PMGridLayout);
    app.PMMode.Items = ["Manual","PUND","SS/NS","SS/S","OS/NS","OS/S","W"];
    app.PMMode.Value = "Manual";
    app.PMMode.Layout.Row = 2;
    app.PMMode.Layout.Column = 2;
    % app.PMMode.Enable = 'off';

    % Create PMSeqLabel
    app.PMSeqLabel = uilabel(app.PMGridLayout);
    app.PMSeqLabel.HorizontalAlignment = 'right';
    app.PMSeqLabel.Layout.Row = 2;
    app.PMSeqLabel.Layout.Column = 4;
    app.PMSeqLabel.Text = 'Sequence: ';
    % Create Button
    app.PMSeqButton1 = uibutton(app.PMGridLayout);
    app.PMSeqButton1.Layout.Row = 2;
    app.PMSeqButton1.Layout.Column = 5;
    app.PMSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'disBlue.png');
    app.PMSeqButton1.Text = '';
    app.PMSeqButton1.UserData = 0;
    % Create Button
    app.PMSeqButton2 = uibutton(app.PMGridLayout);
    app.PMSeqButton2.Layout.Row = 2;
    app.PMSeqButton2.Layout.Column = 6;
    app.PMSeqButton2.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'disRed.png');
    app.PMSeqButton2.Text = '';
    app.PMSeqButton2.UserData = 0;
    % Create Button
    app.PMSeqButton3 = uibutton(app.PMGridLayout);
    app.PMSeqButton3.Layout.Row = 2;
    app.PMSeqButton3.Layout.Column = 7;
    app.PMSeqButton3.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'disRed.png');
    app.PMSeqButton3.Text = '';
    app.PMSeqButton3.UserData = 0;
    % Create Button
    app.PMSeqButton4 = uibutton(app.PMGridLayout);
    app.PMSeqButton4.Layout.Row = 2;
    app.PMSeqButton4.Layout.Column = 8;
    app.PMSeqButton4.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'disRed.png');
    app.PMSeqButton4.Text = '';
    app.PMSeqButton4.UserData = 0;
    % Create Button
    app.PMSeqButton5 = uibutton(app.PMGridLayout);
    app.PMSeqButton5.Layout.Row = 2;
    app.PMSeqButton5.Layout.Column = 9;
    app.PMSeqButton5.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'disRed.png');
    app.PMSeqButton5.Text = '';
    app.PMSeqButton5.UserData = 0;
    % Create Button
    app.PMSeqButton6 = uibutton(app.PMGridLayout);
    app.PMSeqButton6.Layout.Row = 2;
    app.PMSeqButton6.Layout.Column = 10;
    app.PMSeqButton6.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'disRed.png');
    app.PMSeqButton6.Text = '';
    app.PMSeqButton6.UserData = 0;
    % Create Button
    app.PMSeqButton7 = uibutton(app.PMGridLayout);
    app.PMSeqButton7.Layout.Row = 2;
    app.PMSeqButton7.Layout.Column = 11;
    app.PMSeqButton7.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'disBlue.png');
    app.PMSeqButton7.Text = '';
    app.PMSeqButton7.UserData = 0;
    
     % Create PMWaveformDropDownLabel
    app.PMWaveformDropDownLabel = uilabel(app.PMGridLayout);
    app.PMWaveformDropDownLabel.HorizontalAlignment = 'left';
    app.PMWaveformDropDownLabel.Layout.Row = 3;
    app.PMWaveformDropDownLabel.Layout.Column = 1;
    app.PMWaveformDropDownLabel.Text = 'Waveform: ';
    
    % Create PMWaveformDropDown
    app.PMWaveformDropDown = uidropdown(app.PMGridLayout);
    app.PMWaveformDropDown.Items = ["Trapezoid","Triangle","Rectangle"];
    app.PMWaveformDropDown.ItemsData = {0,1,2};
    app.PMWaveformDropDown.Value = 0;
    app.PMWaveformDropDown.Layout.Row = 3;
    app.PMWaveformDropDown.Layout.Column = 2;
    

    app.PMWritePulsePanLabel = uilabel(app.PMGridLayout);
    app.PMWritePulsePanLabel.HorizontalAlignment = 'left';
    app.PMWritePulsePanLabel.Layout.Row = 5;
    app.PMWritePulsePanLabel.Layout.Column = [1,11];
    app.PMWritePulsePanLabel.Text = 'Set Pulse: ';
    app.PMWritePulsePanLabel.BackgroundColor = [1,1,1];
    
    % Create wam Label
    app.PMwamLabel = uilabel(app.PMGridLayout);
    app.PMwamLabel.HorizontalAlignment = 'left';
    app.PMwamLabel.Layout.Row = 6;
    app.PMwamLabel.Layout.Column = [1,8];
    app.PMwamLabel.Text = 'Set Pulse Amplitude: ';
    % Create wam Edit Field
    app.PMwamEditField = uieditfield(app.PMGridLayout,"numeric");
    app.PMwamEditField.HorizontalAlignment = 'right';
    app.PMwamEditField.Layout.Row = 6;
    app.PMwamEditField.Layout.Column = [9,10];
    app.PMwamEditField.Value = 3;
    % Create wam Unit Label
    app.PMwamUnit = uilabel(app.PMGridLayout);
    app.PMwamUnit.HorizontalAlignment = 'left';
    app.PMwamUnit.Layout.Row = 6;
    app.PMwamUnit.Layout.Column = 11;
    app.PMwamUnit.Text = "V";

    % Create wpu Label
    app.PMwpuLabel = uilabel(app.PMGridLayout);
    app.PMwpuLabel.HorizontalAlignment = 'left';
    app.PMwpuLabel.Layout.Row = 7;
    app.PMwpuLabel.Layout.Column = [1,8];
    app.PMwpuLabel.Text = 'Set Pulsewidth: ';
    % Create wpu Edit Field
    app.PMwpuEditField = uieditfield(app.PMGridLayout,"numeric");
    app.PMwpuEditField.HorizontalAlignment = 'right';
    app.PMwpuEditField.Layout.Row = 7;
    app.PMwpuEditField.Layout.Column = [9,10];
    app.PMwpuEditField.Value = 5;
    % Create wpu Unit Label
    app.PMwpuUnit = uilabel(app.PMGridLayout);
    app.PMwpuUnit.HorizontalAlignment = 'left';
    app.PMwpuUnit.Layout.Row = 7;
    app.PMwpuUnit.Layout.Column = 11;
    app.PMwpuUnit.Text = "ms";

    % Create wri Label
    app.PMwriLabel = uilabel(app.PMGridLayout);
    app.PMwriLabel.HorizontalAlignment = 'left';
    app.PMwriLabel.Layout.Row = 8;
    app.PMwriLabel.Layout.Column = [1,8];
    app.PMwriLabel.Text = 'Write Risetime: ';
    % Create wri Edit Field
    app.PMwriEditField = uieditfield(app.PMGridLayout,"numeric");
    app.PMwriEditField.HorizontalAlignment = 'right';
    app.PMwriEditField.Layout.Row = 8;
    app.PMwriEditField.Layout.Column = [9,10];
    app.PMwriEditField.Value = 5;
    % Create wri Unit Label
    app.PMwriUnit = uilabel(app.PMGridLayout);
    app.PMwriUnit.HorizontalAlignment = 'left';
    app.PMwriUnit.Layout.Row = 8;
    app.PMwriUnit.Layout.Column = 11;
    app.PMwriUnit.Text = "ms";
  
    % Create wri Label
    app.PMdel2readLabel = uilabel(app.PMGridLayout);
    app.PMdel2readLabel.HorizontalAlignment = 'left';
    app.PMdel2readLabel.Layout.Row = 9;
    app.PMdel2readLabel.Layout.Column = [1,8];
    app.PMdel2readLabel.Text = 'Delay to Read: ';
    % Create wri Edit Field
    app.PMdel2readEditField = uieditfield(app.PMGridLayout,"numeric");
    app.PMdel2readEditField.HorizontalAlignment = 'right';
    app.PMdel2readEditField.Layout.Row = 9;
    app.PMdel2readEditField.Layout.Column = [9,10];
    app.PMdel2readEditField.Value = 5;
    % Create read (delay to read) Unit Label
    app.PMdel2readUnit = uilabel(app.PMGridLayout);
    app.PMdel2readUnit.HorizontalAlignment = 'left';
    app.PMdel2readUnit.Layout.Row = 9;
    app.PMdel2readUnit.Layout.Column = 11;
    app.PMdel2readUnit.Text = "ms";

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% read Panel of PM
    app.PMReadPulsePanLabel = uilabel(app.PMGridLayout);
    app.PMReadPulsePanLabel.HorizontalAlignment = 'left';
    app.PMReadPulsePanLabel.Layout.Row = 11;
    app.PMReadPulsePanLabel.Layout.Column = [1,11];
    app.PMReadPulsePanLabel.Text = 'Read Pulse: ';
    app.PMReadPulsePanLabel.BackgroundColor = [1,1,1];
    
    % Create (read) amp Label
    app.PMampLabel = uilabel(app.PMGridLayout);
    app.PMampLabel.HorizontalAlignment = 'left';
    app.PMampLabel.Layout.Row = 12;
    app.PMampLabel.Layout.Column = [1,8];
    app.PMampLabel.Text = 'Read Pulse Amplitude: ';
    % Create wam Edit Field
    app.PMampEditField = uieditfield(app.PMGridLayout,"numeric");
    app.PMampEditField.HorizontalAlignment = 'right';
    app.PMampEditField.Layout.Row = 12;
    app.PMampEditField.Layout.Column = [9,10];
    app.PMampEditField.Value = 3;
    % Create wam Unit Label
    app.PMampUnit = uilabel(app.PMGridLayout);
    app.PMampUnit.HorizontalAlignment = 'left';
    app.PMampUnit.Layout.Row = 12;
    app.PMampUnit.Layout.Column = 11;
    app.PMampUnit.Text = "V";

    % Create rpu Label
    app.PMrpuLabel = uilabel(app.PMGridLayout);
    app.PMrpuLabel.HorizontalAlignment = 'left';
    app.PMrpuLabel.Layout.Row = 13;
    app.PMrpuLabel.Layout.Column = [1,8];
    app.PMrpuLabel.Text = 'Read Pulsewidth: ';
    % Create rpu Edit Field
    app.PMrpuEditField = uieditfield(app.PMGridLayout,"numeric");
    app.PMrpuEditField.HorizontalAlignment = 'right';
    app.PMrpuEditField.Layout.Row = 13;
    app.PMrpuEditField.Layout.Column = [9,10];
    app.PMrpuEditField.Value = 5;
    % Create rpu Unit Label
    app.PMrpuUnit = uilabel(app.PMGridLayout);
    app.PMrpuUnit.HorizontalAlignment = 'left';
    app.PMrpuUnit.Layout.Row = 13;
    app.PMrpuUnit.Layout.Column = 11;
    app.PMrpuUnit.Text = "ms";

    % Create wri Label
    app.PMrriLabel = uilabel(app.PMGridLayout);
    app.PMrriLabel.HorizontalAlignment = 'left';
    app.PMrriLabel.Layout.Row = 14;
    app.PMrriLabel.Layout.Column = [1,8];
    app.PMrriLabel.Text = 'Read Risetime: ';
    % Create wri Edit Field
    app.PMrriEditField = uieditfield(app.PMGridLayout,"numeric");
    app.PMrriEditField.HorizontalAlignment = 'right';
    app.PMrriEditField.Layout.Row = 14;
    app.PMrriEditField.Layout.Column = [9,10];
    app.PMrriEditField.Value = 5;
    app.PMrriEditField.Enable = 'off';
    % Create wri Unit Label
    app.PMrriUnit = uilabel(app.PMGridLayout);
    app.PMrriUnit.HorizontalAlignment = 'left';
    app.PMrriUnit.Layout.Row = 14;
    app.PMrriUnit.Layout.Column = 11;
    app.PMrriUnit.Text = "ms";
  
    % Create wri Label
    app.PMdelaytLabel = uilabel(app.PMGridLayout);
    app.PMdelaytLabel.HorizontalAlignment = 'left';
    app.PMdelaytLabel.Layout.Row = 15;
    app.PMdelaytLabel.Layout.Column = [1,8];
    app.PMdelaytLabel.Text = 'Delay between Reads: ';
    % Create wri Edit Field
    app.PMdelaytEditField = uieditfield(app.PMGridLayout,"numeric");
    app.PMdelaytEditField.HorizontalAlignment = 'right';
    app.PMdelaytEditField.Layout.Row = 15;
    app.PMdelaytEditField.Layout.Column = [9,10];
    app.PMdelaytEditField.Value = 5;
    % Create read (delay to read) Unit Label
    app.PMdelaytUnit = uilabel(app.PMGridLayout);
    app.PMdelaytUnit.HorizontalAlignment = 'left';
    app.PMdelaytUnit.Layout.Row = 15;
    app.PMdelaytUnit.Layout.Column = 11;
    app.PMdelaytUnit.Text = "ms";

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% Monitoring of PM
    app.PMMonitoringPanLabel = uilabel(app.PMGridLayout);
    app.PMMonitoringPanLabel.HorizontalAlignment = 'left';
    app.PMMonitoringPanLabel.Layout.Row = 16;
    app.PMMonitoringPanLabel.Layout.Column = [1,11];
    app.PMMonitoringPanLabel.Text = 'Monitoring: ';
    app.PMMonitoringPanLabel.BackgroundColor = [1,1,1];
    % Create PMCuRangeDropDownLabel
    app.PMCuRangeDropDownLabel=uilabel(app.PMGridLayout);
    app.PMCuRangeDropDownLabel.Layout.Row =17;
    app.PMCuRangeDropDownLabel.Layout.Column =[1,7];
    app.PMCuRangeDropDownLabel.HorizontalAlignment = 'left';
    app.PMCuRangeDropDownLabel.Text='Current range: ';
    % Create PMCuRangeDropDown (correct control and placement)
    app.PMCuRangeDropDown = uidropdown(app.PMGridLayout);
    app.PMCuRangeDropDown.Layout.Row = 17;
    app.PMCuRangeDropDown.Layout.Column = [7,11];
    app.PMCuRangeDropDown.Items = {'auto', '1 A', '100 mA', '10 mA', '1 mA','100 µA', '10 µA', '1 µA', '100 nA', '10 nA', '1 nA', '100 pA', '10 pA'};
    app.PMCuRangeDropDown.Value = 'auto';
    app.PMCuRangeDropDown.ItemsData ={-1,0,1,4,5,6,7,8,9,10,11,12,13};
    app.PMCuRangeDropDown.Enable = 'on';
    
    % Create Start PM Button
    app.PMStartMeasButton = uibutton(app.PMGridLayout);
    app.PMStartMeasButton.Layout.Row = 18 ;
    app.PMStartMeasButton.Layout.Column = [1,11] ;
    app.PMStartMeasButton.Text = 'Start PM';
    app.PMStartMeasButton.Enable = 'on';
    
    app.PMWaveformDropDown.ValueChangedFcn = @(src,event) updateWaveForm(app,src,event);
    app.PMMode.ValueChangedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMSeqButton1.ButtonPushedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMSeqButton2.ButtonPushedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMSeqButton3.ButtonPushedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMSeqButton4.ButtonPushedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMSeqButton5.ButtonPushedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMSeqButton6.ButtonPushedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMSeqButton7.ButtonPushedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMwamEditField.ValueChangedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMwpuEditField.ValueChangedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMwriEditField.ValueChangedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMdel2readEditField.ValueChangedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMampEditField.ValueChangedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMrpuEditField.ValueChangedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMdelaytEditField.ValueChangedFcn = @(src,event) updatePMcbs(app,src,event);
    app.PMCuRangeDropDown.ValueChangedFcn = @(src,event) updateCuRange(app,src,event);
    app.PMStartMeasButton.ButtonPushedFcn = @(src,event) startPM(app,src,event);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    % Create Tab2
    app.ATMTab = uitab(app.TabGroup2);
    app.ATMTab.Title = 'ATM';
    app.ATMTab.Scrollable = 'on';
    app.ATMTab.Tooltip = "Adaptive Treatment Measurement";

    % Create GridLayout
    app.ATMGridLayout = uigridlayout(app.ATMTab);
    app.ATMGridLayout.ColumnWidth = {22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22,22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 6}; % 512
    app.ATMGridLayout.RowHeight = {22, 22, 22, 22, 22, 22, 22, 22, 22,15,22, 22, 22, 15, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22,22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 24};
    app.ATMGridLayout.ColumnSpacing = 1;
    app.ATMGridLayout.RowSpacing = 5;
    app.ATMGridLayout.Padding = [10 10 10 10];
    app.ATMGridLayout.Scrollable = 'on';

    % Create ATMWaveformTreatDropDown
    app.ATMWaveformTreatDropDownLabel = uilabel(app.ATMGridLayout);
    app.ATMWaveformTreatDropDownLabel.HorizontalAlignment = 'left';
    app.ATMWaveformTreatDropDownLabel.Layout.Row = 1;
    app.ATMWaveformTreatDropDownLabel.Layout.Column = [1,7];
    app.ATMWaveformTreatDropDownLabel.Text = 'Waveform: ';
    % Create ATMWaveformTreatDropDown
    app.ATMWaveformTreatDropDown = uidropdown(app.ATMGridLayout);
    app.ATMWaveformTreatDropDown.Items = {'Triangle','Sine'};
    app.ATMWaveformTreatDropDown.Value = 'Triangle';
    app.ATMWaveformTreatDropDown.Layout.Row = 1;
    app.ATMWaveformTreatDropDown.Layout.Column = [20,24];
    app.ATMWaveformTreatDropDown.Enable = 'off';


    % Create ATMWaveformTreatDropDown
    app.ATMEcShiftLabel = uilabel(app.ATMGridLayout);
    app.ATMEcShiftLabel.HorizontalAlignment = 'left';
    app.ATMEcShiftLabel.Layout.Row = 2;
    app.ATMEcShiftLabel.Layout.Column = [1,7];
    app.ATMEcShiftLabel.Text = 'Read which polarity: ';
    % Create ATMWaveformTreatDropDown
    app.ATMEcShiftDropDown = uidropdown(app.ATMGridLayout);
    app.ATMEcShiftDropDown.Items = {'N-polarity','M-polarity'};
    app.ATMEcShiftDropDown.Value = 'N-polarity';
    app.ATMEcShiftDropDown.Layout.Row = 2;
    app.ATMEcShiftDropDown.Layout.Column = [20,24];
    

    % Create ATMReadSeqLabel
    app.ATMReadSeqLabel = uilabel(app.ATMGridLayout);
    app.ATMReadSeqLabel.HorizontalAlignment = 'left';
    app.ATMReadSeqLabel.Layout.Row = 2;
    app.ATMReadSeqLabel.Layout.Column = [8,12];
    app.ATMReadSeqLabel.Text = 'Read Sequence: ';
    
    % Create ATMSeqImage1
    app.ATMSeqImage1 = uiimage(app.ATMGridLayout);
    app.ATMSeqImage1.Layout.Row = 2;
    app.ATMSeqImage1.Layout.Column = 12;
    app.ATMSeqImage1.ImageSource = fullfile(app.currPWD, 'images',  'posBlueTri.png');
    % Create ATMSeqImage2
    app.ATMSeqImage2 = uiimage(app.ATMGridLayout);
    app.ATMSeqImage2.Layout.Row = 2;
    app.ATMSeqImage2.Layout.Column = 13;
    app.ATMSeqImage2.ImageSource = fullfile(app.currPWD, 'images',  'disRed.png');
    % Create ATMSeqImage3
    app.ATMSeqImage3 = uiimage(app.ATMGridLayout);
    app.ATMSeqImage3.Layout.Row = 2;
    app.ATMSeqImage3.Layout.Column = 14;
    app.ATMSeqImage3.ImageSource = fullfile(app.currPWD, 'images',  'negRedTri.png');
    % Create ATMSeqImage4
    app.ATMSeqImage4 = uiimage(app.ATMGridLayout);
    app.ATMSeqImage4.Layout.Row = 2;
    app.ATMSeqImage4.Layout.Column = 15;
    app.ATMSeqImage4.ImageSource = fullfile(app.currPWD, 'images',  'negRedTri.png');
    % Create ATMSeqImage5
    app.ATMSeqImage5 = uiimage(app.ATMGridLayout);
    app.ATMSeqImage5.Layout.Row = 2;
    app.ATMSeqImage5.Layout.Column = 16;
    app.ATMSeqImage5.ImageSource = fullfile(app.currPWD, 'images',  'disRed.png');
    % Create ATMSeqImage6
    app.ATMSeqImage6 = uiimage(app.ATMGridLayout);
    app.ATMSeqImage6.Layout.Row = 2;
    app.ATMSeqImage6.Layout.Column = 17;
    app.ATMSeqImage6.ImageSource = fullfile(app.currPWD, 'images',  'disRed.png');
    % Create ATMSeqImage7
    app.ATMSeqImage7 = uiimage(app.ATMGridLayout);
    app.ATMSeqImage7.Layout.Row = 2;
    app.ATMSeqImage7.Layout.Column = 18;
    app.ATMSeqImage7.ImageSource = fullfile(app.currPWD, 'images',  'disBlue.png');


    % Create fTreat Label
    app.ATMfTreatLabel = uilabel(app.ATMGridLayout);
    app.ATMfTreatLabel.HorizontalAlignment = 'left';
    app.ATMfTreatLabel.Layout.Row = 3;
    app.ATMfTreatLabel.Layout.Column = [1,7];
    app.ATMfTreatLabel.Text = 'Treat Frequency: ';
    % Create fTreat Edit Field
    app.ATMfTreatEditField = uieditfield(app.ATMGridLayout,"numeric");
    app.ATMfTreatEditField.HorizontalAlignment = 'right';
    app.ATMfTreatEditField.Layout.Row = 3;
    app.ATMfTreatEditField.Layout.Column = [8,24];
    app.ATMfTreatEditField.Value = 10;
    app.ATMfTreatEditField.ValueDisplayFormat = "%.2f kHz";

    % Create ATMCyclesLabel Label
    app.ATMCyclesLabel = uilabel(app.ATMGridLayout);
    app.ATMCyclesLabel.HorizontalAlignment = 'left';
    app.ATMCyclesLabel.Layout.Row = 4;
    app.ATMCyclesLabel.Layout.Column = [1,7];
    app.ATMCyclesLabel.Text = 'Number of Cycles: ';
    % Create Amp0 Edit Field
    app.ATMCyclesDropDown = uidropdown(app.ATMGridLayout);
    app.ATMCyclesDropDown.Layout.Row = 4;
    app.ATMCyclesDropDown.Layout.Column = [20,24];
    app.ATMCyclesDropDown.Items = {'10','100','1000','1e4','1e5','1e6','1e7','1e8'};
    app.ATMCyclesDropDown.Value = '1000';


    % Create Amp0 Label
    app.ATMAmp0LabelPos = uilabel(app.ATMGridLayout);
    app.ATMAmp0LabelPos.HorizontalAlignment = 'left';
    app.ATMAmp0LabelPos.Layout.Row = 5;
    app.ATMAmp0LabelPos.Layout.Column = [1,6];
    app.ATMAmp0LabelPos.Text = 'Start pos. Amplitude: ';
    % Create Amp0 Edit Field
    app.ATMAmp0EditFieldPos = uieditfield(app.ATMGridLayout,"numeric");
    app.ATMAmp0EditFieldPos.HorizontalAlignment = 'right';
    app.ATMAmp0EditFieldPos.Layout.Row = 5;
    app.ATMAmp0EditFieldPos.Layout.Column = [8,11];
    app.ATMAmp0EditFieldPos.Value = 8;
    app.ATMAmp0EditFieldPos.ValueDisplayFormat = "%.2f V";
    % Create Amp0 Label
    app.ATMAmp0LabelNeg = uilabel(app.ATMGridLayout);
    app.ATMAmp0LabelNeg.HorizontalAlignment = 'left';
    app.ATMAmp0LabelNeg.Layout.Row = 5;
    app.ATMAmp0LabelNeg.Layout.Column = [13,21];
    app.ATMAmp0LabelNeg.Text = 'Start neg. Amplitude: ';
    % Create Amp0 Edit Field
    app.ATMAmp0EditFieldNeg = uieditfield(app.ATMGridLayout,"numeric");
    app.ATMAmp0EditFieldNeg.HorizontalAlignment = 'right';
    app.ATMAmp0EditFieldNeg.Layout.Row = 5;
    app.ATMAmp0EditFieldNeg.Layout.Column = [21,24];
    app.ATMAmp0EditFieldNeg.Value = -12;
    app.ATMAmp0EditFieldNeg.ValueDisplayFormat = "%.2f V";

    % Create Ampn Label
    app.ATMAmpnLabelPos = uilabel(app.ATMGridLayout);
    app.ATMAmpnLabelPos.HorizontalAlignment = 'left';
    app.ATMAmpnLabelPos.Layout.Row = 6;
    app.ATMAmpnLabelPos.Layout.Column = [1,6];
    app.ATMAmpnLabelPos.Text = 'End pos. Amplitude: ';
    % Create Ampn Edit Field
    app.ATMAmpnEditFieldPos = uieditfield(app.ATMGridLayout,"numeric");
    app.ATMAmpnEditFieldPos.HorizontalAlignment = 'right';
    app.ATMAmpnEditFieldPos.Layout.Row = 6;
    app.ATMAmpnEditFieldPos.Layout.Column = [8,11];
    app.ATMAmpnEditFieldPos.Value = 2;
    app.ATMAmpnEditFieldPos.ValueDisplayFormat = "%.2f V";
    % Create Ampn Label
    app.ATMAmpnLabelNeg = uilabel(app.ATMGridLayout);
    app.ATMAmpnLabelNeg.HorizontalAlignment = 'left';
    app.ATMAmpnLabelNeg.Layout.Row = 6;
    app.ATMAmpnLabelNeg.Layout.Column = [13,21];
    app.ATMAmpnLabelNeg.Text = 'End neg. Amplitude: ';
    % Create Ampn Edit Field
    app.ATMAmpnEditFieldNeg = uieditfield(app.ATMGridLayout,"numeric");
    app.ATMAmpnEditFieldNeg.HorizontalAlignment = 'right';
    app.ATMAmpnEditFieldNeg.Layout.Row = 6;
    app.ATMAmpnEditFieldNeg.Layout.Column = [21,24];
    app.ATMAmpnEditFieldNeg.Value = -2;
    app.ATMAmpnEditFieldNeg.ValueDisplayFormat = "%.2f V";

    % % Create AmpShiftperDec Label
    % app.ATMAmpShiftperDecLabel = uilabel(app.ATMGridLayout);
    % app.ATMAmpShiftperDecLabel.HorizontalAlignment = 'left';
    % app.ATMAmpShiftperDecLabel.Layout.Row = 7;
    % app.ATMAmpShiftperDecLabel.Layout.Column = [1,7];
    % app.ATMAmpShiftperDecLabel.Text = 'Amplitude shift per decade: ';
    % % Create AmpShiftperDec Edit Field
    % app.ATMAmpShiftperDecEditField = uieditfield(app.ATMGridLayout,"numeric");
    % app.ATMAmpShiftperDecEditField.HorizontalAlignment = 'right';
    % app.ATMAmpShiftperDecEditField.Layout.Row = 7;
    % app.ATMAmpShiftperDecEditField.Layout.Column = [8,24];
    % app.ATMAmpShiftperDecEditField.Value = 10;
    % app.ATMAmpShiftperDecEditField.ValueDisplayFormat = "%.2f V/dec";
    

    % Create ATMReadperDecLabel Label
    app.ATMReadperDecLabel = uilabel(app.ATMGridLayout);
    app.ATMReadperDecLabel.HorizontalAlignment = 'left';
    app.ATMReadperDecLabel.Layout.Row = 8;
    app.ATMReadperDecLabel.Layout.Column = [1,7];
    app.ATMReadperDecLabel.Text = 'Read procedure/decade: ';
    % Create ATMReadperDecEditField Edit Field
    app.ATMReadperDecEditField = uieditfield(app.ATMGridLayout,"numeric");
    app.ATMReadperDecEditField.HorizontalAlignment = 'right';
    app.ATMReadperDecEditField.Layout.Row = 8;
    app.ATMReadperDecEditField.Layout.Column = [8,24];
    app.ATMReadperDecEditField.Value = 3;


    % % Create ATMresetAmpReadLabel Label
    % app.ATMresetAmpReadLabel = uilabel(app.ATMGridLayout);
    % app.ATMresetAmpReadLabel.HorizontalAlignment = 'left';
    % app.ATMresetAmpReadLabel.Layout.Row = 9;
    % app.ATMresetAmpReadLabel.Layout.Column = [1,7];
    % app.ATMresetAmpReadLabel.Text = 'Re-Set Read Amplitude: ';
    % % Create ATMresetAmpReadEditField Edit Field
    % app.ATMresetAmpReadEditField = uieditfield(app.ATMGridLayout,"numeric");
    % app.ATMresetAmpReadEditField.HorizontalAlignment = 'right';
    % app.ATMresetAmpReadEditField.Layout.Row = 9;
    % app.ATMresetAmpReadEditField.Layout.Column = [8,24];
    % app.ATMresetAmpReadEditField.Value = 10;
    % app.ATMresetAmpReadEditField.ValueDisplayFormat = "%.2f V";
    
    % Create ATMCuRangeDropDownLabel
    app.ATMCuRangeDropDownLabel = uilabel(app.ATMGridLayout);
    app.ATMCuRangeDropDownLabel.HorizontalAlignment = 'left';
    app.ATMCuRangeDropDownLabel.Layout.Row = 10;
    app.ATMCuRangeDropDownLabel.Layout.Column = [1,7];
    app.ATMCuRangeDropDownLabel.Text = 'Current Range: ';
    % Create ATMCuRangeDropDown
    app.ATMCuRangeDropDown = uidropdown(app.ATMGridLayout);
    app.ATMCuRangeDropDown.Items = {'auto', '1 A', '100 mA', '10 mA', '1 mA','100 µA', '10 µA', '1 µA', '100 nA', '10 nA', '1 nA', '100 pA', '10 pA'};
    app.ATMCuRangeDropDown.ItemsData ={-1,0,1,4,5,6,7,8,9,10,11,12,13};
    app.ATMCuRangeDropDown.Value = 12;
    app.ATMCuRangeDropDown.Layout.Row = 10;
    app.ATMCuRangeDropDown.Layout.Column = [20,24];

    % Create ATMoutFolderLabel Label
    app.ATMoutFolderLabel = uilabel(app.ATMGridLayout);
    app.ATMoutFolderLabel.HorizontalAlignment = 'left';
    app.ATMoutFolderLabel.Layout.Row = 11;
    app.ATMoutFolderLabel.Layout.Column = [1,7];
    app.ATMoutFolderLabel.Text = 'Output Folder: ';
    % Create ATMoutFolderEditField Edit Field
    app.ATMoutFolderEditField = uieditfield(app.ATMGridLayout);
    app.ATMoutFolderEditField.HorizontalAlignment = 'left';
    app.ATMoutFolderEditField.Layout.Row = 11;
    app.ATMoutFolderEditField.Layout.Column = [8,24];
    app.ATMoutFolderEditField.Value = "D:/Measurements/viwi/";

    % Create ATMbaseFileNameLabel Label
    app.ATMbaseFileNameLabel = uilabel(app.ATMGridLayout);
    app.ATMbaseFileNameLabel.HorizontalAlignment = 'left';
    app.ATMbaseFileNameLabel.Layout.Row = 12;
    app.ATMbaseFileNameLabel.Layout.Column = [1,7];
    app.ATMbaseFileNameLabel.Text = 'File basename: ';
    % Create ATMbaseFileNameEditField Edit Field
    app.ATMbaseFileNameEditField = uieditfield(app.ATMGridLayout);
    app.ATMbaseFileNameEditField.HorizontalAlignment = 'left';
    app.ATMbaseFileNameEditField.Layout.Row = 12;
    app.ATMbaseFileNameEditField.Layout.Column = [8,24];
    app.ATMbaseFileNameEditField.Value = "FatigueChangedAmp";

    app.saveInOneFileCheckBox =  uicheckbox(app.ATMGridLayout);
    app.saveInOneFileCheckBox.Layout.Row = 13;
    app.saveInOneFileCheckBox.Layout.Column = [8,24];
    app.saveInOneFileCheckBox.Value = false;
    app.saveInOneFileCheckBox.Text = 'Save in one File';
    
    % Create ATM Start Button
    app.ATMStartMeasButton = uibutton(app.ATMGridLayout,'state');
    app.ATMStartMeasButton.Layout.Row = [15,17] ;
    app.ATMStartMeasButton.Layout.Column = [1,24] ;
    app.ATMStartMeasButton.Text = 'Start ATM';
    app.ATMStartMeasButton.Value = false;

    % %Create ATM Image
    % app.ATMImage = uiimage(app.ATMGridLayout);
    % app.ATMImage.ImageSource = fullfile(app.currPWD, 'images',  'ReadandTreat.png');
    % app.ATMImage.Layout.Row = [18,32];
    % app.ATMImage.Layout.Column = [1,24] ;
    % app.ATMImage.ScaleMethod = 'scaledown';
    % % Create ATMfTreatImage Label
    % app.ATMfTreatImage = uilabel(app.ATMGridLayout);
    % app.ATMfTreatImage.HorizontalAlignment = 'center';
    % app.ATMfTreatImage.Layout.Row = [20];
    % app.ATMfTreatImage.Layout.Column = [8,11];
    % app.ATMfTreatImage.Text = 'Treat frequency';
    % app.ATMfTreatImage.Interpreter = 'LaTeX';    

    app.ATMEcShiftDropDown.ValueChangedFcn = @(src,event) updateATMcbs(app,src,event);
    app.ATMStartMeasButton.ValueChangedFcn = @(src,event) startATM(app,src,event);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Create Tab2
    app.SKMTab = uitab(app.TabGroup2);
    app.SKMTab.Title = 'SKM';
    app.SKMTab.Scrollable = 'on';
    app.SKMTab.Tooltip = "Switching Kinetic Measurement";

    % Create GridLayout
    app.SKGridLayout = uigridlayout(app.SKMTab);
    app.SKGridLayout.ColumnWidth = {22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22,22, 22, 22, 22, 22, 22, 22, 22};
    app.SKGridLayout.RowHeight = {22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22,22, 22, 22, 22, 22, 22, 22, 22, 22};
    app.SKGridLayout.ColumnSpacing = 1;
    app.SKGridLayout.RowSpacing = 5;
    app.SKGridLayout.Padding = [10 10 10 10];
    app.SKGridLayout.Scrollable = 'on';

    % Create AmplifierDropDownLabel
    app.SKAmplifierDropDownLabel = uilabel(app.SKGridLayout);
    app.SKAmplifierDropDownLabel.HorizontalAlignment = 'left';
    app.SKAmplifierDropDownLabel.Layout.Row = 1;
    app.SKAmplifierDropDownLabel.Layout.Column = [1 5];
    app.SKAmplifierDropDownLabel.Text = 'Amplifier: ';
    % Create SKAmplifierDropDown
    app.SKAmplifierDropDown = uidropdown(app.SKGridLayout);
    app.SKAmplifierDropDown.Items = {'FE-HeadAmp','HV-Amp'};
    app.SKAmplifierDropDown.Value = 'FE-HeadAmp';
    app.SKAmplifierDropDown.Layout.Row = 1;
    app.SKAmplifierDropDown.Layout.Column = [6 12];
    app.SKAmplifierDropDown.Enable = 'on';
    % 
    % % Create PMModeLabel
    % app.SKModeLabel = uilabel(app.SKGridLayout);
    % app.SKModeLabel.HorizontalAlignment = 'left';
    % app.SKModeLabel.Layout.Row = 2;
    % app.SKModeLabel.Layout.Column = [1 5];
    % app.SKModeLabel.Text = 'SKM Mode: ';
    
    % % Create PMMode
    % app.SKMode = uidropdown(app.SKGridLayout);
    % app.SKMode.Items = ["Set|SteadyState|Reset+Leakage"];
    % app.SKMode.ItemsData = {0};
    % app.SKMode.Value = 0;
    % app.SKMode.Layout.Row = 2;
    % app.SKMode.Layout.Column = [6 12];
    % app.SKMode.Enable = 'off';
    % % app.PMMode.Enable = 'off';
    % app.SKMode.Tooltip="W pulses are not evaluated by the TFA and may be not as precise as R pulses.";

    % Create PMSeqLabel
    app.SKSeqLabel = uilabel(app.SKGridLayout);
    app.SKSeqLabel.HorizontalAlignment = 'right';
    app.SKSeqLabel.Layout.Row = 3;
    app.SKSeqLabel.Layout.Column = [12 16];
    app.SKSeqLabel.Text = 'Sequence: ';
    % Create Button
    app.SKSeqButton1 = uibutton(app.SKGridLayout);
    app.SKSeqButton1.Layout.Row = 3;
    app.SKSeqButton1.Layout.Column = 17;
    app.SKSeqButton1.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posRed.png');
    app.SKSeqButton1.Text = '';
    app.SKSeqButton1.UserData = 0;
    app.SKSeqButton1.Enable = "off";
    % Create Button
    app.SKSeqButton2 = uibutton(app.SKGridLayout);
    app.SKSeqButton2.Layout.Row = 3;
    app.SKSeqButton2.Layout.Column = 18;
    % app.SKSeqButton2.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'disRed.png');
    app.SKSeqButton2.Text = '';
    app.SKSeqButton2.UserData = 0;
    app.SKSeqButton2.Enable = "off";
    app.SKSeqButton2.Visible = "off";
    % Create Button
    app.SKSeqButton3 = uibutton(app.SKGridLayout);
    app.SKSeqButton3.Layout.Row = 3;
    app.SKSeqButton3.Layout.Column = 19;
    app.SKSeqButton3.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'posRed.png');
    app.SKSeqButton3.Text = '';
    app.SKSeqButton3.UserData = 0;
    app.SKSeqButton3.Enable = "off";
    % Create Button
    app.SKSeqButton4 = uibutton(app.SKGridLayout);
    app.SKSeqButton4.Layout.Row = 3;
    app.SKSeqButton4.Layout.Column = 20;
    app.SKSeqButton4.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negRed.png');
    app.SKSeqButton4.Text = '';
    app.SKSeqButton4.UserData = 0;
    app.SKSeqButton4.Enable = "off";
    app.SKSeqButton4.Visible = "off";
    % Create Button
    app.SKSeqButton5 = uibutton(app.SKGridLayout);
    app.SKSeqButton5.Layout.Row = 3;
    app.SKSeqButton5.Layout.Column = 21;
    app.SKSeqButton5.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'disRed.png');
    app.SKSeqButton5.Text = '';
    app.SKSeqButton5.UserData = 0;
    app.SKSeqButton5.Enable = "off";
    app.SKSeqButton5.Visible = "off";
    % Create Button
    app.SKSeqButton6 = uibutton(app.SKGridLayout);
    app.SKSeqButton6.Layout.Row = 3;
    app.SKSeqButton6.Layout.Column = 22;
    app.SKSeqButton6.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negRed.png');
    app.SKSeqButton6.Text = '';
    app.SKSeqButton6.UserData = 0;
    app.SKSeqButton6.Enable = "off";
    % Create Button
    app.SKSeqButton7 = uibutton(app.SKGridLayout);
    app.SKSeqButton7.Layout.Row = 3;
    app.SKSeqButton7.Layout.Column = 23;
    app.SKSeqButton7.Icon = fullfile(app.currPWD, 'images', 'rectPulses', 'negRed.png');
    app.SKSeqButton7.Text = '';
    app.SKSeqButton7.UserData = 0;
    app.SKSeqButton7.Enable = "off";
    
    % Creaate PMWaveformDropDownLabel
    app.SKSetDirLabel = uilabel(app.SKGridLayout);
    app.SKSetDirLabel.HorizontalAlignment = 'left';
    app.SKSetDirLabel.Layout.Row = 3;
    app.SKSetDirLabel.Layout.Column = [1 5];
    app.SKSetDirLabel.Text = 'Set Pulse Direction: ';

    % Create PMWaveformDropDown
    app.SKSetDir = uidropdown(app.SKGridLayout);
    app.SKSetDir.Items = ["M-N","N-M"];
    app.SKSetDir.ItemsData = {1,-1};
    app.SKSetDir.Value = 1;
    app.SKSetDir.Layout.Row = 3;
    app.SKSetDir.Layout.Column = [6 12];

     % Creaate PMWaveformDropDownLabel
    app.SKWaveformDropDownLabel = uilabel(app.SKGridLayout);
    app.SKWaveformDropDownLabel.HorizontalAlignment = 'left';
    app.SKWaveformDropDownLabel.Layout.Row = 4;
    app.SKWaveformDropDownLabel.Layout.Column = [1 12];
    app.SKWaveformDropDownLabel.Text = 'Reset & Leakage Pulse Waveform: ';
    % Create PMWaveformDropDown
    % app.SKWaveformDropDown = uidropdown(app.SKGridLayout);
    % app.SKWaveformDropDown.Items = ["Trapezoid","Triangle","Rectangle"];
    % app.SKWaveformDropDown.ItemsData = {0,1,2};
    % app.SKWaveformDropDown.Value = 2;
    % app.SKWaveformDropDown.Layout.Row = 4;
    % app.SKWaveformDropDown.Layout.Column = [6 12];
    % app.SKWaveformDropDown.Enable = 'off';

    app.SKResetWaveformDropDown = uidropdown(app.SKGridLayout);
    app.SKResetWaveformDropDown.Items = ["Trapezoid","Triangle"];
    app.SKResetWaveformDropDown.ItemsData = {0,1};
    app.SKResetWaveformDropDown.Value = 0;
    app.SKResetWaveformDropDown.Layout.Row = 4;
    app.SKResetWaveformDropDown.Layout.Column = [14 20];
    app.SKResetWaveformDropDown.Enable = 'on';

    app.SKWritePulsePanLabel = uilabel(app.SKGridLayout);
    app.SKWritePulsePanLabel.HorizontalAlignment = 'left';
    app.SKWritePulsePanLabel.Layout.Row = 5;
    app.SKWritePulsePanLabel.Layout.Column = [1,23];
    app.SKWritePulsePanLabel.Text = 'Set Pulse: ';
    app.SKWritePulsePanLabel.BackgroundColor = [1,1,1];
    
    % CrSKte wam Label
    app.SKwamLabel = uilabel(app.SKGridLayout);
    app.SKwamLabel.HorizontalAlignment = 'left';
    app.SKwamLabel.Layout.Row = 6;
    app.SKwamLabel.Layout.Column = [1,15];
    app.SKwamLabel.Text = 'Set Pulse Amplitude: ';
    % CrSKte wam Edit Field
    app.SKwamEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKwamEditField.HorizontalAlignment = 'right';
    app.SKwamEditField.Layout.Row = 6;
    app.SKwamEditField.Layout.Column = [16,22];
    app.SKwamEditField.Value = 3;
    % CrSKte wam Unit Label
    app.SKwamUnit = uilabel(app.SKGridLayout);
    app.SKwamUnit.HorizontalAlignment = 'left';
    app.SKwamUnit.Layout.Row = 6;
    app.SKwamUnit.Layout.Column = 23;
    app.SKwamUnit.Text = "V";

    % CrSKte wpu Label
    app.SKwpu0Label = uilabel(app.SKGridLayout);
    app.SKwpu0Label.HorizontalAlignment = 'left';
    app.SKwpu0Label.Layout.Row = 7;
    app.SKwpu0Label.Layout.Column = [1,15];
    app.SKwpu0Label.Text = 'Min. Set Pulsewidth: ';
    % CrSKte wpu Edit Field
    app.SKwpu0EditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKwpu0EditField.HorizontalAlignment = 'right';
    app.SKwpu0EditField.Layout.Row = 7;
    app.SKwpu0EditField.Layout.Column = [16,22];
    app.SKwpu0EditField.Value = 5;
    % CrSKte wpu Unit Label
    app.SKwpu0Unit = uilabel(app.SKGridLayout);
    app.SKwpu0Unit.HorizontalAlignment = 'left';
    app.SKwpu0Unit.Layout.Row = 7;
    app.SKwpu0Unit.Layout.Column = 23;
    app.SKwpu0Unit.Text = "ms";

    % CrSKte wpu Label
    app.SKwpuNLabel = uilabel(app.SKGridLayout);
    app.SKwpuNLabel.HorizontalAlignment = 'left';
    app.SKwpuNLabel.Layout.Row = 8;
    app.SKwpuNLabel.Layout.Column = [1,15];
    app.SKwpuNLabel.Text = 'Max. Set Pulsewidth: ';
    % CrSKte wpu Edit Field
    app.SKwpuNEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKwpuNEditField.HorizontalAlignment = 'right';
    app.SKwpuNEditField.Layout.Row = 8;
    app.SKwpuNEditField.Layout.Column = [16,22];
    app.SKwpuNEditField.Value = 5;
    % CrSKte wpu Unit Label
    app.SKwpuNUnit = uilabel(app.SKGridLayout);
    app.SKwpuNUnit.HorizontalAlignment = 'left';
    app.SKwpuNUnit.Layout.Row = 8;
    app.SKwpuNUnit.Layout.Column = 23;
    app.SKwpuNUnit.Text = "ms";

    % CrSKte wri Label
    app.SKwriLabel = uilabel(app.SKGridLayout);
    app.SKwriLabel.HorizontalAlignment = 'left';
    app.SKwriLabel.Layout.Row = 9;
    app.SKwriLabel.Layout.Column = [1,15];
    app.SKwriLabel.Text = 'Write Risetime: ';
    % CrSKte wri Edit Field
    app.SKwriEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKwriEditField.HorizontalAlignment = 'right';
    app.SKwriEditField.Layout.Row = 9;
    app.SKwriEditField.Layout.Column = [16,22];
    app.SKwriEditField.Value = 0;
    app.SKwriEditField.Enable = 'off';
    % CrSKte wri Unit Label
    app.SKwriUnit = uilabel(app.SKGridLayout);
    app.SKwriUnit.HorizontalAlignment = 'left';
    app.SKwriUnit.Layout.Row = 9;
    app.SKwriUnit.Layout.Column = 23;
    app.SKwriUnit.Text = "ms";
  
    % CrSKte wri Label
    app.SKdel2readLabel = uilabel(app.SKGridLayout);
    app.SKdel2readLabel.HorizontalAlignment = 'left';
    app.SKdel2readLabel.Layout.Row = 10;
    app.SKdel2readLabel.Layout.Column = [1,15];
    app.SKdel2readLabel.Text = 'Delay';
    % CrSKte wri Edit Field
    app.SKdel2readEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKdel2readEditField.HorizontalAlignment = 'right';
    app.SKdel2readEditField.Layout.Row = 10;
    app.SKdel2readEditField.Layout.Column = [16,22];
    app.SKdel2readEditField.Value = 5;
    % CrSKte read (delay to read) Unit Label
    app.SKdel2readUnit = uilabel(app.SKGridLayout);
    app.SKdel2readUnit.HorizontalAlignment = 'left';
    app.SKdel2readUnit.Layout.Row = 10;
    app.SKdel2readUnit.Layout.Column = 23;
    app.SKdel2readUnit.Text = "ms";
    %%%%SK%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% SKad Panel of PM
    app.SKSmAmpPanLabel = uilabel(app.SKGridLayout);
    app.SKSmAmpPanLabel.HorizontalAlignment = 'left';
    app.SKSmAmpPanLabel.Layout.Row = 11;
    app.SKSmAmpPanLabel.Layout.Column = [1,11];
    app.SKSmAmpPanLabel.Text = 'Small Amplitude Pulse: ';
    app.SKSmAmpPanLabel.BackgroundColor = [1,1,1];

    app.SKSmAmpCheckBox = uicheckbox(app.SKGridLayout);
    app.SKSmAmpCheckBox.Layout.Row = 11;
    app.SKSmAmpCheckBox.Layout.Column = 11;
    app.SKSmAmpCheckBox.Text = "";
    app.SKSmAmpCheckBox.Value = 1;

    
    % CrSKte (read) amp Label
    app.SKSmAmpampLabel= uilabel(app.SKGridLayout);
    app.SKSmAmpampLabel.HorizontalAlignment = 'left';
    app.SKSmAmpampLabel.Layout.Row = 12;
    app.SKSmAmpampLabel.Layout.Column = [1,6];
    app.SKSmAmpampLabel.Text = 'Amplitude: ';
    % CrSKte wam Edit Field
    app.SKSmAmpampEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKSmAmpampEditField.HorizontalAlignment = 'right';
    app.SKSmAmpampEditField.Layout.Row = 12;
    app.SKSmAmpampEditField.Layout.Column = [7,10];
    app.SKSmAmpampEditField.Value = 3;
    % CrSKte wam Unit Label
    app.SKSmAmpampUnit = uilabel(app.SKGridLayout);
    app.SKSmAmpampUnit.HorizontalAlignment = 'left';
    app.SKSmAmpampUnit.Layout.Row = 12;
    app.SKSmAmpampUnit.Layout.Column = 11;
    app.SKSmAmpampUnit.Text = "V";
    % CrSKte rpu Label
    app.SKSmAmprpuLabel = uilabel(app.SKGridLayout);
    app.SKSmAmprpuLabel.HorizontalAlignment = 'left';
    app.SKSmAmprpuLabel.Layout.Row = 13;
    app.SKSmAmprpuLabel.Layout.Column = [1,6];
    app.SKSmAmprpuLabel.Text = 'Pulsewidth: ';
    % CrSKte rpu Edit Field
    app.SKSmAmprpuEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKSmAmprpuEditField.HorizontalAlignment = 'right';
    app.SKSmAmprpuEditField.Layout.Row = 13;
    app.SKSmAmprpuEditField.Layout.Column = [7,10];
    app.SKSmAmprpuEditField.Value = 5;
    % CrSKte rpu Unit Label
    app.SKSmAmprpuUnit = uilabel(app.SKGridLayout);
    app.SKSmAmprpuUnit.HorizontalAlignment = 'left';
    app.SKSmAmprpuUnit.Layout.Row = 13;
    app.SKSmAmprpuUnit.Layout.Column = 11;
    app.SKSmAmprpuUnit.Text = "ms";
    % CrSKte wri Label
    app.SKSmAmprriLabel = uilabel(app.SKGridLayout);
    app.SKSmAmprriLabel.HorizontalAlignment = 'left';
    app.SKSmAmprriLabel.Layout.Row = 14;
    app.SKSmAmprriLabel.Layout.Column = [1,6];
    app.SKSmAmprriLabel.Text = 'Risetime: ';
    % CrSKte wri Edit Field
    app.SKSmAmprriEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKSmAmprriEditField.HorizontalAlignment = 'right';
    app.SKSmAmprriEditField.Layout.Row = 14;
    app.SKSmAmprriEditField.Layout.Column = [7,10];
    app.SKSmAmprriEditField.Value = 5;
    app.SKSmAmprriEditField.Enable = 'off';
    % CrSKte wri Unit Label
    app.SKSmAmprriUnit = uilabel(app.SKGridLayout);
    app.SKSmAmprriUnit.HorizontalAlignment = 'left';
    app.SKSmAmprriUnit.Layout.Row = 14;
    app.SKSmAmprriUnit.Layout.Column = 11;
    app.SKSmAmprriUnit.Text = "ms";
    % CrSKte wri Label
    app.SKSmAmpdelaytLabel = uilabel(app.SKGridLayout);
    app.SKSmAmpdelaytLabel.HorizontalAlignment = 'left';
    app.SKSmAmpdelaytLabel.Layout.Row = 15;
    app.SKSmAmpdelaytLabel.Layout.Column = [1,6];
    app.SKSmAmpdelaytLabel.Text = 'Delay';
    % CrSKte wri Edit Field
    app.SKSmAmpdelaytEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKSmAmpdelaytEditField.HorizontalAlignment = 'right';
    app.SKSmAmpdelaytEditField.Layout.Row = 15;
    app.SKSmAmpdelaytEditField.Layout.Column = [7,10];
    app.SKSmAmpdelaytEditField.Value = 5;
    % CrSKte read (delay to read) Unit Label
    app.SKSmAmpdelaytUnit = uilabel(app.SKGridLayout);
    app.SKSmAmpdelaytUnit.HorizontalAlignment = 'left';
    app.SKSmAmpdelaytUnit.Layout.Row = 15;
    app.SKSmAmpdelaytUnit.Layout.Column = 11;
    app.SKSmAmpdelaytUnit.Text = "ms";

    %%%%SK%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% SKad Panel of PM
    app.SKReadPulsePanLabel = uilabel(app.SKGridLayout);
    app.SKReadPulsePanLabel.HorizontalAlignment = 'left';
    app.SKReadPulsePanLabel.Layout.Row = 11;
    app.SKReadPulsePanLabel.Layout.Column = [13,23];
    app.SKReadPulsePanLabel.Text = 'Reset and leakage Pulse: ';
    app.SKReadPulsePanLabel.BackgroundColor = [1,1,1];

    % CrSKte (read) amp Label
    app.SKampLabel = uilabel(app.SKGridLayout);
    app.SKampLabel.HorizontalAlignment = 'left';
    app.SKampLabel.Layout.Row = 12;
    app.SKampLabel.Layout.Column = [13,18];
    app.SKampLabel.Text = 'Amplitude: ';
    % CrSKte wam Edit Field
    app.SKampEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKampEditField.HorizontalAlignment = 'right';
    app.SKampEditField.Layout.Row = 12;
    app.SKampEditField.Layout.Column = [19,22];
    app.SKampEditField.Value = 3;
    % CrSKte wam Unit Label
    app.SKampUnit = uilabel(app.SKGridLayout);
    app.SKampUnit.HorizontalAlignment = 'left';
    app.SKampUnit.Layout.Row = 12;
    app.SKampUnit.Layout.Column = 23;
    app.SKampUnit.Text = "V";
    % CrSKte rpu Label
    app.SKrpuLabel = uilabel(app.SKGridLayout);
    app.SKrpuLabel.HorizontalAlignment = 'left';
    app.SKrpuLabel.Layout.Row = 13;
    app.SKrpuLabel.Layout.Column = [13,18];
    app.SKrpuLabel.Text = 'Pulsewidth: ';
    % CrSKte rpu Edit Field
    app.SKrpuEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKrpuEditField.HorizontalAlignment = 'right';
    app.SKrpuEditField.Layout.Row = 13;
    app.SKrpuEditField.Layout.Column = [19,22];
    app.SKrpuEditField.Value = 5;
    % CrSKte rpu Unit Label
    app.SKrpuUnit = uilabel(app.SKGridLayout);
    app.SKrpuUnit.HorizontalAlignment = 'left';
    app.SKrpuUnit.Layout.Row = 13;
    app.SKrpuUnit.Layout.Column = 23;
    app.SKrpuUnit.Text = "ms";
    % CrSKte wri Label
    app.SKrriLabel = uilabel(app.SKGridLayout);
    app.SKrriLabel.HorizontalAlignment = 'left';
    app.SKrriLabel.Layout.Row = 14;
    app.SKrriLabel.Layout.Column = [13,18];
    app.SKrriLabel.Text = 'Risetime: ';
    % CrSKte wri Edit Field
    app.SKrriEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKrriEditField.HorizontalAlignment = 'right';
    app.SKrriEditField.Layout.Row = 14;
    app.SKrriEditField.Layout.Column = [19,22];
    app.SKrriEditField.Value = 5;
    app.SKrriEditField.Enable = 'off';
    % CrSKte wri Unit Label
    app.SKrriUnit = uilabel(app.SKGridLayout);
    app.SKrriUnit.HorizontalAlignment = 'left';
    app.SKrriUnit.Layout.Row = 14;
    app.SKrriUnit.Layout.Column = 23;
    app.SKrriUnit.Text = "ms";
    % CrSKte wri Label
    app.SKdelaytLabel = uilabel(app.SKGridLayout);
    app.SKdelaytLabel.HorizontalAlignment = 'left';
    app.SKdelaytLabel.Layout.Row = 15;
    app.SKdelaytLabel.Layout.Column = [13,18];
    app.SKdelaytLabel.Text = 'Delay';
    % CrSKte wri Edit Field
    app.SKdelaytEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKdelaytEditField.HorizontalAlignment = 'right';
    app.SKdelaytEditField.Layout.Row = 15;
    app.SKdelaytEditField.Layout.Column = [19,22];
    app.SKdelaytEditField.Value = 5;
    % CrSKte read (delay to read) Unit Label
    app.SKdelaytUnit = uilabel(app.SKGridLayout);
    app.SKdelaytUnit.HorizontalAlignment = 'left';
    app.SKdelaytUnit.Layout.Row = 15;
    app.SKdelaytUnit.Layout.Column = 23;
    app.SKdelaytUnit.Text = "ms";
    %%%%SK%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% SKnitoring of PM
    app.SKMonitoringPanLabel = uilabel(app.SKGridLayout);
    app.SKMonitoringPanLabel.HorizontalAlignment = 'left';
    app.SKMonitoringPanLabel.Layout.Row = 16;
    app.SKMonitoringPanLabel.Layout.Column = [1,23];
    app.SKMonitoringPanLabel.Text = 'Monitoring: ';
    app.SKMonitoringPanLabel.BackgroundColor = [1,1,1];
    % CrSKte PMCuRangeDropDownLabel
    app.SKCuRangeDropDownLabel=uilabel(app.SKGridLayout);
    app.SKCuRangeDropDownLabel.Layout.Row =17;
    app.SKCuRangeDropDownLabel.Layout.Column =[1,9];
    app.SKCuRangeDropDownLabel.HorizontalAlignment = 'left';
    app.SKCuRangeDropDownLabel.Text='Curr. range Set|Sm.Amp.|Reset: ';
    % CrSKte PMCuRangeDropDown (correct control and placement)
    app.SKCuRangeDropDown = uidropdown(app.SKGridLayout);
    app.SKCuRangeDropDown.Layout.Row = 17;
    app.SKCuRangeDropDown.Layout.Column = [10,13];
    app.SKCuRangeDropDown.Items = {'10 nC', '1 nC', '100 pC'};
    app.SKCuRangeDropDown.ItemsData ={15,16,17};
    app.SKCuRangeDropDown.Value = 15;
    app.SKCuRangeDropDown.Enable = 'on';
    % CrSKte PMCuRangeDropDown (correct control and placement)
    app.SKSmAmpCuRangeDropDown = uidropdown(app.SKGridLayout);
    app.SKSmAmpCuRangeDropDown.Layout.Row = 17;
    app.SKSmAmpCuRangeDropDown.Layout.Column = [15,18];
    app.SKSmAmpCuRangeDropDown.Items = {'1 A', '100 mA', '10 mA', '1 mA','100 µA', '10 µA', '1 µA', '100 nA', '10 nA', '1 nA', '100 pA', '10 pA'};
    app.SKSmAmpCuRangeDropDown.ItemsData ={0,1,4,5,6,7,8,9,10,11,12,13};
    app.SKSmAmpCuRangeDropDown.Value = 1;
    app.SKSmAmpCuRangeDropDown.Enable = 'on';
    % CrSKte PMCuRangeDropDown (correct control and placement)
    app.SKResetCuRangeDropDown = uidropdown(app.SKGridLayout);
    app.SKResetCuRangeDropDown.Layout.Row = 17;
    app.SKResetCuRangeDropDown.Layout.Column = [20,23];
    app.SKResetCuRangeDropDown.Items = {'1 A', '100 mA', '10 mA', '1 mA','100 µA', '10 µA', '1 µA', '100 nA', '10 nA', '1 nA', '100 pA', '10 pA'};
    app.SKResetCuRangeDropDown.ItemsData ={0,1,4,5,6,7,8,9,10,11,12,13};
    app.SKResetCuRangeDropDown.Value = 1;
    app.SKResetCuRangeDropDown.Enable = 'on';
    
    app.SKProcPerPWDecadeLabel = uilabel(app.SKGridLayout);
    app.SKProcPerPWDecadeLabel.Layout.Row =18;
    app.SKProcPerPWDecadeLabel.Layout.Column =[1,10];
    app.SKProcPerPWDecadeLabel.HorizontalAlignment = 'left';
    app.SKProcPerPWDecadeLabel.Text='Procedures per Pulsewidth decade: ';

    app.SKProcPerPWDecadeEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKProcPerPWDecadeEditField.HorizontalAlignment = 'right';
    app.SKProcPerPWDecadeEditField.Layout.Row = 18;
    app.SKProcPerPWDecadeEditField.Layout.Column = [16,23];
    app.SKProcPerPWDecadeEditField.Value = 10;

    app.SKProcPerPWLabel = uilabel(app.SKGridLayout);
    app.SKProcPerPWLabel.Layout.Row =19;
    app.SKProcPerPWLabel.Layout.Column =[1,10];
    app.SKProcPerPWLabel.HorizontalAlignment = 'left';
    app.SKProcPerPWLabel.Text='Procedures per Pulsewidth value: ';

    app.SKProcPerPWEditField = uieditfield(app.SKGridLayout,"numeric");
    app.SKProcPerPWEditField.HorizontalAlignment = 'right';
    app.SKProcPerPWEditField.Layout.Row = 19;
    app.SKProcPerPWEditField.Layout.Column = [16,23];
    app.SKProcPerPWEditField.Value = 1;
    

    % Create ATMoutFolderLabel Label
    app.SKoutFolderLabel = uilabel(app.SKGridLayout);
    app.SKoutFolderLabel.HorizontalAlignment = 'left';
    app.SKoutFolderLabel.Layout.Row = 20;
    app.SKoutFolderLabel.Layout.Column = [1,7];
    app.SKoutFolderLabel.Text = 'Output Folder: ';
    % Create ATMoutFolderEditField Edit Field
    app.SKoutFolderEditField = uieditfield(app.SKGridLayout);
    app.SKoutFolderEditField.HorizontalAlignment = 'left';
    app.SKoutFolderEditField.Layout.Row = 20;
    app.SKoutFolderEditField.Layout.Column = [8,23];
    dateStr = datestr(datetime('today'),'yyyymmdd');
    user = app.UserNameEditField.Value;
    app.SKoutFolderEditField.Value = sprintf("D:/Measurements/%s/SwitchingKinetics/%s/",user,dateStr);

    % Create ATMbaseFileNameLabel Label
    app.SKbaseFileNameLabel = uilabel(app.SKGridLayout);
    app.SKbaseFileNameLabel.HorizontalAlignment = 'left';
    app.SKbaseFileNameLabel.Layout.Row = 21;
    app.SKbaseFileNameLabel.Layout.Column = [1,7];
    app.SKbaseFileNameLabel.Text = 'File basename: ';
    % Create ATMbaseFileNameEditField Edit Field
    app.SKbaseFileNameEditField = uieditfield(app.SKGridLayout);
    app.SKbaseFileNameEditField.HorizontalAlignment = 'left';
    app.SKbaseFileNameEditField.Layout.Row = 21;
    app.SKbaseFileNameEditField.Layout.Column = [8,23];
    app.SKbaseFileNameEditField.Value = "SwKinBaseName";
    
    % CrSKte Start PM Button
    app.SKStartMeasButton = uibutton(app.SKGridLayout);
    app.SKStartMeasButton.Layout.Row = [23 25] ;
    app.SKStartMeasButton.Layout.Column = [1,23] ;
    app.SKStartMeasButton.Text = 'Start SKM';
    



    % SKcbs
    app.SKAmplifierDropDown.ValueChangedFcn = @(src,event) SKamplifierChange(app,src,event);
    app.SKSetDir.ValueChangedFcn = @(src,event) SKSetDirChange(app,src,event);

    app.SKwpu0EditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);
    app.SKwpuNEditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);
    app.SKwriEditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);
    app.SKdel2readEditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);
    app.SKResetWaveformDropDown.ValueChangedFcn=@(src,event) SKwaveform(app,src,event);

    app.SKSmAmprpuEditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);
    app.SKSmAmprriEditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);
    app.SKSmAmpdelaytEditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);
    app.SKrpuEditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);
    app.SKrriEditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);
    app.SKdelaytEditField.ValueChangedFcn=@(src,event) SKFieldsWithTime(app,src,event);

    app.SKSmAmpCheckBox.ValueChangedFcn=@(src,event) SKSmAmpCBChange(app,src,event);


    app.SKStartMeasButton.ButtonPushedFcn =@(src,event) SKStartStopBtn(app,src,event);

    app.SKQuickView = uiaxes(app.SKGridLayout);
    title(app.SKQuickView, 'QuickView')
    xlabel(app.SKQuickView, 'PulseWidth')
    yyaxis(app.SKQuickView,'left')
    ylabel(app.SKQuickView, 'Polarisation')
    yyaxis(app.SKQuickView,'right')
    ylabel(app.SKQuickView, 'Avg. Current between t=1.2rri and t=1.9rri')
    app.SKQuickView.Layout.Row = [4 16];
    app.SKQuickView.Layout.Column = [26 40];
    app.SKQuickView.Visible ="on";
    app.SKQuickView.XScale = 'log';
    grid(app.SKQuickView,'on');

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    app.TabGroup2.SelectionChangedFcn = @(src,event) tabgroup2Change(app,src,event);
    
    
    
    
    
    

   



    app.DataAnalysis = uitab(app.TabGroup);
    app.DataAnalysis.Title = 'Data Analysis';

    % Create GridLayout
    app.DAGridLayout = uigridlayout(app.DataAnalysis);
    app.DAGridLayout.ColumnWidth = {22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22,22, 22, 22, 22, 22, 22, 22, 22};
    app.DAGridLayout.RowHeight = {22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22, 22};

    % Create UIAxes
    app.DAUIAxes = uiaxes(app.DAGridLayout);
    title(app.DAUIAxes, 'Title')
    xlabel(app.DAUIAxes, 'X')
    ylabel(app.DAUIAxes, 'Y')
    app.DAUIAxes.Layout.Row = [1 12];
    app.DAUIAxes.Layout.Column = [16 32];
    app.DAUIAxes.Visible ="off";


    % Create ListBoxLabel
    app.DAListBoxLabel = uilabel(app.DAGridLayout);
    app.DAListBoxLabel.HorizontalAlignment = 'right';
    app.DAListBoxLabel.Layout.Row = 5;
    app.DAListBoxLabel.Layout.Column = [1 4];
    app.DAListBoxLabel.Text = 'List Box';

    % Create ListBox
    app.DAListBox = uilistbox(app.DAGridLayout);
    app.DAListBox.Layout.Row = [6 15];
    app.DAListBox.Layout.Column = [1 5];
    app.DAListBox.Items  = {};
    app.DAListBox.ValueChangedFcn = @(src,event) updateDATables(app,src,event);

    % Create UITable
    app.DAUITable = uitable(app.DAGridLayout);
    app.DAUITable.ColumnName = {};
    app.DAUITable.RowName = {};
    app.DAUITable.Layout.Row = [1 3];
    app.DAUITable.Layout.Column = [7 15];

    % Create UITable2
    app.DAUITable2 = uitable(app.DAGridLayout);
    app.DAUITable2.ColumnName = {};
    app.DAUITable2.RowName = {};
    app.DAUITable2.Layout.Row = [4 17];
    app.DAUITable2.Layout.Column = [7 15];
    
    % Create Select TFA Data Label
    app.DASelTFADataLabel = uilabel(app.DAGridLayout);
    app.DASelTFADataLabel.Layout.Row = 1;
    app.DASelTFADataLabel.Layout.Column = [1 5];
    app.DASelTFADataLabel.Text = 'Search TFA-File from TFA-3000';
    app.DASelTFADataLabel.Tooltip = "Enter absolute Path of the TFA-3000.";

    % Create SelectotherdataButton
    app.DASelLocalDataButton = uibutton(app.DAGridLayout, 'push');
    app.DASelLocalDataButton.Layout.Row = 3;
    app.DASelLocalDataButton.Layout.Column = [1 5];
    app.DASelLocalDataButton.Text = 'Select local .dat-File';

    % Create EditField
    app.DASelTFADataEditField = uieditfield(app.DAGridLayout, 'text');
    app.DASelTFADataEditField.Editable = 'off';
    app.DASelTFADataEditField.Enable = 'off';
    app.DASelTFADataEditField.Layout.Row = 2;
    app.DASelTFADataEditField.Layout.Column = [1 6];



    % Create DropDown
    app.DADropDown_x1= uidropdown(app.DAGridLayout);
    app.DADropDown_x1.Layout.Row = 14;
    app.DADropDown_x1.Layout.Column = [25 28];
    app.DADropDown_x1.Items = {'-'};

    % Create DropDown_2
    app.DADropDown_y1 = uidropdown(app.DAGridLayout);
    app.DADropDown_y1.Layout.Row = 15;
    app.DADropDown_y1.Layout.Column = [25 28];
    app.DADropDown_y1.Items = {'-'};

    % Create DropDown_3
    app.DADropDown_y2 = uidropdown(app.DAGridLayout);
    app.DADropDown_y2.Layout.Row = 15;
    app.DADropDown_y2.Layout.Column = [29 32];
    app.DADropDown_y2.Items = {'-'};

    % Create YAxisLabel
    app.DASelTFADataLabel = uilabel(app.DAGridLayout);
    app.DASelTFADataLabel.Layout.Row = 15;
    app.DASelTFADataLabel.Layout.Column = [23 24];
    app.DASelTFADataLabel.Text = 'Y-Axis';

    % Create XAxisLabel
    app.DAXAxisLabel = uilabel(app.DAGridLayout);
    app.DAXAxisLabel.Layout.Row = 14;
    app.DAXAxisLabel.Layout.Column = [23 24];
    app.DAXAxisLabel.Text = 'X-Axis';

    % Create y-Lim Label
    % Create XAxisLabel
    app.DAxLimLabel = uilabel(app.DAGridLayout);
    app.DAxLimLabel.Layout.Row = 16;
    app.DAxLimLabel.Layout.Column = [22 24];
    app.DAxLimLabel.Text = 'X-Limits';
    % Create Lim EditFields
    app.DAxLimEdFi = uieditfield(app.DAGridLayout);
    app.DAxLimEdFi.Layout.Row = 16;
    app.DAxLimEdFi.Layout.Column = [25 32];
    app.DAxLimEdFi.Value = "auto";


    % Create y-Lim Label
    % Create XAxisLabel
    app.DAyLimLabel = uilabel(app.DAGridLayout);
    app.DAyLimLabel.Layout.Row = 17;
    app.DAyLimLabel.Layout.Column = [22 24];
    app.DAyLimLabel.Text = 'Y-Limits 1&2';
    % Create Lim EditFields
    app.DAy1LimEdFi = uieditfield(app.DAGridLayout);
    app.DAy2LimEdFi = uieditfield(app.DAGridLayout);
    app.DAy1LimEdFi.Layout.Row = 17;
    app.DAy1LimEdFi.Layout.Column = [25 28];
    app.DAy2LimEdFi.Layout.Row = 17;
    app.DAy2LimEdFi.Layout.Column = [29 32];
    app.DAy1LimEdFi.Value = "auto";
    app.DAy2LimEdFi.Value = "auto";

    
    


    % Create HideMetaTableButton
    app.DASaveButton = uibutton(app.DAGridLayout, 'push');
    app.DASaveButton.Text = 'Save selected';
    app.DASaveButton.Layout.Row = 16;
    app.DASaveButton.Layout.Column = [1 3];

     % Create HideMetaTableButton
    app.DASaveAllButton = uibutton(app.DAGridLayout, 'push');
    app.DASaveAllButton.Text = 'Save all';
    app.DASaveAllButton.Layout.Row = 16;
    app.DASaveAllButton.Layout.Column = [4 6];

    % Create DAClearButton
    app.DAClearButton = uibutton(app.DAGridLayout, 'push');
    app.DAClearButton.Layout.Row = 17;
    app.DAClearButton.Layout.Column = [1 3];
    app.DAClearButton.Text = 'Clear selected';

    % Create DAClearButton
    app.DAClearAllButton = uibutton(app.DAGridLayout, 'push');
    app.DAClearAllButton.Layout.Row = 17;
    app.DAClearAllButton.Layout.Column = [4 6];
    app.DAClearAllButton.Text = 'Clear all';
    

    %Create FindPeakButton
    app.DAdeveBtn = uibutton(app.DAGridLayout, 'push');
    app.DAdeveBtn.Layout.Row = 1;
    app.DAdeveBtn.Layout.Column = [33 35];
    app.DAdeveBtn.Text = 'Developer Btn.';
    
    % Create DAextraTable
    app.DAextraTable = uitable(app.DAGridLayout);
    app.DAextraTable.ColumnName = {'x','y'};
    app.DAextraTable.RowName = {};
    app.DAextraTable.Layout.Row = [1 17];
    app.DAextraTable.Layout.Column = [36 40];

    app.DADropDown_x1.ValueChangedFcn = @(src,event) updateAxis(app,src,event);
    app.DADropDown_y1.ValueChangedFcn = @(src,event) updateAxis(app,src,event);
    app.DADropDown_y2.ValueChangedFcn = @(src,event) updateAxis(app,src,event);

    app.DASelLocalDataButton.ButtonPushedFcn = @(src,event) loadData(app,src,event);
    
    app.DASaveButton.ButtonPushedFcn = @(src,event) saveSelectedData(app,src,event);
    app.DASaveAllButton.ButtonPushedFcn = @(src,event) saveSelectedData(app,src,event);
    app.DAClearButton.ButtonPushedFcn = @(src,event) clearData(app,src,event);
    app.DAClearAllButton.ButtonPushedFcn = @(src,event) clearData(app,src,event);

    app.DAxLimEdFi.ValueChangedFcn = @(src,event) updatexLim(app,src,event);
    app.DAy1LimEdFi.ValueChangedFcn = @(src,event) updateyLim(app,src,event);
    app.DAy2LimEdFi.ValueChangedFcn = @(src,event) updateyLim(app,src,event);
    app.DAdeveBtn.ButtonPushedFcn = @(src,event) deveBtn(app,src,event);
    app.UIFigure.Visible = 'on';
    app.UIFigure.CurrentObject = app.IPv4AdressEditField;

    app.dataBuffer = cell(1,1000);

    app.UserNameEditField.ValueChangedFcn = @(src,event) updateUserName(app, src, event);
end
