function[trial] = randtrial()

%% introduction
%������ʵ�����¹��ܣ�����һ��1/2������У�����Ϊ54��1/2��Ŀ��ͬ�����ֻ��2��������ͬ
%����������Ϊ54����1��2��27������1����2��������Ϊһ����λ������һ����Ϊ1������2����Ϊ2
%�����������У��ֱ����1��2�����У����������н���ת��ΪĿ���1/2����

trial = ones(8 , 54);  % add 27 '2's to every block later


for iblock = 1 : 8   %��8��block
    seq0 = mod(randperm(18) , 2);  %����0���������
    seq1 = mod(randperm(18) , 2);  %����1���������
    itrial = 1;  %���ÿ��block�ĵڼ���trial
    for i = 1 : 18
        if seq0(i) == 0  %���λ��0
            itrial = itrial + 1;
        elseif seq0(i) == 1
            itrial = itrial + 2;
        end
        
        trial(iblock , itrial) = 2;  %���λ��2
        itrial = itrial +1;
        
        if seq1(i) == 1
            trial(iblock , itrial) = 2;
            itrial = itrial +1;
        end
        
    end
    
end
