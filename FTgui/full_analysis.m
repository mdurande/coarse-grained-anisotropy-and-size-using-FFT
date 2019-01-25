function Results = full_analysis(Param)

    %% Initialization of the matrices we will use

    Anamesi = cleanfolder(Param.name{1});
    Param.siz = size_image(Param.name{1},Anamesi);

    Results = struct('regl',[],'Posi',[],'im_regav',[],'ci',[],'numX',0,'numY',0); % result structure

    % Find the positions we will use
    [Results.Posi,Results.regl,Results.numX,Results.numY] = Position_gui(Param);
    
    % Length of all the matrices we will later use
    Len = numel(Param.tsart:Param.tleng-Param.timestep+1);
    Results.ci = Len;
    
    Results.im_regav = struct('spect',zeros(Len,Results.regl,Param.pas2),'M',zeros(Len,Results.regl,2),'S',...
        zeros(Len,Results.numY,Results.numX),...
        'angS',zeros(Len,Results.numY,Results.numX),'a',zeros(Len,Results.numY,Results.numX),...
        'b',zeros(Len,Results.numY,Results.numX),'phi',zeros(Len,Results.numY,Results.numX));

    %% Computation of all the averaged spectra on time and sample
    
   Results.im_regav.spect = avfft_forall(Param.name,Results.regl,Param,Results.Posi);

   %% Computation of cell deformation 
   
   Results = def_analysis(Param,Results);     % compute cell orientation subimages
   
   %% Print result
   
   affich_result(Param,Results,'yellow');        % create maps of cell orientations

   %% Analysis in size when required
   
    if Param.regsize == 1
  
        Results = size_analysis(Param,Results);
   
        affich_size(Param,Results,'red');
    else
    end
    
    %% Register results 

    save([Param.pathout,'Results.mat'],'Results','-v7.3');% save results
end












