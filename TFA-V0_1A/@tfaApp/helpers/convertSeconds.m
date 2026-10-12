function [ValueFixedUnit,EditFieldValue,LabelText] = convertSeconds(EditFieldValue,LabelText)
%CONVERTSECONDS Summary of this function goes here
%   Detailed explanation goes here
    arguments
        EditFieldValue 
        LabelText 
    end
    if (LabelText == "s") 
        ValueFixedUnit = EditFieldValue;
        if ge(EditFieldValue,1)
            LabelText = "s";
        elseif ge(EditFieldValue,1e-3)
           LabelText = "ms";
           EditFieldValue = EditFieldValue*1e3;
        elseif ge(EditFieldValue,1e-6)
            LabelText = "µs";
            EditFieldValue = EditFieldValue*1e6;
        else
            LabelText = "ns";
            EditFieldValue = EditFieldValue*1e9;
        end
        
    elseif (LabelText =="ms")
        ValueFixedUnit = EditFieldValue/1e3;
        if ge(EditFieldValue,1e3)
            LabelText = "s";
            EditFieldValue = EditFieldValue/1e3;
        elseif ge(EditFieldValue,1)
           LabelText = "ms";
           EditFieldValue = EditFieldValue;
        elseif ge(EditFieldValue,1e-3)
            LabelText = "µs";
            EditFieldValue = EditFieldValue*1e3;
        else
            LabelText = "ns";
            EditFieldValue = EditFieldValue*1e6;
        end

    elseif (LabelText=="µs")
        ValueFixedUnit = EditFieldValue/1e6;
        if ge(EditFieldValue,1e6)
            LabelText = "s";
            EditFieldValue = EditFieldValue/1e6;
        elseif ge(EditFieldValue,1e3)
           LabelText = "ms";
           EditFieldValue = EditFieldValue/1e3;
        elseif ge(EditFieldValue,1)
            LabelText = "µs";
            EditFieldValue = EditFieldValue;
        else
            LabelText = "ns";
            EditFieldValue = EditFieldValue*1e3;
        end
    elseif (LabelText=="ns")
        ValueFixedUnit = EditFieldValue/1e9;
        if ge(EditFieldValue,1e9)
            LabelText = "s";
            EditFieldValue = EditFieldValue/1e9;
        elseif ge(EditFieldValue,1e6)
           LabelText = "ms";
           EditFieldValue = EditFieldValue/1e6;
        elseif ge(EditFieldValue,1e3)
            LabelText = "µs";
            EditFieldValue = EditFieldValue/1e3;
        else
            LabelText = "ns";
            EditFieldValue = EditFieldValue;
        end
    end
end