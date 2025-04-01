function [Udef,Vdef,Udefe,Vdefe,Xdef,Ydef,Param] = format_matrix_plot(Param,Results,Row,Col)


Param.scale=Param.scale*Param.sc;
Ys = unique((Results.Posi(:,2,1)));
Reg_xy = zeros(numel(Ys),numel(unique((Results.Posi(:,1,1)))));

% Le tableau Reg_xy contient les indices de chaque regions
% correspondantes aux positions x,y,x en colonne

for ii = 1:numel(Ys)
    ind = find(Results.Posi(:,2,1) == Ys(ii));
    Reg_xy(ii,:) = ind;
end

%%
Udef = zeros(size(Reg_xy,1),size(Reg_xy,1),Results.ci);
Vdef = zeros(size(Reg_xy,1),size(Reg_xy,1),Results.ci);
Xdef = zeros(size(Reg_xy,1),size(Reg_xy,1),Results.ci);
Ydef = zeros(size(Reg_xy,1),size(Reg_xy,1),Results.ci);
%%
for ml = 1:Results.ci
    for win =1:Results.regl % for each subimage
        [alk,blk] = find(Reg_xy == win);
        xo =  Results.Posi(win,1)+Param.pas2/2-1; % find positions of the center of the subimages
        yo =  Results.Posi(win,2)+Param.pas2/2-1;
        [I,J] = ind2sub([Results.numY,Results.numX],win);
        
        if sum(yo == Row)>0 && sum(Col(yo==Row)==xo)>0
            amp= NaN;
            ang=NaN;
            ampe= NaN;
            ange=NaN;
        else
            amp = Results.im_regav.S(ml,I,J);    % extract amplitude
            ang = Results.im_regav.angS(ml,I,J); % extract angle of deformation
            
            
            x1 = cos(ang+pi/2)*amp*Param.scale; % define the extremities for the plot of deformation
            y1 = sin(ang+pi/2)*amp*Param.scale;
            
            if Param.regsize
                ampe = Results.im_regav.Se(ml,I,J);    % extract amplitude
                ange = Results.im_regav.angSe(ml,I,J); % extract angle of deformation
                
                
                x1e = cos(ange+pi/2)*ampe*Param.scale; % define the extremities for the plot of deformation
                y1e = sin(ange+pi/2)*ampe*Param.scale;
                
            end
            
            if round(x1) <0
                Vdef(alk,blk,ml) = -(round(y1)); % define the extremities for the plot of deformation
                Udef(alk,blk,ml) = -(round(x1));
                if Param.regsize
                    
                    Vdefe(alk,blk,ml) = -(round(y1e)); % define the extremities for the plot of deformation
                    Udefe(alk,blk,ml) = -(round(x1e));
                    
                end
                
            else
                Vdef(alk,blk,ml) = (round(y1)); % define the extremities for the plot of deformation
                Udef(alk,blk,ml) = (round(x1));
                
                if Param.regsize
                    
                    Vdefe(alk,blk,ml) = (round(y1e)); % define the extremities for the plot of deformation
                    Udefe(alk,blk,ml) = (round(x1e));
                    
                end
            end
            
        end
        Xdef(alk,blk,ml) = xo;
        Ydef(alk,blk,ml) = yo;
        
    end
    
end

if ~Param.regsize
    Udefe=[];
    Vdefe=[];
end
end