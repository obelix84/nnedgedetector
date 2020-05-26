classdef NNEdgeDetector
% Public properties
    properties
      I; % image
      EdgeMap; % карта контуров
      WinMap;% карта пей победителей
      receptiveField;% размер поля восприятия
      SN;
    end

% Class methods
    methods
        
        function obj = NNEdgeDetector(numSN, receptiveField)
            obj.SN = SubNet(1, 255/numSN * 1);
            obj.receptiveField = receptiveField;
            for i=2:1:numSN
                obj.SN = [obj.SN SubNet(i, 255/numSN * i)];
                disp(255/numSN * i);
            end
        end % NNEdgeDetector
        
        function detect(obj, I)% на вход подается изображение, на котором находятся края
            [n m] = size(I);
            obj.WinMap = zeros(n, m);
            for i=1:1:n-obj.receptiveField
                for j=1:1:m-obj.receptiveField
                    bi = i;
                    if (mod(bi, 30) == 0)
                        disp(i) 
                    end
                    window = I(i:i+obj.receptiveField-1, j:j+obj.receptiveField-1);
                    imshow(window);
                    x_sred = mean(mean(window))
                    %m1
                    m1 = 0;
                    count = 0;
                    window
                    for k=1:obj.receptiveField^2
                        if window(k)<x_sred
                            m1 = m1 + window(k);
                            count = count+1;
                        end
                    end
                    if count ~= 0
                        m1 = m1/count
                    end
                    %m2
                    m2 = 0;
                    count = 0;
                    
                    for k=1:1:obj.receptiveField^2
                        if window(k)>=x_sred
                            zu = window(k);
                            m2 = zu + m2;
                            disp('----');
                            disp(window(k));
                            disp(k);
                            count = count+1;
                        end
                    end
                    if count~=0
                        m2
                        count
                        m2 = m2/count
                    end
                    m_sred =  (m1+m2)/2;
                    m_sred
                    input('hello');
                    %ищем подсеть победитель
                    indexWinner = 0;
                    metric = 0;
                    for l=1:length(obj.SN)
                        metr = obj.SN.isWinner(m_sred);
                        if metric>=metr
                            indexWinner = l;
                            metric = metr;
                        end
                    end
                    obj.WinMap(i,j) = indexWinner;
                end
            end
            imshow(obj.WinMap);
            obj.WinMap
        end
        
        function trainOnSamples(obj)
            
        end
        
    end
end