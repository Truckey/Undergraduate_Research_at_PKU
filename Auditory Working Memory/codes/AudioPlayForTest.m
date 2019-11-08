%% AudioPlayForTest.m - only for debugging (fewer trials)
%
% When you want to debug, change the filename to AudioPlay and change the
% original AudioPlay to some other name.
function[reaction , RT] = AudioPlay(isPractice , blocktype , trialtype  )

%New!������ʵ�ֹ��ܣ����һ��block�Ĳ��������������ر��Եķ�Ӧ��������ż��ɣ�
%ispractice  2: main practice; 1��practice; 0��main experiment
%blocktype  1��simple��2��reversed��3��transposition��4��contour
%trialtype  ��ʽʵ��ʱ��ʾ���� 1��same��2��different ����Ϊ54������
%reaction  ��¼�������������Ϊ54������
%RT  ��¼��Ӧʱ������Ϊ54������

% Modified by Hershey, 2019.9.29
% L63 & L71��newly defined PsychPortAudio('Start')
% L50, newly defined PsychPortAudio('Open')
% L111, not allow for escaping
% Trigger added
% every practice and block followed by a printed note

% Modified by Ruiqi Chen, 2019.9.29
%
% L4, L38, L48-49, L59, L67 (in this file); L34-36 moved; L32/39 for
% debugging; L117-125 modified

% Variables:
%
% Stilmuli: 4 (SIMPLE/REVERSED/TRANSPOSITION/CONTOUR) * 2 (SAME/DIFFERENT)
%   * 54 (NTRIAL) * 154350 (3.5 * SAMPRATE) double.
% PracticeStimuli: 4 * 2 * 27 * 154350 double, different from Stimuli
try

load('Material.mat') ;%������Ƶ�ļ�,���ر�Ǳ���


KbName('UnifyKeyNames');        %����׼��

SAMPRATE      = 48000;
PORTNUM = 53264;  % 53264 for the left room, 49408 for the right
reaction      = zeros(54, 1);
RT            = zeros(54, 1);
AudioInput    = zeros(2, 3.5 * SAMPRATE);

%%%%--------%%%%
numPractice   = 2;    %��ϰ������2��һ��same һ��different
%%%%--------%%%%
if isPractice == 2
    numPractice = numPractice * 3;
end

seqPractice   = randi(2 , 1, numPractice) ; %��ϰ���� 1��different��2��same
%%%%--------%%%%
numMain       = 4;    %��ʽʵ�������4��ÿ��block
%%%%--------%%%%
index         = 1;    %��ʽʵ���������������index

%% ��������
% �Ƚ�����ϰ���ٽ�����ʽʵ��

pahandle=PsychPortAudio('Open',[],[],3,SAMPRATE);% �������豸��Ĭ�ϲ����豸��Ĭ��ģʽ���ӳ�ģʽ3��Ĭ��˫����

if isPractice    %��ϰ������
    load('sti48000Pra.mat');
    PraCountDiff = mod(PraCountDiff - 1, 27) + 1;
    PraCountSame = mod(PraCountSame - 1, 27) + 1;  % from 1 to 27
    
    for itrial = 1 : numPractice
        WaitSecs(0.5 + rand(1) / 2);  % random ITI
        if seqPractice(itrial) == 1    %Different ����
            index = PracIndex(1,PraCountDiff);
            AudioInput(1 , :) = PracticeStimuli(blocktype , 2 ,index , :) ;
            AudioInput(2 , :) = AudioInput(1 , :) ;
            PsychPortAudio('FillBuffer',pahandle , AudioInput);
            PsychPortAudio('Start',pahandle,[],[],1); %�����豸�������ٿ�ʼ
            PraCountDiff = mod(PraCountDiff, 27) + 1;
            
        else                           %Same ����
            index =  PracIndex(2,PraCountSame) ;
            AudioInput(1 , :) = PracticeStimuli(blocktype , 1 , index , :) ;
            AudioInput(2 , :) = AudioInput(1 , :) ;
            PsychPortAudio('FillBuffer',pahandle,AudioInput);
            PsychPortAudio('Start',pahandle,[],[],1); %�����豸�������ٿ�ʼ
            PraCountSame = mod(PraCountSame, 27) + 1;
        end
        
        %�ռ�����, ��ʱ2s������¼����������˳�
        RTBegin = WaitSecs(2 + 6 * 0.25);
        RTTimeOut = RTBegin + 2;
        
        [secs, keyCode, ~] = KbWait([], 0, RTTimeOut);
        if find(keyCode) == KbName('ESCAPE')
            sca; PsychPortAudio('Close');
            return;
        end
        
        WaitSecs('UntilTime', RTTimeOut);
        
       
    end
     sprintf('Practice finished')
    
    
else    %��ʽʵ��
    load(['sti48000Block' num2str(blocktype) '.mat']);
    for itrial = 1 : numMain
        lptwrite(PORTNUM, 0);
        WaitSecs(0.5 + rand(1) / 2);  % random ITI
        
        if trialtype(itrial) == 1     %Different ����
            index = MainIndex(1,countDiff(blocktype, 1)); 
            AudioInput(1 , :) = Stimuli(1 , 2 , index, : ) ;
            AudioInput(2 , :) = AudioInput(1 , :) ;
            PsychPortAudio('FillBuffer',pahandle,AudioInput);
            PsychPortAudio('Start',pahandle);
            %-------trigger------%
            lptwrite(PORTNUM, 1 + blocktype*10);
            % 49408 for the right room, 53264 for the left
            %--------------------%
            countDiff(blocktype, 1) = countDiff(blocktype, 1) + 1;
        else                           %Same ����
            index = MainIndex(2,countSame(blocktype, 1));
            AudioInput(1 , :) = Stimuli(1 , 1 , index , : ) ;
            AudioInput(2 , :) = AudioInput(1 , :) ;
            PsychPortAudio('FillBuffer',pahandle,AudioInput);
            PsychPortAudio('Start',pahandle);
            %-------trigger------%
            lptwrite(PORTNUM, 2 + blocktype*10);      %trigger
            %--------------------%
            countSame(blocktype, 1) = countSame(blocktype, 1) + 1;
        end
        
        %�ռ�����, ��ʱ2s����¼����������˳�
        RTBegin = WaitSecs(2 + 6 * 0.25);
        RTTimeOut = RTBegin + 2;
        
        [secs, keyCode, ~] = KbWait([], 0, RTTimeOut);
        
        if secs < RTTimeOut
            RT(itrial) = secs - RTBegin;
            if find(keyCode) == KbName('J')
                reaction(itrial) = 2;
            end
            if find(keyCode) == KbName('K')
                reaction(itrial) = 1;
            end
        end        
        
        WaitSecs('UntilTime', RTTimeOut);
        
    end
    sprintf('Blocktype %d finished', blocktype)
end
PsychPortAudio('Close',pahandle);

save Material.mat  PraCountDiff PraCountSame countSame countDiff PracIndex MainIndex


catch
    Screen('CloseAll')
    rethrow(lasterror)
    
    
end



