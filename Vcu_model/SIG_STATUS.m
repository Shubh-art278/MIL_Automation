classdef SIG_STATUS < Simulink.IntEnumType
    enumeration
        INVALID(-2)
        NOT_SUPPORTED(-1)
        INIT_STS(0)
        NOT_PRECISE(1)
        VALID(2)
    end
end
