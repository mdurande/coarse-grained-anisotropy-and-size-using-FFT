%% Initialization

clear 
close all
addpath('FTgui')

Param = struct('siz',[],'tleng',[],'pas2',[],'name',[],'fres',[]...
,'cut',[],'propor',[],'pathin',[],'pathout',[],'timestep',[]...
,'sigma',[],'strel',[],'register',[],'regsize',[],'nbpoints',[],'sizeview',[],'contour',[],'rec',[],'tstart',[]);


%% Output folder location

%Param.pathin = {['result' filesep]}; 
Param.pathin = {['/data1/thoman/ownCloud/Git/Melina/result' filesep]}; 


%% List of folders to treat/folder to treat

%When you want to average data comming from multiple folders, write them like this (uncomment the following
%lines)

%  Param.name = {'C:\Users\Melina\Documents\DOCTORAT\Matlab\2A\CAMILLE\Probleme\1\';
%       'C:\Users\Melina\Documents\DOCTORAT\Matlab\2A\CAMILLE\Probleme\2\'};


% When one folder only is required, write it like this:

 Param.name = { ['/data1/thoman/ownCloud/Git/Melina/test_image' filesep]}; % be careful the path should be ended by '\' or '/' depending on the system used (mac/pc/linux)
% If you want to add a mask on your image create a mask folder as a
% subdirectory in your image folder and put there your binary mask
 
 
%% Parameters you should change and that are NOT tunable with the user interface

Param.rec = 0;                % Overlap between the sliding boxes 
Param.tstart = 1;                % Beginning of the analysis
Param.tleng = 1;               % End of the analysis
Param.timestep = 1;         % Temporal average

%% Parameters that ARE tunable with the user interface

Param.pas2= 100;                % Size of the subwindows
Param.cut = 2;                       % Cut of the spectra
Param.propor =  0.012;          % Proportion of points to keep
Param.sigma = 0.8;              % Gaussian filter
Param.register = 0;             %   Save spectra if 1, 0 otherwise
Param.regsize = 1;              % Analysis in size required ? 
Param.nbpoints = 50;          % Number of points to keep in the ellipse fit
Param.strel = 2;                % Strel of the spectra



%% Parameters that can be changed if desired

Param.scale = 200;                    % scaling for cell deformation 
Param.fres = 'results';               % name of the output folder created

%% Never change this 

Param.contour=[];

%% Creation of the output folder

 Param.pathout = [Param.pathin{1}, Param.fres ,'_averageon_', num2str(Param.timestep) ,'_averageon_' num2str(size(Param.name,1)) filesep]; % path to result folder
 if ~exist(Param.pathout,'dir')             % creation of result folder
 mkdir(Param.pathout)
 else
    delete([Param.pathout,'*'])
 end

 %% Visualization of the parameters
GUI_deformation_ft(Param)  


%% Analysis alone if required

%full_analysis(Param);

%% Save results 

save([Param.pathout,'Param.mat'],'Param','-v7.3');


















