function [asciiData,uint8Data] = tcpTFReadAndProcess(tcpTF)
    count = 0;
    err_count = 0;
    max_tries = 3;
    while count == err_count && err_count < max_tries
        try
        tcpTFw84TF(tcpTF);
        [asciiData,uint8Data,~]=tcpTFgetASCIIdata(tcpTF);
        catch mess
            if contains(mess.message,"Could not find data header starting with 'Measurement Status'")||contains(mess.message,"Numeric block size")
                err_count = err_count+1;
            end
            warning(sprintf("Try %d: %s",count+1,mess.message));
        end
        count = count +1;
        pause(0.5)
    end
    if err_count == max_tries
        warning("Max tries to retrieve data exceeded");
    end
end

