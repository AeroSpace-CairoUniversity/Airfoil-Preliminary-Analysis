%% Drag class V1 
    % Auther: Ahmed Ibrahim Mohamed
    % Team : So High In the Sky

%% how to use the class
%     create an object --> my_drag=Drag(Flow,Ref_Area,Mass,Vcr,Density,Viscosity)
%         there are 4 methods in the drag class which are:
%             Induced Drag --> my_drag.induced(AR,Span efficiency)
%             Wing Drag --> my_drag.Wing(Thickness-to-Chord ratio,Max_thickness_location-to-Chord ratio,MAC)
%             Horizontal tail Drag --> my_drag.Htail(Thickness-to-Chord ratio,Max_thickness_location-to-Chord ratio,planform area,MAC)
%             Vertical tail Drag --> my_drag.Vtail(Thickness-to-Chord ratio,Max_thickness_location-to-Chord ratio,planform area,MAC)
%             Fuselage Drag --> my_drag.Fuselage(Length,Max_cross_section_area,Wetted Area)
%% Class Defintion

classdef Drag < handle
    properties(Access = private)
        flow;
        Re;
        Sref;
        MTOW;
        rho_sea;
        Vcr;
        viscosity;
    end
    methods 
        function obj=Drag(Flow_cond,Sreference,MTOW_Kg,Vcr,rho,Mu)
            obj.flow=Flow_cond;
            obj.Sref=Sreference;
            obj.MTOW=MTOW_Kg;
            obj.Vcr=Vcr;
            obj.rho_sea=rho;
            obj.viscosity=Mu;
        end
        %% Induced_drag

        function Cd_induced=induced(obj,k)
            Cd_induced = k *(2*obj.MTOW*9.81/obj.rho_sea/obj.Vcr^2/obj.Sref)^2;
        end
        %% wing_drag

        function wing_drag=Wing(obj,TC,XC,MAC)
            obj.Re=obj.Vcr*MAC*obj.rho_sea/obj.viscosity;
            if obj.flow =='T'
                Cf=0.455/(log10(obj.Re))^2.58;
            else
                Cf=1.328/sqrt(obj.Re);
            end
            FF=(1+0.6*TC/XC+100*TC^4);
            Swet=2*(1+0.2*TC)*obj.Sref;
            wing_drag=(Cf*FF*Swet)/obj.Sref;
        end
        %% Tails_drag

            % Horizontal Tail
        function Htail_drag=Htail(obj,TC,XC,SHtail,MAC)
            obj.Re=obj.Vcr*MAC*obj.rho_sea/obj.viscosity;
            if obj.flow =='T'
                Cf=0.455/(log10(obj.Re))^2.58;
            else
                Cf=1.328/sqrt(obj.Re);
            end
            FF=(1+0.6*TC/XC+100*TC^4);
            Swet=2*(1+0.2*TC)*SHtail;
            Htail_drag=(Cf*FF*Swet)/obj.Sref;
        end

             % Vertical Tail
        function Vtail_drag=Vtail(obj,TC,XC,SVtail,MAC)
            obj.Re=obj.Vcr*MAC*obj.rho_sea/obj.viscosity;
            if obj.flow =='T'
                Cf=0.455/(log10(obj.Re))^2.58;
            else
                Cf=1.328/sqrt(obj.Re);
            end
            FF=(1+0.6*TC/XC+100*TC^4);
            Swet=2*(1+0.2*TC)*SVtail;
            Vtail_drag=(Cf*FF*Swet)/obj.Sref;
        end
        %% Fuselage
        function Fuselage_drag=Fuselage(obj,length,Amax,Swetted)
            obj.Re=obj.Vcr*length*obj.rho_sea/obj.viscosity;
            if obj.flow =='T'
                Cf=0.455/(log10(obj.Re))^2.58;
            else
                Cf=1.328/sqrt(obj.Re);
            end
            fineness_ratio=length/sqrt(Amax*4/pi);
            FF=(1+60/fineness_ratio^3+fineness_ratio/400);
            Swet=Swetted;
            Fuselage_drag=(Cf*FF*Swet)/obj.Sref;
        end
    end
end