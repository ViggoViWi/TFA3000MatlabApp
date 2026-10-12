function updateATMcbs(app,src,~)
    % The callback comes from any of the  dropdown
    if src==app.ATMEcShiftDropDown
        if src.Value =="N-polarity"
            app.ATMSeqImage1.ImageSource = fullfile(app.currPWD, 'images',  'posBlueTri.png');
            app.ATMSeqImage2.ImageSource = fullfile(app.currPWD, 'images',  'disRed.png');
            app.ATMSeqImage3.ImageSource = fullfile(app.currPWD, 'images',  'negRedTri.png');
            app.ATMSeqImage4.ImageSource = fullfile(app.currPWD, 'images',  'negRedTri.png');
            app.ATMSeqImage5.ImageSource = fullfile(app.currPWD, 'images',  'disRed.png');
            app.ATMSeqImage6.ImageSource = fullfile(app.currPWD, 'images',  'disRed.png');
            app.ATMSeqImage7.ImageSource = fullfile(app.currPWD, 'images',  'disBlue.png');
        elseif src.Value=="M-polarity"
            app.ATMSeqImage1.ImageSource = fullfile(app.currPWD, 'images',  'negBlueTri.png');
            app.ATMSeqImage2.ImageSource = fullfile(app.currPWD, 'images',  'disRed.png');
            app.ATMSeqImage3.ImageSource = fullfile(app.currPWD, 'images',  'posRedTri.png');
            app.ATMSeqImage4.ImageSource = fullfile(app.currPWD, 'images',  'posRedTri.png');
            app.ATMSeqImage5.ImageSource = fullfile(app.currPWD, 'images',  'disRed.png');
            app.ATMSeqImage6.ImageSource = fullfile(app.currPWD, 'images',  'disRed.png');
            app.ATMSeqImage7.ImageSource = fullfile(app.currPWD, 'images',  'disBlue.png');
    end
end