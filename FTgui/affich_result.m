function affich_result(Param,Results,col)
    
  r=groot;
  sz=r.ScreenSize;
  lw=2;%linewidth of deformation plot
  
  [Udef,Vdef,Udefe,Vdefe,Xdef,Ydef,Param] = format_matrix_plot(Param,Results,0,0);

    for c = 1:Results.ci                            % for each averaged time
  
        display(['Representation of deformation map, time: ',num2str(c)]); % for the user to keep track

         Figure = figure('Position',sz);                            % Open figure
        imagesc(255*ones(Param.siz(1),Param.siz(2)));     
        colormap(gray)% Initialize figure with zeros, same size as the original
        set(gca,'clim',[0 255]);
        hold on                                         % wait
        quiver(Xdef(:,:,c),Ydef(:,:,c),(Udef(:,:,c))/2,(Vdef(:,:,c))/2,0,'color','r','Autoscale','off','MaxHeadSize',0,'linewidth',lw);
        quiver(Xdef(:,:,c),Ydef(:,:,c),-(Udef(:,:,c))/2,-(Vdef(:,:,c))/2,0,'color','r','Autoscale','off','MaxHeadSize',0,'linewidth',lw);

        set(gca,'XTickLabel','','YTickLabel','');

        plot([floor(Param.siz(2)*0.9)-Param.scalef/100*Param.scale,floor(Param.siz(2)*0.9)-1],[Param.siz(1)*0.9,Param.siz(1)*0.9],'linewidth',lw,'color','k');
        text((floor(Param.siz(2)*0.9)-Param.scalef/100*Param.scale),Param.siz(1)*0.9-30,[num2str(Param.scalef),'$\%$'],'color','k');
     %   set(gcf,'color','white');
        axis equal
        axis off
        pause(0.1)
        img = getframe(gcf);
        imwrite(img.cdata, [Param.pathout  ['Deformation_map_averagedtime' num2str(Param.timestep) '_averaged_space_' num2str(Param.pas2) '.tif' ]],'compression','none','WriteMode','append'); % save image png
      
        close(Figure);

        
        Figure = figure('Position',sz);      
        name = cleanfolder([Param.name{1}]);
        a = choose_image(Param.name{1},name,c);
        a = im2double(a);
        Q1 = quantile(a(:),5/100);
        Q2 = quantile(a(:),95/100);
        b=imadjust(a,[Q1,Q2],[0 1]);
        imagesc(b);        % Initialize figure with zeros, same size as the original
        colormap(gray)
        hold on                                         % wait
        quiver(Xdef(:,:,c),Ydef(:,:,c),(Udef(:,:,c))/2,(Vdef(:,:,c))/2,0,'color',col,'Autoscale','off','MaxHeadSize',0,'linewidth',lw);
        quiver(Xdef(:,:,c),Ydef(:,:,c),-(Udef(:,:,c))/2,-(Vdef(:,:,c))/2,0,'color',col,'Autoscale','off','MaxHeadSize',0,'linewidth',lw);

        set(gca,'XTickLabel','','YTickLabel','');
        plot([floor(Param.siz(2)*0.9)-Param.scalef/100*Param.scale,floor(Param.siz(2)*0.9)-1],[Param.siz(1)*0.9,Param.siz(1)*0.9],'linewidth',lw,'color','r');
        text((floor(Param.siz(2)*0.9)-Param.scalef/100*Param.scale),Param.siz(1)*0.9-30,[num2str(Param.scalef),'$\%$'],'color','r');
        set(gcf,'color','white');
        axis equal
        axis off
        pause(0.1)
        img = getframe(gcf);
        imwrite(img.cdata, [Param.pathout  ['Deformation_map_onim_averagedtime' num2str(Param.timestep) '_averaged_space_' num2str(Param.pas2) '.tif' ]],'compression','none','WriteMode','append'); % save image png
        close(Figure);
 

    end
    if Param.regsize
    for c = 1:Results.ci                            % for each averaged time
  
        display(['Representation of deformation map, time: ',num2str(c)]); % for the user to keep track

         Figure = figure('Position',sz);                            % Open figure
        imagesc(255*ones(Param.siz(1),Param.siz(2)));     
        colormap(gray)% Initialize figure with zeros, same size as the original
        set(gca,'clim',[0 255]);
        hold on                                         % wait
        quiver(Xdef(:,:,c),Ydef(:,:,c),(Udefe(:,:,c))/2,(Vdefe(:,:,c))/2,0,'color','r','Autoscale','off','MaxHeadSize',0,'linewidth',lw);
        quiver(Xdef(:,:,c),Ydef(:,:,c),-(Udefe(:,:,c))/2,-(Vdefe(:,:,c))/2,0,'color','r','Autoscale','off','MaxHeadSize',0,'linewidth',lw);

        set(gca,'XTickLabel','','YTickLabel','');

        plot([floor(Param.siz(2)*0.9)-Param.scalef/100*Param.scale,floor(Param.siz(2)*0.9)-1],[Param.siz(1)*0.9,Param.siz(1)*0.9],'linewidth',lw,'color','k');
        text((floor(Param.siz(2)*0.9)-Param.scalef/100*Param.scale),Param.siz(1)*0.9-30,[num2str(Param.scalef),'$\%$'],'color','k');
     %   set(gcf,'color','white');
        axis equal
        axis off
        pause(0.1)
        img = getframe(gcf);
        imwrite(img.cdata, [Param.pathout  ['Deformatione_map_averagedtime' num2str(Param.timestep) '_averaged_space_' num2str(Param.pas2) '.tif' ]],'compression','none','WriteMode','append'); % save image png
      
        close(Figure);

        
        Figure = figure('Position',sz);      
        name = cleanfolder([Param.name{1}]);
        a = choose_image(Param.name{1},name,c);
        a = im2double(a);
        Q1 = quantile(a(:),5/100);
        Q2 = quantile(a(:),95/100);
        b=imadjust(a,[Q1,Q2],[0 1]);
        imagesc(b);        % Initialize figure with zeros, same size as the original
        colormap(gray)
        hold on                                         % wait
        quiver(Xdef(:,:,c),Ydef(:,:,c),(Udefe(:,:,c))/2,(Vdefe(:,:,c))/2,0,'color',col,'Autoscale','off','MaxHeadSize',0,'linewidth',lw);
        quiver(Xdef(:,:,c),Ydef(:,:,c),-(Udefe(:,:,c))/2,-(Vdefe(:,:,c))/2,0,'color',col,'Autoscale','off','MaxHeadSize',0,'linewidth',lw);

        set(gca,'XTickLabel','','YTickLabel','');
        plot([floor(Param.siz(2)*0.9)-Param.scalef/100*Param.scale,floor(Param.siz(2)*0.9)-1],[Param.siz(1)*0.9,Param.siz(1)*0.9],'linewidth',lw,'color','r');
        text((floor(Param.siz(2)*0.9)-Param.scalef/100*Param.scale),Param.siz(1)*0.9-30,[num2str(Param.scalef),'$\%$'],'color','r');
        set(gcf,'color','white');
        axis equal
        axis off
        pause(0.1)
        img = getframe(gcf);
        imwrite(img.cdata, [Param.pathout  ['Deformatione_map_onim_averagedtime' num2str(Param.timestep) '_averaged_space_' num2str(Param.pas2) '.tif' ]],'compression','none','WriteMode','append'); % save image png
        close(Figure);
 

    end
    end
    
    
    
end








 