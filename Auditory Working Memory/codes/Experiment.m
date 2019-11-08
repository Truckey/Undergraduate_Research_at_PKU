%    Modified by Hershey, 2019.11.2
%    L66 for forward setup
% 
%    Modified by Hershey, 2019.11.1
%    L308-326 : calculate the hitrate of each block and print it out
%   
% 
%
%   Modified by Hershey, 2019.10.1
%  L96-97 turn countSame&countDiff to vectors
%
%   Modified by Hershey, 2019.9.29
%  L38-39: alternative background color and text size
%  L28, L161-L207: Added an alternative for a Chinese version of introduction
%  L78: enlarge available number of subjects 
%  L272-276: rest for any length 
%  L299: save 'Subinfo'
%  notes for the beginning of the main trials and the end of each break
%    
%   Modified  by Ruiqi Chen, 2019.9.29
% 
% L154: countblock is defined as a scalar
% L152: IMPORTANT! (" - 1")
% L208: allow subjects to take a rest after every block; L218/225 added;
% L238: save data; L209/L214: string format
%
%	Conditions
%
% SIMPLE: simple comparison
% REVERSED: requiring subjects to mentally reverse S1 during retention,
%   then compare it with S2
% TRANSPOSITION: requiring subjects to mentally raise S1 for an octave
%   during retention, then compare it with S2
% CONTOUR: requiring subjects to mentally change the movement S1 into
%   categories ("up-up" / "up-down" / "down-up" / "down-down") during retention,
%   and that of S2 during reaction, then compare them


%parameters preparation
%--------------Language--------------%
isEnglish         = 0;  %1: English verion of introduction; 0: Chinese one
WINID = 2;  % 2 for the left and 1 for the right

%--------------color--------------%
BLACK             = [0 0 0];
WHITE             = [255 255 255];
GREY              = [128 128 128];
bgcolor           = GREY;
textsize          = 40;
%--------------blocks--------------%
NBLOCKS               = 8;                   % number of blocks
NTRIALS           = 54;                  % number of trials in a block
latincondition    = [1 3 2 4 2 1 4 3 1 3 2 4 2 1 4 3];    % latin square

%--------------sound--------------%
SAMPRATE          = 48000;               % you may need to change it to suit your audio device

%--------------response--------------%

TrialType         = zeros(NBLOCKS , NTRIALS);  % 1: different; 2: same
ResponseType      = TrialType;  % 0: no response; 1: different; 2: same
RT                = ResponseType;
hitrate           = zeros(4 , NTRIALS * 2);
% ramplen = [fix(samplerate * fade_duration), fix(samplerate * fade_duration)];
% outsig = rampsignal(a,ramplen);                        %����rampsignal�������뵭��
isRepBlock = zeros(4,1);


%%
%��Ϣ¼��
promptParameters = {'Subject Name','number'};
defaultParameters = {'sub99','99'}; %ȱʡֵ
Subinfo = inputdlg(promptParameters, 'Subject Info  ', 1, defaultParameters);

%%
try
    %���ڳ�ʼ��
    HideCursor;%�������
    InitializePsychSound; %��ʼ��PsychSound
    KbName('UnifyKeyNames');%����׼��
    Screen('Preference', 'SkipSyncTests',1);%����Ӳ�����
    [w,dect]=Screen('OpenWindow',WINID,bgcolor);%��һ�����ڣ���ɫ��ȫ�������ؾ��w�ʹ�������rec
    cx=dect(3)/2;%������ĵ������
    cy=dect(4)/2;%������ĵ�������
    ListenChar(2);
    %flipint=Screen('GetFlipInterval',w);%��ȡˢ��Ƶ��
    %pix = deg2pix(1,monitorsize,rec(3),subjdistance); %�ӽ�תpix
    keyend            = KbName('ESCAPE');
    keyspace          = KbName('SPACE');
    keyj              = KbName('J');
    keyk              = KbName('K');
    
    
    %-----------------------�Դ����-----------------------%
    iblock            = mod(str2num(Subinfo{2})-1 , 8)+1;  %�������ĳ�ʼλ��
    TrialType         = randtrial();  % 1: same; 0: different
    countblock        = 1; %��¼block��Ŀ��������Ϣ�Լ����ʹ�ù�������
    
    %-------��Ҫ-------%
    %ÿ��������ʵ�鿪ʼǰ�����������ļ����������
    %������ʽʵ���õ��������зֳ���������֤û���ظ�
    
    countDiff = ones(4,1); %��Ǳ�����ʼ��
    countSame = ones(4,1);
    PraCountDiff = 1;
    PraCountSame = 1;
    PracIndex = [randperm(27) ; randperm(27)];
    MainIndex = [randperm(54) ; randperm(54)];
    save Material.mat PraCountDiff PraCountSame countSame countDiff PracIndex MainIndex
    
    %-----------------%
    
    %%
    %----------------------����ָ����----------------------%
    
    % Window
    %-----Attention for TextSize-----%
    % Screen('TextSize', w, textsize);
    % Screen('TextFont', w, 'Microsoft YaHei');
    Screen('TextColor', w, WHITE);
    HideCursor(w);
    
    % Welcome
    DrawFormattedText(w, 'Welcome', 'Center', 'Center');
    Screen('Flip', w);
    WaitSecs(2);
    
    %Introduction
    PROMPTS = cell(1, 6);
    if isEnglish
    PROMPTS{1, 1} = ['Simple Task\n    In every trial, you will hear a sequence ', ...
        'of three musical tones. Please keep it in your mind for 2 seconds. ', ...
        'Then you will hear another sequence and you need to compare it with ', ...
        'the one in your mind, and press J if they are the same, K ', ...
        'if different. You are allowed 2 seconds for reaction after ', ...
        'the offset of the second sequence. Then the next trial will begin ', ...
        'soon. During the whole trial, please fix at the cross at the center ', ...
        'of the screen, and try to avoid blinking or head movement.\n    Now ', ...
        'press space to continue, esc to quit.'];
    PROMPTS{1, 2} = ['Reversed Task\n    In every trial, you will hear a sequence ', ...
        'of three musical tones. Please reverse it in your mind in 2 seconds. ', ...
        'Then you will hear another sequence and you need to compare it with ', ...
        'the (reversed) one in your mind, and press J if they are the same, K ', ...
        'if different. You are allowed 2 seconds for reaction after ', ...
        'the offset of the second sequence. Then the next trial will begin ', ...
        'soon. During the whole trial, please fix at the cross at the center ', ...
        'of the screen, and try to avoid blinking or head movement.\n    Now ', ...
        'press space to continue, esc to quit.'];
    PROMPTS{1, 3} = ['Transposition Task\n    In every trial, you will hear a sequence ', ...
        'of three musical tones. Please raise the pitch for an octave in your mind in 2 seconds. ', ...
        'Then you will hear another sequence and you need to compare it with ', ...
        'the (raised) one in your mind, and press J if they are the same, K ', ...
        'if different. You are allowed 2 seconds for reaction after ', ...
        'the offset of the second sequence. Then the next trial will begin ', ...
        'soon. During the whole trial, please fix at the cross at the center ', ...
        'of the screen, and try to avoid blinking or head movement.\n    Now ', ...
        'press space to continue, esc to quit.'];
    PROMPTS{1, 4} = ['Contour Task\n    In every trial, you will hear a sequence ', ...
        'of three musical tones. Please mentally transform it in to categories ',...
        'up-up or up-down or down-up or down-down in 2 seconds, according to ', ...
        'the relative height of the tones. Then you will hear another sequence ', ...
        'and you should transform it likewise, then compare two result ', ...
        'and press J if they are the same, K ', ...
        'if different. You are allowed 2 seconds for reaction after ', ...
        'the offset of the second sequence. Then the next trial will begin ', ...
        'soon. During the whole trial, please fix at the cross at the center ', ...
        'of the screen, and try to avoid blinking or head movement.\n    Now ', ...
        'press space to continue, esc to quit.'];
    PROMPTS{1, 5} = ['first take a practice'];
    PROMPTS{1, 6} = ['ready for the main tasks?',...
        'if you got ready, press space for a start, or esc to quit', ];
    
    else 
        
        PROMPTS{1, 1, 1} = '������    ÿһ���Դ��У����������3��������ɵ����� ';
        PROMPTS{1, 1, 2} = '�뽫�����������У�����2s ';
        PROMPTS{1, 1, 3} = 'Ȼ�����������һ��������������������֮ǰ������������бȽ� ';
        PROMPTS{1, 1, 4} = '�����ͬ���밴��"J"���������밴��"K"�� ';
        PROMPTS{1, 1, 5} = '���������������2s��ʱ����а�����Ӧ ';
        PROMPTS{1, 1, 6} = 'Ȼ����һ���Դν��ܿ쿪ʼ ';
        PROMPTS{1, 1, 7} = '�������Դ��У������۾�������Ļ�ϵ�ע�ӵ� ';
        PROMPTS{1, 1, 8} = '����������գ�ۻ���ͷ��.����֮�����գ��     ';
        PROMPTS{1, 1, 9} = '���׼�����ˣ��밴�¿ո���������Ҫ�˳����밴��esc��';
    
        PROMPTS{1, 2, 1} = '��������     ÿһ���Դ��У����������3��������ɵ����� ';
        PROMPTS{1, 2, 2} = '�뽫�����������У�����2s֮�ڽ��䵹��ת�� ';
        PROMPTS{1, 2, 3} = 'Ȼ�����������һ�����������������ԭ�����������򲥷�';
        PROMPTS{1, 2, 4} = '����������������ת�������������бȽ� ';
        PROMPTS{1, 2, 5} = '�����ͬ���밴��"J"���������밴��"K"�� ';
        PROMPTS{1, 2, 6} = '���������������2s��ʱ����а�����Ӧ ''Ȼ����һ���Դν��ܿ쿪ʼ ';
        PROMPTS{1, 2, 7} = '�������Դ��У������۾�������Ļ�ϵ�ע�ӵ� ';
        PROMPTS{1, 2, 8} = '����������գ�ۻ���ͷ��.����֮�����գ��';
        PROMPTS{1, 2, 9} = '���׼�����ˣ��밴�¿ո���������Ҫ�˳����밴��esc��';
    
        PROMPTS{1, 3, 1} = '��������    ÿһ���Դ��У����������3��������ɵ����� ';
        PROMPTS{1, 3, 2} = '�뽫�����������У�����2s֮�ڽ�����������������һ���˶� ';
        PROMPTS{1, 3, 3} = 'Ȼ�����������һ������������������������� ';
        PROMPTS{1, 3, 4} = '����������������ת�������������бȽ� ';
        PROMPTS{1, 3, 5} = '�����ͬ���밴��"J"���������밴��"K"�� ';
        PROMPTS{1, 3, 6} = '���������������2s��ʱ����а�����Ӧ, Ȼ����һ���Դν��ܿ쿪ʼ ';
        PROMPTS{1, 3, 7} = '�������Դ��У������۾�������Ļ�ϵ�ע�ӵ�  ';
        PROMPTS{1, 3, 8} = '����������գ�ۻ���ͷ��.����֮�����գ��     ';
        PROMPTS{1, 3, 9} = '���׼�����ˣ��밴�¿ո���������Ҫ�˳����밴��esc��';

    
        PROMPTS{1, 4, 1} = '��������    ÿһ���Դ��У����������3��������ɵ����� ';
        PROMPTS{1, 4, 2} = '�뽫�����������У���������������������ߣ�2s�������н���ת���������ĸ������е�һ���� ';
        PROMPTS{1, 4, 3} = '��������"����-����" �� "����-����" �� "����-����" �� "����-����"   ';
        PROMPTS{1, 4, 4} = 'Ȼ�����������һ������������Ҫ����ͬ����ת��';
        PROMPTS{1, 4, 5} = '���ǰ������������������ͬ���밴��"J"���������밴��"K"�� ';
        PROMPTS{1, 4, 6} = '���������������2s��ʱ����а�����Ӧ, Ȼ����һ���Դν��ܿ쿪ʼ';
        PROMPTS{1, 4, 7} = '�������Դ��У������۾�������Ļ�ϵ�ע�ӵ� ';
        PROMPTS{1, 4, 8} = '����������գ�ۻ���ͷ��������֮�����գ��';
        PROMPTS{1, 4, 9} = '���׼�����ˣ��밴�¿ո���������Ҫ�˳����밴��esc��.';

    
    PROMPTS{1, 5} = '��ϰ�׶�';
    
    PROMPTS{1, 6} = '����������ʽʵ��. ׼���ú��밴�¿ո����ʼ';
    
        
    end
    
    %%
    %----------------------��ʽʵ��----------------------%
    for iblock = iblock : iblock + NBLOCKS - 1
        condition = latincondition(iblock) ; %����������
      
        
        %ָ����
        if isEnglish
        DrawFormattedText(w, PROMPTS{1, condition}, fix(dect(3) / 8), fix(dect(4) / 8),...
            [], 70, [], [], 1.5);
        
        else
          drawTextAt(w,double(PROMPTS{1, condition, 1}), cx,cy-120 ,[255 255 255]);
          drawTextAt(w,double(PROMPTS{1, condition, 2}), cx,cy-90 ,[255 255 255]);
          drawTextAt(w,double(PROMPTS{1, condition, 3}), cx,cy-60 ,[255 255 255]);
          drawTextAt(w,double(PROMPTS{1, condition, 4}), cx,cy-30 ,[255 255 255]);
          drawTextAt(w,double(PROMPTS{1, condition, 5}), cx,cy    ,[255 255 255]);
          drawTextAt(w,double(PROMPTS{1, condition, 6}), cx,cy+30 ,[255 255 255]);
          drawTextAt(w,double(PROMPTS{1, condition, 7}), cx,cy+60 ,[255 255 255]);  
          drawTextAt(w,double(PROMPTS{1, condition, 8}), cx,cy+90 ,[255 255 255]);
          drawTextAt(w,double(PROMPTS{1, condition, 9}), cx,cy+120 ,[255 255 255]);
        end
        
        Screen('Flip', w);
        
        %�ռ�����
        [~, ~,keyCode] = KbCheck;
        while ~(keyCode(keyend) || keyCode(keyspace))
            [~, ~,keyCode] = KbCheck;
        end
        if keyCode(keyend)
            sca; PsychPortAudio('Close');
            return;
        end
        
        
        %--------------------��ϰ------------------%
        %ָ�������2s
        if isEnglish
        DrawFormattedText(w, PROMPTS{1, 5}, fix(dect(3) / 8), fix(dect(4) / 8),...
            [], 70, [], [], 1.5);
        
        else
            
        drawTextAt(w,double(PROMPTS{1, 5}),cx,cy ,[255 255 255]); 
        end
        
        t = Screen('Flip', w);
        Screen('Flip', w,t+2);
        
        %����ע�ӵ㣬ʵ�鿪ʼ
        DrawFormattedText(w, '+', 'Center', 'Center', WHITE);
        Screen('Flip', w);
        
        AudioPlay(1 , condition);
        
        %--------------------��ʽ------------------%
        %ָ����
        Screen('FillRect', w , bgcolor);
        Screen('Flip', w);
        
        if isEnglish
        DrawFormattedText(w, PROMPTS{1, 6}, fix(dect(3) / 8), fix(dect(4) / 8),...
            [], 70, [], [], 1.5);
        else
        drawTextAt(w,double(PROMPTS{1, 6}),cx,cy ,[255 255 255]); 
        end
        
        Screen('Flip', w);
        
        %�ռ�����
        [~, ~,keyCode] = KbCheck;
        while ~(keyCode(keyend) || keyCode(keyspace))
            [~, ~, keyCode] = KbCheck;
        end
        if keyCode(keyend)
            sca; PsychPortAudio('Close');
            return;
        end
        
        sprintf('After practice, the Block %d begins', countblock)
        
        %����ע�ӵ㣬ʵ�鿪ʼ
        DrawFormattedText(w, '+', 'Center', 'Center', WHITE);
        Screen('Flip', w);
        
        
        %�����������ռ�����
        [ResponseType(countblock , :) , RT(countblock , :)] = AudioPlay(0 , condition , TrialType(countblock , :));
        %
        
        %---------------------�������-------------------%
                
        sprintf('hitrate of this block')
        
        if ~isRepBlock(condition , 1) %�����������ǵ�һ�γ���
            hitrate(condition , 1:54) = ~(ResponseType(countblock , :) - TrialType(countblock , :));
        
            
            %��ӡ������
            sum(hitrate(condition , 1 : 54 ) )./ 54
            
        else
            hitrate(condition , 55:108) = ~(ResponseType(countblock , :) - TrialType(countblock , :));
            
            %��ӡ������
            sum(hitrate(condition , 55 : 108)) ./ 54
            
        end
            isRepBlock(condition , 1) = isRepBlock(condition , 1) + 1; 
            
        
        %---------------------��Ϣ-------------------%
        if countblock ~= 8 
            if isEnglish
            DrawFormattedText(w, 'take a rest for 2-3 min, press space to continue', fix(dect(3) / 8), fix(dect(4) / 8),...
                [], 70, [], [], 1.5);
            else
            drawTextAt(w,double('��Ϣ2-3min�������Ҫ�������밴�¿ո��'),cx,cy ,[255 255 255]);
              
            end
            t = Screen('Flip', w);
            %�ռ�����
            [~, ~,keyCode] = KbCheck;
            while ~(keyCode(keyend) || keyCode(keyspace))
                [~, ~,keyCode] = KbCheck;
            end
            if keyCode(keyend)
                sca; PsychPortAudio('Close');
                return;
            end
            Screen('Flip', w); WaitSecs(0.5);
        end
        
        sprintf('Continue')
   
        countblock = countblock + 1 ;
        
    end
    
    
    %%
    %�������
    drawTextAt(w,double('ʵ�����'),cx,cy ,[255 255 255]);
    WaitSecs(2);
    Screen('CloseAll')
    ListenChar(0);
    
    %��ӡ����ʵ��Ļ�����
    sum(hitrate, 2) ./ 108
    
    %���汻����Ϣ�������������Ӧ&��Ӧʱ
    save(sprintf('%s.mat', Subinfo{1}), 'Subinfo' , 'TrialType', 'ResponseType', 'RT', 'hitrate'); 
    save(sprintf('Material%s.mat', Subinfo{1}),'PracIndex', 'MainIndex', 'latincondition');
    
catch
    Screen('CloseAll')
    rethrow(lasterror)

    
end
%%

