measCount = tcpTFmeasCount(tcpTF);
data = cell(2,measCount);
for i=1:measCount
    write(tcpTF,sprintf("STRING:MEASUREM:SELEC pm,%d",i));
    tcpTFw84TF(tcpTF);
    write(tcpTF,"STRING:MEASUREM:data?");
    pause(1)
    [data{1,i},data{2,i}] = processData(read(tcpTF));
end