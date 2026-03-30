classdef VCU_MODE < Simulink.IntEnumType
    enumeration
        VCU_PWR_OFF(0)
        VCU_WAKE_UP(1)
        VCU_PARK(2)
        VCU_DRIVE(3)
        VCU_LIMP(4)
        VCU_REVERSE(5)
        VCU_FAIL_SAFE(6)
    end
end
