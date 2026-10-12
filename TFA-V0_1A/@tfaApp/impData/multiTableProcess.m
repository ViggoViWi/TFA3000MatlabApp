function [ResultTableString,SoftwareMeta,DataString] = multiTableProcess(txt)
    txt = strrep(txt, sprintf('\r\n'), sprintf('\n')); % normalize CRLF to LF
    parts = regexp(txt, '\n\s*\n', 'split');         % split on one-or-more blank lines
    % parts is a cell array of text blocks (strings). Trim if needed:
    parts = strtrim(parts);

    ResultTableString = parts(2);
    SoftwareMeta = parts(3);
    DataString = parts(4:end);
end
