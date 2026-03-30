classdef VCU_DRV_MODE < Simulink.IntEnumType
    enumeration
        DRV_NONE(0)
        DRV_OFF(1)
        DRV_NORMAL(2)
        DRV_ECO(3)
        DRV_SPORT(4)
        DRV_TURBO(5)
    end
end
