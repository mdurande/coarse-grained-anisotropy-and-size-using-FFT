function FTs = avfft_forall(path,wins,Param,Positions)

%% Initialization 
  
    nbel = size(path,1);% Nb of different experiments
   
   Len = numel(Param.tstart:Param.tleng-Param.timestep+1);
   
   FTs = zeros(Len,wins,Param.pas2,Param.pas2);
   
    x = Positions(:,1);
    y = Positions(:,2);

%% Loop top average on time and sample

cmp = 0;
for to = Param.tstart:Param.tleng-Param.timestep+1 
    cmp=cmp+1;
    for t = to:to+Param.timestep-1  
        display(['Please wait, computation of FT ', num2str(t)]);
        As = zeros(nbel,Param.siz(1),Param.siz(2));
        for ii = 1:nbel

           name = cleanfolder([Param.name{ii}]);
           As(ii,:,:)= choose_image(path{ii},name,t);                                  %  Nb of subimages
        end
        
        for kk = 1:wins
             for ii = 1: nbel    
           
                 FTs(cmp,kk,:,:) = FTs(cmp,kk,:,:)+reshape(fft_adir(squeeze(As(ii,y(kk):y(kk)+Param.pas2-1,x(kk):x(kk)+Param.pas2-1))),1,1,Param.pas2,Param.pas2);                  
             end
        end
              
    end
end


FTs = FTs/(nbel+Param.timestep);
end