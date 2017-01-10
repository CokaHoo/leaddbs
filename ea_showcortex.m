function [Hp,cortex] = ea_showcortex(varargin)
% This function shows a cortical reconstruction in the 3D-Scene viewer. It
% reads in cortex.mat found in the eAuto_root/templates/cortex folder, or 
% in the patientdirectory on button press (Cortical Reconstruction
% Visualization)
% __________________________________________________________________________________
% Copyright (C) 2017 University of Pittsburgh (UPMC), Brain Modulation Lab
%
% Ari Kappel

resultfig=varargin{1};
if nargin==2
    options=varargin{2};
end
if nargin>2
    elstruct=varargin{2};
    options=varargin{3};
end

% Initial Opening
if ~isfield(getappdata(resultfig),'cortex')
    color = options.prefs.d3.cortexcolor; % default color is gray
    alpha = options.prefs.d3.cortexalpha; % default alph is 0.333
else
    color = options.prefs.d3.cortexcolor;
    appdata = getappdata(resultfig);
    appdata = getappdata(appdata.awin);
    alpha = appdata.UsedByGUIData_m.cortexalphaslider.Value;
    clear appdata
end

nm=[0:2]; % native and mni
try
    nmind=[options.atl.pt,options.atl.can,options.atl.ptnative]; % which shall be performed?
catch
    nmind=[0 1 0];
end
nm=nm(logical(nmind)); % select which shall be performed.

mcr=ea_checkmacaque(options);

for nativemni=nm % switch between native and mni space.
    
    switch nativemni
        case 0 % update case 0
            root=[options.earoot,mcr];
            adir=[root,'templates/cortex/'];
            mifix=['mni',filesep];
        case 1
            root=[options.earoot,mcr];
            adir=[root,'templates/cortex/'];
            mifix='';
        case 2
            root=[options.root,options.patientname,filesep];
            adir=[root,''];
            mifix=['native',filesep];
    end
end

load([adir,'cortex.mat'])

hold on
Hp = patch('vertices',cortex.vert,'faces',cortex.tri(:,[1 3 2]),...
    'facecolor',color,'edgecolor','none','FaceAlpha',alpha,...
    'facelighting', 'gouraud', 'specularstrength', .25);
% camlight('headlight','infinite'); axis equal;
