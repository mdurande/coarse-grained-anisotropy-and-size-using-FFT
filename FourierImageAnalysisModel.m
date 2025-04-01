classdef FourierImageAnalysisModel < handle
    properties
        Image
        DeltaT=1;
        FftEnergy
        FftTotalEnergy
        Resolution=[1 1 1]; % units chosen/pixel  (for exemple if unit is µm frequency would be given in  1/µm
        ImageSize
        FftImageSize
        FftImageCenter
        qr
        dqr
        qth
        freq
        Ellipse_param
        Def_param
        Fsz
        Fszdth
        keepzero
        Msz
        Mszdth
        Msznn
        Msr
        V
        Wavelength
        Wavelengthmax
        Wavelengthnum
        WavelengthAmplitude
        Width50
        Widthnum50
        Windowing
        Wt
        WX
        WY
        WZ
    end
    
    methods
        function FIA = FourierImageAnalysisModel(varargin)
            p = inputParser;
            addParameter(p, 'Image', @isnumeric);
            addParameter(p, 'Resolution',[1, 1, 1], @isnumeric);
            addParameter(p, 'qr',linspace(0,0.5,512), @isnumeric);
            addParameter(p, 'DeltaT',1, @isnumeric);
            addParameter(p, 'keepzero', 0, @isnumeric);
            addParameter(p, 'Windowing', 1, @isnumeric);
            parse(p, varargin{:});
            
            FIA.Image = p.Results.Image;
            FIA.Resolution = p.Results.Resolution;
            FIA.qr=p.Results.qr;
            FIA.DeltaT = p.Results.DeltaT;
            FIA.keepzero=p.Results.keepzero;
            FIA.Windowing=p.Results.Windowing;
            FIA.ImageSize = size(FIA.Image);
            
            
        end
        
        
        
        
        function FIA = performFft(FIA)
            if FIA.Windowing
                im_win = windowing(FIA.Image);
            else
                im_win=FIA.Image;
            end
            
            im_fft = fftn(im_win,FIA.ImageSize);
            if ~FIA.keepzero
                im_fft(1)=0;
            end
            
            im_fft_shift = fftshift(im_fft);%
            FIA.FftEnergy = abs(im_fft_shift).^2;
            FIA.FftTotalEnergy = sum(FIA.FftEnergy(:));
            FIA.FftImageSize = size(FIA.FftEnergy);
            FIA.FftImageCenter = (FIA.FftImageSize + bitget(abs(FIA.FftImageSize),1))/2 + ~bitget(abs(FIA.FftImageSize),1);
            
            
        end
        function FIA=cutCenter(FIA,nb)
            
            if length(FIA.FftImageSize)==3
                FIA.FftEnergy(FIA.FftImageCenter(1)-nb:FIA.FftImageCenter(1)+nb,FIA.FftImageCenter(2)-nb:FIA.FftImageCenter(2)+nb,FIA.FftImageCenter(3)-nb:FIA.FftImageCenter(3)+nb)=0;
            else
                FIA.FftEnergy(FIA.FftImageCenter(1)-nb:FIA.FftImageCenter(1)+nb,FIA.FftImageCenter(2)-nb:FIA.FftImageCenter(2)+nb)=NaN;
            end
        end
        
        
        function FIA=interp3D(FIA)
            
            if mod(FIA.FftImageSize(2),2)==0
                wx=(-FIA.FftImageSize(2)/2:1:(FIA.FftImageSize(2)/2-1))/(FIA.FftImageSize(2)*FIA.Resolution(1));
            else
                wx=(-(FIA.FftImageSize(2)-1)/2:1:(FIA.FftImageSize(2)-1)/2)/(FIA.FftImageSize(2)*FIA.Resolution(1));
            end
            if mod(FIA.FftImageSize(1),2)==0
                wy=(-FIA.FftImageSize(1)/2:1:(FIA.FftImageSize(1)/2-1))/(FIA.FftImageSize(1)*FIA.Resolution(2));
            else
                wy=(-(FIA.FftImageSize(1)-1)/2:1:(FIA.FftImageSize(1)-1)/2)/(FIA.FftImageSize(1)*FIA.Resolution(2));
            end
            if mod(FIA.FftImageSize(3),2)==0
                wz=(-FIA.FftImageSize(3)/2:1:(FIA.FftImageSize(3)/2-1))/(FIA.FftImageSize(3)*FIA.Resolution(3));
            else
                wz=(-(FIA.FftImageSize(3)-1)/2:1:(FIA.FftImageSize(3)-1)/2)/(FIA.FftImageSize(3)*FIA.Resolution(3));
            end
            
            [FIA.WX,FIA.WY,FIA.WZ]=meshgrid(wx,wy,wz);
            pasth=pi/100;
            pasph=pi/100;
            FIA.dqr=mean(diff(FIA.qr));
            [theta,phi,rt]=meshgrid(-pi:pasth:pi,-pi/2:pasph:pi/2,FIA.qr);
            [x,y,z] = sph2cart(theta,phi,rt);
            ind=z>max(wz)|z<min(wz);
            
            
            FIA.V=interp3(FIA.WX,FIA.WY,FIA.WZ,FIA.FftEnergy,x,y,z,'linear',NaN);
            FIA.V(ind)=NaN;
            Vavph=nanmean(FIA.V,1);
            Vavthph=nanmean(squeeze(Vavph),1);
            Vrsum=Vavthph*4*pi.*FIA.qr.^2;
            FIA.Msz=Vrsum/nansum(Vrsum)/FIA.dqr;
            FIA.Msznn=Vrsum/FIA.dqr;
            FIA.Mszdth=Vavthph/nansum(Vavthph,2);
            
            
        end
        function FIA=ellipsoidal_fit(FIA)
            
            
            
            
            size_x = FIA.FftImageSize(2);
            resol_x = FIA.Resolution(1);
            size_y = FIA.FftImageSize(1);
            resol_y = FIA.Resolution(2);
            
            wx=(-floor(size_x/2):1:(ceil(size_x/2)-1))/(size_x*resol_x);
            wy=(-floor(size_y/2):1:(ceil(size_y/2)-1))/(size_y*resol_y);
            
            [wxx,wyy] = meshgrid(wx,wy);
            
            Weights_tot = imgaussfilt(FIA.FftEnergy,0.5).*sqrt(wxx.^2+wyy.^2);
            Weights_tot(isnan(Weights_tot))=0;
%             figure    
%             imagesc([wy(1) wy(end)],[wx(1) wx(end)],Weights_tot)
%             ax =gca;  
%             axis equal
%             hold on
%             xlim(ax,[-0.1 0.1]);
%             ylim(ax,[-0.1 0.1]);
            
            ind = localMaximum_h(Weights_tot,1,false,50);
            %ind = (Weights_tot>0.9*max(Weights_tot(:)));
            %ind = (sqrt(wxx.^2+wyy.^2)<0.1);
            %ind = imbinarize((Weights_tot-min(Weights_tot,[],'all'))/(max(Weights_tot,[],'all')-min(Weights_tot,[],'all')));

            
            
            points_wx = wxx(ind);
            points_wy = wyy(ind);
            Positions = [points_wx, points_wy];
            
            Weights_unorm = Weights_tot(ind);
            Up = max(Weights_tot(:));
            Down = min(Weights_tot(:));
            Weights = (Weights_unorm-Down)/(Up-Down);
            
            
            % 			ind2 = sqrt(points_wx.^2+points_wy.^2)<0.06;
            % 			Weights = Weights(ind2);
            % 			Positions = Positions(ind2,:);
            
            
            
            % 			 Mean_radius = sum(std(Positions,Weights));
            % 			 L_min = Mean_radius/2;
            % 			 L_max = Mean_radius/2;
            theta_0 = atan((Weights.*Positions(:,2))\(Weights.*Positions(:,1)));
            x_tilted = cos(theta_0)*points_wx + sin(theta_0)*points_wy;
            y_tilted = -sin(theta_0)*points_wx + cos(theta_0)*points_wy;
            L_max = std(x_tilted(:))/2;
            L_min = std(y_tilted(:))/2;
            
            Bound_low = [theta_0-0.3,0,0];
          %  Bound_up = [theta_0+0.3,+Inf,+Inf];
            Bound_up = [theta_0+0.3,0.1,0.1];
            
  %          Param_init = [theta_0, L_min, L_max];
           
%             
%              [Param,~,~] = fit_ellipse_weighted_h(Positions,Weights,Param_init,Bound_low,Bound_up);
% %      
%              if max(Param(2),Param(3))>5*min(Param(2),Param(3))
lastwarn('');
                try
            [~,~,Param(3),Param(2),Param(1),~]=ellipsefit(points_wx,points_wy);
                catch
                    Param(3)=NaN;
                    Param(2)=NaN;
                    Param(1)=NaN;
                end
%            end

    if strncmpi(lastwarn,'Rank deficient',length('Rank deficient'))|| strncmpi(lastwarn,'Matrix is singular to working precision.',length('Matrix is singular to working precision.'))
                    Param(3)=NaN;
                    Param(2)=NaN;
                    Param(1)=NaN;
              

    end
             FIA.Ellipse_param = Param;
            

            
%             f_ellipseplotax(Param(3),Param(2),0,0,Param(1),'r',1,ax);
%             plot(points_wx,points_wy,'+');
%            
%      
%             pause
            
        end
        function FIA = calculateWavelength(FIA)
            
            [psz, ii] = max(FIA.Msz);
            FIA.Wavelengthnum=ii;
            FIA.Wavelengthmax = 1/FIA.qr(ii);
            FIA.WavelengthAmplitude = psz;
            perc=0.5;
            i1=find(diff(sign(FIA.Msz(1:ii)-psz*perc))~=0&~isnan(diff(sign(FIA.Msz(1:ii)-psz*perc))));
            i2=find(diff(sign(FIA.Msz(ii:end)-psz*perc))~=0&~isnan(diff(sign(FIA.Msz(ii:end)-psz*perc))));
            
            if ii==1
                FIA.Wavelength=NaN;
            else
                if ~isempty(i1)&&~isempty(i2)
                    Width(1)=i1(end);
                    Width(2)=i2(1)+ii;
                    FIA.Widthnum50=Width;
                    FIA.Width50=(Width-1)*FIA.dqr+FIA.qr(1);
                    ind50=FIA.Widthnum50(1):FIA.Widthnum50(2);
                    qm50=sum(FIA.qr(ind50).*FIA.Msz(ind50))/sum(FIA.Msz(ind50));
                    
                    FIA.Wavelength=1/qm50;
                    FIA.freq=qm50;
                else
                    FIA.Wavelength=FIA.Wavelengthmax;
                end
            end
            
            
            
        end
        
        
        function FIA = interpolateFft2D(FIA)
            if mod(FIA.FftImageSize(2),2)==0
                wx=(-FIA.FftImageSize(2)/2:1:(FIA.FftImageSize(2)/2-1))/(FIA.FftImageSize(2)*FIA.Resolution(1));
            else
                wx=(-(FIA.FftImageSize(2)-1)/2:1:(FIA.FftImageSize(2)-1)/2)/(FIA.FftImageSize(2)*FIA.Resolution(1));
            end
            if mod(FIA.FftImageSize(1),2)==0
                wy=(-FIA.FftImageSize(1)/2:1:(FIA.FftImageSize(1)/2-1))/(FIA.FftImageSize(1)*FIA.Resolution(2));
            else
                wy=(-(FIA.FftImageSize(1)-1)/2:1:(FIA.FftImageSize(1)-1)/2)/(FIA.FftImageSize(1)*FIA.Resolution(2));
            end
            
            [FIA.WX,FIA.WY]=meshgrid(wx,wy);
            FIA.qth = linspace(0, 2*pi, 200);
            FIA.dqr=mean(diff(FIA.qr));
            [QTheta, QRho] = meshgrid(FIA.qth, FIA.qr); % create a grid with radial points
            [QX, QY] = pol2cart(QTheta, QRho);    % the same grid in cartesian coordinates
            
            if length(FIA.FftImageSize)==3
                for ii=1:FIA.FftImageSize(3)
                    FIA.Fsz(:,:,ii) = interp2(FIA.WX, FIA.WY, FIA.FftEnergy(:,:,ii), QX, QY);
                    Fszavth=nanmean(FIA.Fsz(:,:,ii),2);
                    Fszrsum=Fszavth.*2.*pi.*FIA.qr';
                    Fszavr=nanmax(QRho.*FIA.Fsz(:,:,ii),[],1);
                    FIA.Msr(ii,:)=Fszavr'/nansum(Fszavr,2);
                    FIA.Msz(ii,:)=Fszrsum/nansum(Fszrsum)/FIA.dqr;
                    FIA.Mszdth(ii,:)=Fszavth/nansum(Fszavth);
                end
                if mod(FIA.FftImageSize(3),2)==0
                    FIA.Wt=(-FIA.FftImageSize(3)/2:1:(FIA.FftImageSize(3)/2-1))/(FIA.FftImageSize(3)*FIA.DeltaT);
                else
                    FIA.Wt=(-(FIA.FftImageSize(3)-1)/2:1:(FIA.FftImageSize(3)-1)/2)/(FIA.FftImageSize(3)*FIA.DeltaT);
                end
            else
                
                FIA.Fsz = interp2(wx, wy, FIA.FftEnergy, QX, QY);
                Fszavth=nanmean(FIA.Fsz,2);
                Fszavr=nanmean(FIA.Fsz,1)';
                Fszrsum=Fszavth.*2.*pi.*FIA.qr';
                FIA.Msz=Fszrsum'/nansum(Fszrsum,1)/FIA.dqr;
                FIA.Mszdth=Fszrsum/nansum(Fszrsum,1);
                FIA.Msr=Fszavr/nansum(Fszavr,1);
            end
            
        end
        
        function FIA=def_analysis(FIA,propor)
     
       % propor=5/100;                    % sort in intensity and keep indexes
            % nbel number of points determined by Param.propor
                    Param.sigma = 0.8;
         filtre = gaussianFilter(ceil(2*Param.sigma),Param.sigma);    
        fftfiltered = filter2(filtre,FIA.FftEnergy); 
              nbel = propor *numel(FIA.FftEnergy);   
                      Param.strel = 4;  
        se=strel('disk',Param.strel);                % smooth with a strel

        [~,index]= sort(fftfiltered(:),'descend'); 
        th_spec=zeros(FIA.FftImageSize);
        
        th_spec(index(1:floor(nbel))) = 1;           % put to one the points kept by proportion

        th_spec=imclose(th_spec,se);

        
        %% Inertia matrix computation
        
      norm = sum(sum((th_spec).^2));               % computes norm 
        [Yg,Xg]=meshgrid(1:FIA.FftImageSize(2),1:FIA.FftImageSize(1)); % create meshgrid of correct size
        xc = FIA.FftImageCenter(2);                               % position of the center 
        yc = FIA.FftImageCenter(1);
        Xo = Xg-xc;                           
        Yo = Yg-yc;
        Y = (Yg-yc).^2; % Lignes
        X = (Xg-xc).^2; % Colonnes
        YY = sum(sum(th_spec.*Y))/norm;         % compute the 3 different values in the inertia matrix
        XX = sum(sum(th_spec.*X))/norm;
        XY = sum(sum(th_spec.*Xo.*Yo))/norm;
%         YY = sum(sum(th_spec.*Y));         % compute the 3 different values in the inertia matrix
%         XX = sum(sum(th_spec.*X));
%         XY = sum(sum(th_spec.*Xo.*Yo));
        
        %% Registering of inertia matrix
        
        M = [XX,XY;XY,YY];                           % keep matrix of inertia

     [~,E] = eig(M);                % extract the eigenvalues of the inertia matrix
    L1 = 2*sqrt(E(2,2)/2);         % definition of the minor and major axis of the inertia ellipse     
    L2 = 2*sqrt(E(1,1)/2);
    lgE = -1/2*(log(L1/L2));       % amplitude of the cell deformation
    Dev = M-1/2*trace(M)*eye(2);   % deviation matrix
    [V,~] = eig(Dev);              % eigenvectors of deviation matrix to extract the angle
    ang=atan(V(1,2)/V(2,2));       % definition of angle
    FIA.Def_param(1) = ang;                    % register angle
    FIA.Def_param(2) = lgE;        
    % register amplitude
%             figure
%         imagesc(th_spec)
%         axis equal
%     hold on
%     plot_strain(xc,yc,ang,lgE,100,'r')
%     pause
%     
    
        end
        
        
    end
    
end