function Preliminary_Design(MTOW, Static_Margin, ...
    AR_Wing, V_stall, Cl_max,TR, Volume_Hori, Volume_Vert, SHori_per_SWing, AR_Hori, NeutralP_X)
% Outputs the required data for the preliminary design of the Airframe
%
% Input parameters: 
% MTOW: Maximum Take-off weight of the plane
% Static_Margin: Static Margin is The difference between the actual CG location and the neutral point
% AR_Wing: Aspect Ratio of the Wing
% V_stall: Stall velocity
% Cl_max: Maximum coefficient of lift
% TR: Taper Ratio
% Volume_Hori: Horizontal Tail volume coefficient
% Volume_Vert: Vertical Tail volume coefficient
% SHori_per_SWing: Horizontal Tail Area devided by Vertical Tail Area
% AR_Hori: Aspect Ratio of the Horizontal Tail
% NeutralP_X: Neutral point on the X-axis 
%
% Output: Displays the needed data for the Airframe design in Preliminary
% stage including if the CAD Model is not provided
% Note!!! At first in your analysis consider the NeutralP_X to be nan then
% use XLFR5 to find the NeutralP_X in advanced stage of your analysis,
% finally come and insert it again to continue!!!

%% Wing sizing for 3D Wing 
rho = 1.225;
WperS = rho*0.5*Cl_max*V_stall^2;           % Weight of the aircraft devided by the wing area
SWing = MTOW*9.81/WperS;                         % Area of the wing
b_span_Wing = sqrt(SWing*AR_Wing);          % span of the wing
Root_Chord = 2*SWing/b_span_Wing/(1+TR);    % Root Chord
Tip_Chord = TR*Root_Chord;
MAC = Root_Chord*2/3 *((1+TR+TR^2)/(1+TR)); % Mean aerodynamic chord

%% Tail sizing for 3D Tail
AR_vert = AR_Hori;                          % Aspect ratio of Horizontal stablizer equals that of Vertical stablizer
SHori = SHori_per_SWing*SWing;              % Area of the Horizontal stablizer
Arm_LHori = Volume_Hori*SWing*MAC/SHori;    % Horizontal Tail arm
Arm_LVert = Arm_LHori;                      % Vertical Tail arm equals Horizontal Tail arm
SVert = Volume_Vert*...                     
SWing*b_span_Wing/Arm_LVert;                % Area of the Vertical stablizer
b_span_Hori = sqrt(SHori*AR_Hori);          % span of the horizontal Tail
b_span_vert = sqrt(SVert*AR_vert);          % span of the Vertical Tail
Chord_Hori = b_span_Hori/AR_Hori;           % Chord of the Horizontal Tail
Chord_Vert = b_span_vert/AR_vert;           % Chord of the Vertical Tail

%% Structural data if there is no CAD model provided
X_CG = NeutralP_X- (Static_Margin*MAC/100); % X component of the center of gravity
Planelegnth =Arm_LVert + Chord_Hori + MAC;  % Plane length
Ixx = MTOW * (0.11*b_span_Wing)^2;          % Moment of inertia about the X-axis
Iyy = MTOW * (Planelegnth*0.175)^2;         % Moment of inertia about the Y-axis
Izz = MTOW *...
((Planelegnth+b_span_Wing)*0.19)^2;         % Moment of inertia about the Z-axis
%% Thrust required
%V_LOF = 1.2*V_stall;
%% display
fprintf(['Area of the wing = %f\n', ...
        '\nSpan of the wing = %f\n', ...
        '\nRoot Chord = %f\n', ...
        '\nTip Chord = %f\n', ...
        '\nMean Aerodynamic Chord = %f\n', ...
        '\nArea of the Horizontal stabilizer = %f\n', ...
        '\nHorizontal Tail arm = %f\n', ...
        '\nSpan of the horizontal Tail = %f\n', ...
        '\nChord of the Horizontal Tail = %f\n', ...
        '\nArea of the Vertical stabilizer = %f\n', ...
        '\nVertical Tail arm = %f\n', ...
        '\nSpan of the Vertical Tail = %f\n', ...
        '\nChord of the Vertical Tail = %f\n', ...
        '\nX component of the center of gravity = %f\n', ...
        '\nMoment of inertia about the X-axis = %f\n', ...
        '\nMoment of inertia about the Y-axis = %f\n', ...
        '\nMoment of inertia about the Z-axis = %f\n'], ...
        SWing, b_span_Wing,Root_Chord ,Tip_Chord,MAC, SHori, Arm_LHori, b_span_Hori, Chord_Hori, ...
        SVert, Arm_LVert, b_span_vert, Chord_Vert, X_CG, Ixx, Iyy, Izz);  
end