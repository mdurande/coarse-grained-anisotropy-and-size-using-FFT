%% Take the directories useful 
clear all 
close all
addpath('FTgui')
addpath('PIV')

%% Initialisation

Param = struct('siz',[],'tleng',[],'pas2',[],'name',[],'fres',[]...
,'cut',[],'propor',[],'pathin',[],'pathout',[],'timestep',[]...
,'sigma',[],'strel',[],'register',[],'regsize',[],'nbpoints',[],'sizeview',[],'contour',[],'rec',[],'tsart',[]);


%% Là où on veut créer le dossier de sortie 

Param.pathin = {'C:\Users\Melina\Documents\DOCTORAT\Matlab\2A\CAMILLE\Probleme\3\1\'}; 

%% Liste des dossiers à traiter/ dossier unique.

% Exemple quand tu as plusieurs dossiers, il faut les mettre comme ça:

Param.name = {'C:\Users\Melina\Documents\DOCTORAT\Matlab\2A\CAMILLE\Probleme\1\';
     'C:\Users\Melina\Documents\DOCTORAT\Matlab\2A\CAMILLE\Probleme\2\'};
 
%Param.name = {'C:\Users\Melina\Documents\DOCTORAT\Matlab\2A\CAMILLE\Probleme\3\1\'};
 %Param.name={'C:\Users\Melina\Documents\DOCTORAT\Analyse_manip\190418_MDCK_HISTGFP_band_2\Im\'}
% Qiuand un seul dossier comme ça 

%Param.name = {'/Users/Melina/Documents/Doctorat/Matlab/2A/Aurelien/Basal/'};
 
%% Paramètres à changer potentiellement et qui ne sont pas réglables avec ce GUI

Param.rec = 0.5;                % Recouvrement entre les boites    
Param.tsart = 1;                % Début d'analyse
Param.tleng = 2;               % Fin d'analyse
Param.timestep = 2;             % Moyennage temporel 

%% Correspondance pixels micron et slice en minutes

eq_temps.mic = 10;%0.622; % doit etre le nombre de microns par pixels
eq_temps.tslice = 1; % temps entre les images en heure
eq_temps.echelle = 3; % Doit etre le nombre de microns par heures que l'on veut sur l'échelle 

%%  Paramètres à changer potentiellement et qui sont réglables avec le GUI

Param.pas2= 100;                % Taille des sous-images
Param.cut = 5;                  % Cut des spectres
Param.propor =  0.02;          % Propotion des points à garder
Param.sigma = 0.8;              % Filtre gaussien 
Param.register = 0;             % Enregistreemnbt des spectres ? (attention, lourd)
Param.regsize = 0;              % Analyse en taille
Param.nbpoints = 30;            % Nombre de points à garder pour la taille
Param.strel = 4;                % Strel des spectres

Param.stringP = 'X';            % Moyenne spatiale, selon axe 'X' ou 'Y'

%% Paramètres à ne toucher que TRES rarement 

Param.scale = 150;                    % scaling for cell deformation 
Param.fres = 'results';               % nom utile pour al création du dossier de sortie

%% À ne jamais changer
Param.contour=[];

%% Creation dossier de sortie 

 Param.pathout = [Param.pathin{1}, Param.fres ,'_averageon_', num2str(Param.timestep) ,'_averageon_' num2str(size(Param.name,1)) '/']; % path to result folder
 if ~exist(Param.pathout,'dir')             % creation of result folder
 mkdir(Param.pathout)
 end

 %% Code visualisation des paramètres
 
GUI_deformation_ft(Param)  

%% Code analyse

%full_analysis(Param)
%% Code de PIV 
% 
% compute_piv(Param,eq_temps)

%% Code pour le moyennage de la PIV 

% average_piv_time_ensemble(Param,eq_temps)

%% Sauvegarde des résultats 

save([Param.pathout,'Param.mat'],'Param','-v7.3');


















