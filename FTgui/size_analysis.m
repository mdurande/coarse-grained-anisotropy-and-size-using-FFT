function Results = size_analysis(Param,Results)
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
        display(['Computation of cell size, time: ',num2str(c)]); % for the user to keep track

        SFT = Results.im_regav.spect(c,:,:,:);
        SFT = squeeze(SFT);
        ST = sum(sum(SFT,2),3);

        %%
        
        [A,B,Phi,~,~]= size_def(Param,SFT((ST~=0 | isnan(ST)~=0),:,:));
        
        %% Registering in correct format
        
        interA = zeros(Results.regl,1);
        interB = zeros(Results.regl,1);
        interphi = zeros(Results.regl,1);
        interA((ST~=0 | isnan(ST)~=0)) = A;
        interB((ST~=0 | isnan(ST)~=0)) = B;
        interphi((ST~=0 | isnan(ST)~=0)) = Phi;
        interA(indb)=NaN;
        interB(indb)=NaN;
        interphi(indb)=NaN;
        
        Results.im_regav.a(c,:,:) = reshape(interA,1,Results.numY,Results.numX);
        Results.im_regav.b(c,:,:) = reshape(interB,1,Results.numY,Results.numX);
        Results.im_regav.Se(c,:,:) = 1/2*log(Results.im_regav.a(c,:,:)./Results.im_regav.b(c,:,:));
        Results.im_regav.angSe(c,:,:) =   reshape(interphi,1,Results.numY,Results.numX);;
     end
end
