%% Thurst class V1 
    % Auther: Ahmed Ibrahim Mohamed
    % Team : So High In the Sky
%% How to use Thurst class
%     Create an object Calc_thrust = Thrust(V_lift_off,Vmax,Cruise_parasite,Take-off_drag,Weight-to-wing_area_ratio,K,ground_run,density,V_init)
%     There are two methods as following :
%        Required Dynamic thurst - to - weight ratio = Calc_thurst.TW_R_D()
%        Required Static thurst - to - weight ratio = Calc_thurst.TW_S_D()


%% Class Defintion

classdef Thrust < handle
    properties (Access = private)
        CD_0;
        VLOF;
        Vmax;
        WS;
        K;
        CDTO;
        rho;
        Sg;
        VL;
    end


    methods 
            function obj=Thrust(VLOF,Vmax,CD_0,CDTO,WS,K,Sg,rho,VL)
                obj.VLOF=VLOF;
                obj.Vmax=Vmax;
                obj.CD_0=CD_0;
                obj.CDTO=CDTO;
                obj.WS=WS;
                obj.K=K;
                obj.Sg=Sg;
                obj.VL=VL;
                obj.rho=rho;
            end
            function TW = TW_R_S(obj)
                q=0.5*obj.rho*((obj.VLOF-obj.VL)/sqrt(2))^2; %dynamic pressure
                TW = (obj.VLOF^2-obj.VL^2)/(2*9.81*obj.Sg)+q*obj.CDTO/obj.WS; %thrust-weight ratio
            end
            function TW = TW_R_D(obj)
                TW = obj.rho*obj.Vmax^2*obj.CD_0*0.5*1/obj.WS + 2*obj.K*obj.WS/obj.rho/obj.Vmax^2; %thrust-weight ratio
            end
    end
end