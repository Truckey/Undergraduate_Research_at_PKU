%�˽ű�ʵ�ּ�����ϰ
%����Ϊ30��
%   Modified by Ruiqi Chen, 2019.9.29
%
% L133;

%parameters preparation

isEnglish         = 0;  %1: English verion of introduction; 0: Chinese one
WINID = 2;

%--------------color--------------%
BLACK             = [0 0 0];
WHITE             = [255 255 255];
GREY              = [128 128 128];
bgcolor           = GREY;
%--------------sound--------------%
SAMPRATE          = 48000;               % you may need to change it to suit your audio device

%%
try
    %���ڳ�ʼ��
    HideCursor;%�������
    InitializePsychSound; %��ʼ��PsychSound
    KbName('UnifyKeyNames');%����׼��
    Screen('Preference', 'SkipSyncTests',1);%����Ӳ�����
    [w,dect]=Screen('OpenWindow',WINID,bgcolor);%��һ�����ڣ�ȫ�������ؾ��w�ʹ�������rec
    cx=dect(3)/2;%������ĵ������
    cy=dect(4)/2;%������ĵ�������
    %ListenChar(2);
    %flipint=Screen('GetFlipInterval',w);%��ȡˢ��Ƶ��
    %pix = deg2pix(1,monitorsize,rec(3),subjdistance); %�ӽ�תpix
    keyend            = KbName('ESCAPE');
    keyspace          = KbName('SPACE');
    keyj              = KbName('J');
    keyk              = KbName('K');  

    %-------��Ҫ-------%
    %ÿ��������ʵ�鿪ʼǰ�����������ļ����������
    %������ʽʵ  ���õ��������зֳ���������֤û���ظ�

    countDiff = 1; %��Ǳ�����ʼ��
    countSame = 1;
    PraCountDiff = 1;
    PraCountSame = 1;
    PracIndex = [randperm(27) ; randperm(27)];
    MainIndex = [randperm(54) ; randperm(54)];
    save Material.mat PraCountDiff PraCountSame countSame countDiff PracIndex MainIndex
       
    %-----------------%
    
    %%
    %----------------------����ָ����----------------------%

% Window
% Screen('TextSize', w, 40);
% Screen('TextFont', w, 'Microsoft YaHei');
Screen('TextColor', w, WHITE);
HideCursor(w);

% Welcome
DrawFormattedText(w, 'Welcome for a practice', 'Center', 'Center');
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
        PROMPTS{1, 1, 9} = '���׼�����ˣ��밴�¿ո�������������,��������ʾ��';
    
        PROMPTS{1, 2, 1} = '��������     ÿһ���Դ��У����������3��������ɵ����� ';
        PROMPTS{1, 2, 2} = '�뽫�����������У�����2s֮�ڽ��䵹��ת�� ';
        PROMPTS{1, 2, 3} = 'Ȼ�����������һ��������';
        PROMPTS{1, 2, 4} = '����������������ת�������������бȽ� ';
        PROMPTS{1, 2, 5} = '�����ͬ���밴��"J"���������밴��"K"�� ';
        PROMPTS{1, 2, 6} = '���������������2s��ʱ����а�����Ӧ ''Ȼ����һ���Դν��ܿ쿪ʼ ';
        PROMPTS{1, 2, 7} = '�������Դ��У������۾�������Ļ�ϵ�ע�ӵ� ';
        PROMPTS{1, 2, 8} = '����������գ�ۻ���ͷ��.����֮�����գ��';
        PROMPTS{1, 2, 9} = '���׼�����ˣ��밴�¿ո�������������,��������ʾ��';
    
        PROMPTS{1, 3, 1} = '��������    ÿһ���Դ��У����������3��������ɵ����� ';
        PROMPTS{1, 3, 2} = '�뽫�����������У�����2s֮�ڽ�����������������һ���˶� ';
        PROMPTS{1, 3, 3} = 'Ȼ�����������һ��������';
        PROMPTS{1, 3, 4} = '����������������ת�������������бȽ� ';
        PROMPTS{1, 3, 5} = '�����ͬ���밴��"J"���������밴��"K"�� ';
        PROMPTS{1, 3, 6} = '���������������2s��ʱ����а�����Ӧ, Ȼ����һ���Դν��ܿ쿪ʼ ';
        PROMPTS{1, 3, 7} = '�������Դ��У������۾�������Ļ�ϵ�ע�ӵ�  ';
        PROMPTS{1, 3, 8} = '����������գ�ۻ���ͷ��.����֮�����գ��     ';
        PROMPTS{1, 3, 9} = '���׼�����ˣ��밴�¿ո�������������,��������ʾ��';

    
        PROMPTS{1, 4, 1} = '��������    ÿһ���Դ��У����������3��������ɵ����� ';
        PROMPTS{1, 4, 2} = '�뽫�����������У���������������������ߣ�2s�������н���ת���������ĸ������е�һ���� ';
        PROMPTS{1, 4, 3} = '��������"����-����" �� "����-����" �� "����-����" �� "����-����"   ';
        PROMPTS{1, 4, 4} = 'Ȼ�����������һ������������Ҫ����ͬ����ת��';
        PROMPTS{1, 4, 5} = '���ǰ������������������ͬ���밴��"J"���������밴��"K"�� ';
        PROMPTS{1, 4, 6} = '���������������2s��ʱ����а�����Ӧ, Ȼ����һ���Դν��ܿ쿪ʼ';
        PROMPTS{1, 4, 7} = '�������Դ��У������۾�������Ļ�ϵ�ע�ӵ� ';
        PROMPTS{1, 4, 8} = '����������գ�ۻ���ͷ��������֮�����գ��';
        PROMPTS{1, 4, 9} = '���׼�����ˣ��밴�¿ո�������������,��������ʾ��.';

    
    PROMPTS{1, 5} = '��ϰ�׶�';
    
    PROMPTS{1, 6} = '����������ʽʵ��. ׼���ú��밴�¿ո����ʼ';
    
        
    end
    %%
    %----------------------��ʽʵ��----------------------%
    
    for condition = 1 : 4
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
        while ~(keyCode(keyspace))
            [~, ~,keyCode] = KbCheck;
        end
        if keyCode(keyend)
            sca; PsychPortAudio('Close');
        end
        
        
        %����ע�ӵ㣬��ϰ��ʼ
        DrawFormattedText(w, '+', 'Center', 'Center', WHITE);
        Screen('Flip', w);
        
        AudioPlay(2 , condition);

       
    end
    
    WaitSecs(2);
    ListenChar(0); sca; PsychPortAudio('Close');
catch
    Screen('CloseAll')
    rethrow(lasterror)
    

end
%%
