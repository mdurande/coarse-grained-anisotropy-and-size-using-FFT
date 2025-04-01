close all
clear variables


debug = false;
szsc=get(0,'screensize');

%% Folder to process
main_path='C:\Users\Les_Zigoto\ownCloud - AYARI Hélène@mycore.cnrs.fr\Kees\Expk0701_actin\results_w250\';
% %% Dans la thèse c'est cette série qui a été utilisée avec seulement 15 et 17 (lot1)

%% Loading data informations



 %for ii=1:length(H)
    cp=1;
qh=1;
for ii=1:2
    Hh=H(ii);
    def_map{ii}=['matdef2_av_',num2str(Hh),'.mat'];
    
    fileID = fopen(fullfile(main_path{ii},'infos_positions.txt'),'r');
    info=fscanf(fileID,'%s');                   % Lis toutes les infos
    informations = strsplit(info,';');      % Extrait les diff�rentes lignes. Il faut qu'il n'y ait que t en premiere ligne, puis les diff�rents B
    
    bsconsider = strsplit(informations{Hh},':');
    display(['Taking care of ', bsconsider{1} ]);    % Display the current experiment processed
    def_path = fullfile(main_path{ii},bsconsider{1},def_folder);
    param_path = fullfile(main_path{ii},bsconsider{1},param_folder);
    velocity_path = fullfile(main_path{ii},bsconsider{1},velocity_folder);
    
    postime =  (strsplit(bsconsider{2},'\'));           % On a encore les positions et le temps � s�parer
    
    pos =  str2double(strsplit(postime{1},','));        % Liste des index � utiliser.
    alltimes =  (strsplit(postime{2},'-'));      % Liste des temps � utiliser.
    
    starts = NaN(numel(alltimes),1);
    ends = NaN(numel(alltimes),1);
    
    
    times =  str2double(strsplit(alltimes{1},','));      % Liste des temps � utiliser.
    starts(1) = times(1);
    
    ends(1)= times(2);
    first = true;
    
    
    
    load(fullfile(def_path,def_map{ii}));
    load(fullfile(def_path,'grid.mat'));
    load(fullfile(velocity_path,'reskltot2.mat'))
    load([param_path,filesep,'param_circles_',num2str(qh),'.mat']);
    %          tps=tps(frame-1)+timeInSeconds;
    
  
    %% Let's do the mean on tintegr frame
    tintegr=100;
  for  numobst=1:2
    rmicr=R(numobst)*grid.pxsize

    mask=ones(size(grid.X));
    mask((grid.X.^2+grid.Y.^2)<rmicr.^2)=0;
    sz(2)=(max(grid.X(:))-min(grid.X(:)))/grid.pxsize/(grid.pas*(1-grid.rec))+1;
    sz(1)=(max(grid.Y(:))-min(grid.Y(:)))/grid.pxsize/(grid.pas*(1-grid.rec))+1  ;

    
    
    for jj=times(2)
        %          for jj=times(1)+10:10:times(2)
        clear tutu
        titi=resklt(numobst,jj-tintegr:jj);
        titin=nanmedian(sqrt(cat(2,[],titi(:).U).^2+cat(2,[],titi(:).V).^2),1);      
        tutu=def_avklt(numobst,jj-tintegr:jj);

        if (numobst==2)
          Uavt=-Uavt; 
        end

%         Uavt=nanmedian(cat(2,[],titi(:).U)./titin,2);
%         Vavt=nanmedian(cat(2,[],titi(:).V)./titin,2);
        Uavt=reshape(nanmedian(cat(2,[],titi(:).U),2),sz);
        Vavt=reshape(nanmedian(cat(2,[],titi(:).V),2),sz);
            if( numobst==2)
                   Uavt=-flip(Uavt,1);
                   Vavt=flip(Vavt,1);
            end

        Uavr(:,:,ii)=Uavt-nanmean(Uavt(:));        
        Vavr(:,:,ii)=Vavt-nanmean(Vavt(:));
        Uav(:,:,ii)=Uavt;        
        Vav(:,:,ii)=Vavt;
%                 figure
%         quiver(grid.X,grid.Y,Vavt(:),Uavt(:))
%         pause
        StdU(:,:,cp)=reshape(nanstd(cat(2,[],titi(:).U),[],2),sz);
        StdV(:,:,cp)=reshape(nanstd(cat(2,[],titi(:).V),[],2),sz);
        Stddef(:,:,ii)=nanstd(cat(2,[],tutu(:).def),[],2);
        Cxxav(:,:,cp)=reshape(nanmedian(cat(2,[],tutu(:).Cxx),2),sz);
        Cyyav(:,:,cp)=reshape(nanmedian(cat(2,[],tutu(:).Cyy),2),sz);
        Cxyav(:,:,cp)=reshape(nanmedian(cat(2,[],tutu(:).Cxy),2),sz);
        
        if (numobst==2)
            Cxyav(:,:,cp)=-flip(Cxyav(:,:,cp),1);
            Cxxav(:,:,cp)=flip(Cxxav(:,:,cp),1);
            Cyyav(:,:,cp)=flip(Cyyav(:,:,cp),1);
        end
        
    end
    cp=cp+1;
  end
end
     mask((grid.X.^2+grid.Y.^2)<max(rmicr).^2)=0;

Cxxavf=nanmedian(Cxxav,3);
Cxyavf=nanmedian(Cxyav,3);
Cyyavf=nanmedian(Cyyav,3);
[epsxav,epsyav,defav,thav]=arrayfun(@diagon,Cxxavf(:),Cyyavf(:),Cxyavf(:));


defav(~mask(:))=0;
thav(~mask(:))=0;
Uavf=nanmean(Uav,3);
Vavf=nanmean(Vav,3);
Uavfr=nanmean(Uavr,3);
Vavfr=nanmean(Vavr,3);
N=tintegr*length(H);
alphalow = 0.95;
Stud = tinv(alphalow,N-2);
StdUf=nanmean(StdU,3)*Stud/sqrt(N-1);
StdVf=nanmean(StdV,3)*Stud/sqrt(N-1);
Stddeff=nanmean(Stddef,3)*Stud/sqrt(N-1);
Uavf(~mask(:))=0;
Vavf(~mask(:))=0;
Uavfr(~mask(:))=0;
Vavfr(~mask(:))=0;

cd '/data1/thoman/ownCloud/articles_redactions/article_Melina/Pictures/newhippo/'

% type could be either Norm, Vx or Vy
plot_axes_speed(Uavf,Vavf,StdUf,StdVf, max(rmicr),grid,['axes_hippo_speed_av_',num2str(tintegr)],'Norm')
plot_axes_def(defav,Stddeff, max(rmicr),grid,['axes_hippo_def_av_',num2str(tintegr)])


% h=figure('Position',[szsc(3)/3,szsc(4)/3,szsc(3)/1.8,szsc(4)/1.8],'Name',['norm bande average_',num2str(tintegr)] );
% figToolbarFix
% hold on
% fact=300;
% %   title(['H',num2str(ii),', obst',num2str(obst),',  $V$'])
% imagesc(reshape(defav,sz))
% title ('bande average')
% 
% % viscircles([0,0],rmicr,'Color','k');
% axis equal
% set(gca,'Ydir','reverse')
% %  set(gca,'Xlim',[-400 400], 'Ylim',[-400 400])
% axis off

Lscalepx = 0.30;  %30% de deformation des cellules
Lscale_dist = 50;



h=figure('Position',[szsc(3)/3,szsc(4)/3,szsc(3)/1.8,szsc(4)/1.8],'Name',['map_strain_hippo_av_',num2str(tintegr)]);
figToolbarFix
hold on
fact=300;
%   title(['H',num2str(ii),', obst',num2str(obst),',  $V$'])
plot_strain(grid.X(:),grid.Y(:),thav(:),defav(:),fact,rmicr)

viscircles([0,0],max(rmicr),'Color','k');
axis equal
set(gca,'Ydir','reverse')
%  set(gca,'Xlim',[-400 400], 'Ylim',[-400 400])
axis off

% Echelle de Deformation.
quiver(-Lscalepx/2*fact,10,Lscalepx*fact,0,'ShowArrowHead','off','Color',[0.7 0 1],'LineWidth',8)
%text(-Lscalepx/2*1*fact-10,70,[num2str(Lscalepx*100) '$\%$'])

% Echelle de distance
quiver(-Lscale_dist/(2*grid.pxsize)+10,-20,Lscale_dist,0,'ShowArrowHead','off','Color','k','LineWidth',8)
%text(-Lscale_dist/(2*grid.pxsize)-40,-55,[num2str(Lscale_dist) '$\mu m$'])



h=figure('Position',[szsc(3)/3,szsc(4)/3,szsc(3)/1.8,szsc(4)/1.8],'Name',['map_speed_hippo_av_',num2str(tintegr)]);
figToolbarFix
hold on
Lscalev = 30;  %30% de deformation des cellules
Lscale_dist = 50;
%   title(['H',num2str(ii),', obst',num2str(obst),',  $V$'])
[~,autoscalev]=quiverh(grid.X,grid.Y,Vavf(:),Uavf(:),1,'b');

viscircles([0,0],max(rmicr),'Color','k');
axis equal
set(gca,'Ydir','reverse')
%  set(gca,'Xlim',[-400 400], 'Ylim',[-400 400])
axis off

% Echelle de vitesse.
           quiver(-Lscalev/2*autoscalev,10,Lscalev*autoscalev,0,'Color',[1 0 1],'LineWidth',3,'MaxHeadSize',1)
      %      text(-Lscalev*autoscalev+1,10+100,[num2str(Lscalev) '$\mu m.h^{-1}$'],'Color','k','Interpreter','latex')


% Echelle de distance
quiver(-Lscale_dist/(2*grid.pxsize)+10,-20,Lscale_dist,0,'ShowArrowHead','off','Color','k','LineWidth',8)
%text(-Lscale_dist/(2*grid.pxsize)-40,-55,[num2str(Lscale_dist) '$\mu m$'])

set(gca,'Ydir','reverse')



pas=1;
[X,Y]=meshgrid(-max(grid.X(:)):pas:max(grid.X(:)),-max(grid.Y(:)):pas:max(grid.Y(:)));
NV=griddata(grid.X,grid.Y,sqrt(Uavfr(:).^2+Vavfr(:).^2),X,Y);
NV((X(:).^2+Y(:).^2)<(nanmax(rmicr)).^2)=NaN;

h=figure('Position',[szsc(3)/3,szsc(4)/3,szsc(3)/1.8,szsc(4)/1.8],'Name',['map_speed_hippo_av_mmean_',num2str(tintegr)]);
figToolbarFix
surf(X,Y,NV,'edgecolor','none')
shading interp
a=colorbar;
a.Label.Interpreter='Latex';
a.Label.String = 'v-$<$v$>$ ($\mu$m.h$^{-1}$)';
view(0,90)
hold on
Lscalev = 10;  %30% de deformation des cellules
Lscale_dist = 50;
%   title(['H',num2str(ii),', obst',num2str(obst),',  $V$'])
grid.Z=100*ones(size(grid.X));
quiver3(grid.X,grid.Y,grid.Z,Vavfr(:),Uavfr(:),zeros(size(Uavfr(:))),'k');

viscircles([0,0],max(rmicr),'Color','k');
axis equal
set(gca,'Ydir','reverse')
%  set(gca,'Xlim',[-400 400], 'Ylim',[-400 400])
axis off

% Echelle de vitesse.
quiver(-Lscalev/2*autoscalev,10,Lscalev*autoscalev,0,'Color',[1 0 1],'LineWidth',3,'MaxHeadSize',1)
%      text(-Lscalev*autoscalev+1,10+100,[num2str(Lscalev) '$\mu m.h^{-1}$'],'Color','k','Interpreter','latex')


% Echelle de distance
quiver(-Lscale_dist/(2*grid.pxsize)+12,-20,Lscale_dist,0,'ShowArrowHead','off','Color','k','LineWidth',8)
%text(-Lscale_dist/(2*grid.pxsize)-40,-55,[num2str(Lscale_dist) '$\mu m$'])

set(gca,'Ydir','reverse')
                                                                                                                                         