function updatePMMode(app,src,~)   
    if src == app.PMMode
        if src.Value == "PUND"
            app.PMSeqButton1.UserData = -1;
            app.PMSeqButton2.UserData = 1;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = -1;
            app.PMSeqButton5.UserData = -1;
            app.PMSeqButton6.UserData = 1;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "SS/NS"
            app.PMSeqButton1.UserData = 0;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = 1;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "SS/S"
            app.PMSeqButton1.UserData = -1;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = 1;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "OS/NS"
            app.PMSeqButton1.UserData = 1;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = -1;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "OS/S"
            app.PMSeqButton1.UserData = 0;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 1;
            app.PMSeqButton4.UserData = -1;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "W"
            app.PMSeqButton1.UserData = 1;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 0;
            app.PMSeqButton4.UserData = 0;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        elseif src.Value == "Manual"
            app.PMSeqButton1.UserData = 0;
            app.PMSeqButton2.UserData = 0;
            app.PMSeqButton3.UserData = 0;
            app.PMSeqButton4.UserData = 0;
            app.PMSeqButton5.UserData = 0;
            app.PMSeqButton6.UserData = 0;
            app.PMSeqButton7.UserData = 0;
        end 
    end
    updatePMSeq(app,src,[])
end