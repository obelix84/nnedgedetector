classdef SubNet %#ok<ALIGN>
% Public properties
    properties
        number; %номер подсети
        m_sred = 0;
        
    end

% Class methods
    methods
        function obj = SubNet(num, sred)
            obj.number = num;
            obj.m_sred = sred;
        end
        
        function metric = isWinner(obj, m)
            zu = obj.m_sred;
            metric = abs(m-zu);
        end
    end
end