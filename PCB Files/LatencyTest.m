close all;
clearvars -except timingList;

timingList = []
count18 = 11:0.05:14;
for k = count18
    cFreq = [582 9720 1249 2016 225]/(582+9720+1248+2016+225);

    cPDist = [0 cFreq(1)];
    for i = 2:5
        cPDist = [cPDist sum(cFreq(1:i))];
    end

    cDelay = [560 1016 2016 3016 4016]/1000;

        tP1 = rand();
        tP2 = rand();
        tP3 = rand();
        t1 = 0;
        t2 = 0;
        t3 = 0;

        for i = 2:6
            if tP1<cPDist(i)&&tP1>cPDist(i-1)
                t1=cDelay(i-1);
            end
            if tP2<cPDist(i)&&tP1>cPDist(i-1)
                t2=cDelay(i-1);
            end
            if tP3<cPDist(i)&&tP1>cPDist(i-1)
                t3=cDelay(i-1);
            end
        end

    pollInterval = k;
    tPol = pollInterval;

    t1Sense = 0;
    t2Sense = 0;
    t3Sense = 0;
    sensed = 0;

    baudRate = 1E6;
    byteDelay = 8/baudRate;
    switchDelay = 0.05;
    tPass = 0;
    t = byteDelay;
    times = [0];
    allSensed = [];

    for i = 0:0.01:500000
        if i>tPol
            times = [times t-tPol+pollInterval];
            t = tPol+byteDelay;
            tPol = tPol+pollInterval;

            allSensed = [allSensed sensed];
            sensed = 0;

            tPass = 1;
        end

        if i>t1
            if t1Sense < 6
                t1Sense = t1Sense+1;
            end

            if tPass == 1 && i > t
                tPass = 2;
                sensed = sensed + t1Sense;
                t1Sense = 0;
                t = t1+sensed*byteDelay;
            end

            P = rand();
            tNew = 0;
            for i = 1:5
                if P<cPDist(i)&&P>cPDist(i-1)
                    tNew=cDelay(i-1);
                end
            end
            t1 = t1 + tNew + switchDelay;
        end

        if i>t2
            if t2Sense < 6
                t2Sense = t2Sense+1;
            end

            if tPass == 2 && i > t
                tPass = 3;
                sensed = sensed + t2Sense;
                t2Sense = 0;
                t = t2+sensed*byteDelay;
            end

            P = rand();
            tNew = 0;
            for i = 1:5
                if P<cPDist(i)&&P>cPDist(i-1)
                    tNew=cDelay(i-1);
                end
            end
            t2 = t2 + tNew;
        end

        if i>t3
            if t3Sense < 6
                t3Sense = t3Sense+1;
            end

            if tPass == 3 && i > t
                tPass = 0;
                sensed = sensed + t3Sense;
                t3Sense = 0;
                t = t3+sensed*byteDelay;
            end

            P = rand();

            tNew = 0;
            for i = 2:6
                if P<cPDist(i)&&P>cPDist(i-1)
                    tNew=cDelay(i-1);
                end
            end
            t3 = t3 + tNew;
        end
    end
    timingList = [timingList nnz(allSensed==18)];
end
