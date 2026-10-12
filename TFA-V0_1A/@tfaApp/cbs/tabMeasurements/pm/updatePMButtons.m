function updatePMButtons(app,src,~)
    if src==app.PMSeqButton1
        if src.UserData == 0
            src.UserData = 1;
        elseif src.UserData == 1
            src.UserData = -1;
        elseif src.UserData == -1
            src.UserData = 0;
        end
    elseif src==app.PMSeqButton2
        if src.UserData == 0
            src.UserData = 1;
        elseif src.UserData == 1
            src.UserData = -1;
        elseif src.UserData == -1
            src.UserData = 0;
        end
    elseif src==app.PMSeqButton3
        if src.UserData == 0
            src.UserData = 1;
        elseif src.UserData == 1
            src.UserData = -1;
        elseif src.UserData == -1
            src.UserData = 0;
        end
    elseif src==app.PMSeqButton4
        if src.UserData == 0
            src.UserData = 1;
        elseif src.UserData == 1
            src.UserData = -1;
        elseif src.UserData == -1
            src.UserData = 0;
        end
    elseif src==app.PMSeqButton5
        if src.UserData == 0
            src.UserData = 1;
        elseif src.UserData == 1
            src.UserData = -1;
        elseif src.UserData == -1
            src.UserData = 0;
        end
    elseif src==app.PMSeqButton6
        if src.UserData == 0
            src.UserData = 1;
        elseif src.UserData == 1
            src.UserData = -1;
        elseif src.UserData == -1
            src.UserData = 0;
        end
    elseif src==app.PMSeqButton7
        if src.UserData == 0
            src.UserData = 1;
        elseif src.UserData == 1
            src.UserData = -1;
        elseif src.UserData == -1
            src.UserData = 0;
        end
    end
    updatePMSeq(app,[],[]);

end