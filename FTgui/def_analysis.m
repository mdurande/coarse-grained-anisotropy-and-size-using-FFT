function Results = def_analysis(Param,Results)

        if exist([Param.name{1},'mask'],'dir')
            BW=logical( imread([Param.name{1},'mask',filesep,'mask.tif']));
            xo =  Results.Posi(:,1)+Param.pas2/2-1; % find positions of the center of the subimages
            yo =  Results.Posi(:,2)+Param.pas2/2-1;
            ind=sub2ind(size(BW),yo,xo);
            indb=BW(ind)==0;
   
      
        else
            indb=false(length(Results.Posi));
          
        end

     for c = 1:Results.ci                                   % for each averaged time
        display(['Computation of cell deformation, time: ',num2str(c)]); % for the user to keep track
       
        %% We will group calculus
        SFT = Results.im_regav.spect(c,:,:,:);
        SFT = squeeze(SFT);
        ST = sum(sum(SFT,2),3);
        %indexx = find();
        %% Inertia matrix 
        
        Msft = inertia_matp_sigma(Param,SFT((ST~=0 | isnan(ST)~=0),:,:));

        Results.im_regav.M(c,:,:,:)=Msft;
        Results.im_regav.M(c,indb,:,:)=NaN;
        %% Computation of cell deformation 
        
        [Si,angSi] = S_angS(Msft);

        AlS = zeros(Results.regl,1);
        AlS((ST~=0)) = Si;
        ALS(indb)=NaN;
        Results.im_regav.S(c,:,:) = reshape(AlS,1,Results.numY,Results.numX);
        AlangS = zeros(Results.regl,1);
        AlangS((ST~=0)) = angSi;
        AlangS(indb)=NaN;
        Results.im_regav.angS(c,:,:) = reshape(AlangS,1,Results.numY,Results.numX);
     end
    
    if Param.register == 0 
           Results.im_regav.spect = [];       % delete the spectrum to keep space
    end

end