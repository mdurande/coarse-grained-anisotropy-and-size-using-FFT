function varargout = GUI_deformation_ft(varargin)
% GUI_deformation_ft MATLAB code for GUI_deformation_ft.fig
%      GUI_deformation_ft, by itself, creates a new GUI_deformation_ft or raises the existing
%      singleton*.
%
%      H = GUI_deformation_ft returns the handle to a new GUI_deformation_ft or the handle to
%      the existing singleton*.
%
%      GUI_deformation_ft('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_deformation_ft.M with the given input arguments.
%
%      GUI_deformation_ft('Property','Value',...) creates a new GUI_deformation_ft or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_deformation_ft_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_deformation_ft_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_deformation_ft

% Last Modified by GUIDE v2.5 23-Oct-2022 18:33:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_deformation_ft_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_deformation_ft_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%
% function cleanednames = cleanfolder(folder)
%     int1 = dir(folder);
%     int1([int1.isdir]) = [];
%     A = strfind({int1.name},'.DS_Store');
%     cleanednames = int1(cellfun('isempty',A));


% --- Executes just before GUI_deformation_ft is made visible.
function GUI_deformation_ft_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_deformation_ft (see VARARGIN)

% Choose default command line output for GUI_deformation_ft
handles.output = hObject;
set(handles.choose,'value',0);
handles.Param=varargin{1};

handles.Anamesi = cleanfolder([handles.Param.name{1}]);

handles.image1 = 0;
handles.image2 = 0;
handles.image3 = 0;
handles.Param.zoom = 2;
handles.rec = (1-handles.Param.rec)*handles.Param.pas2;

handles.Param.sizeview = 0;

handles = calculregion(handles);
handles = affichim(handles);
handles = fftcalculus(handles);
handles = gaussfilt(handles);
handles = cutfun(handles);
handles = affichcutfft(handles);
handles = proporfft(handles);
handles = affichproporfft(handles);

handles = filter(handles);

sz=handles.Param.siz;
handles = trace_defo(handles);
if handles.Param.regsize
    set(handles.sizes,'Value',1);
    sizes_Callback(handles.sizes,[],handles);
    set(handles.regsize,'Value',1);
    set(handles.adv,'Value',1);
    adv_Callback(handles.adv,[],handles);
end



set(handles.window,'Min',20,'Max',min(sz),'SliderStep',[2/(min(sz)-20),20/(min(sz)-20)],'Value',handles.Param.pas2)
set(handles.enterwindow,'String',num2str(handles.Param.pas2))
set(handles.sigma,'Value',handles.Param.sigma)
set(handles.editsigma,'String',num2str(handles.Param.sigma))

set(handles.cut,'Value',handles.Param.cut)
set(handles.editcut,'String',num2str(handles.Param.cut))

set(handles.propor,'Value',handles.Param.propor)
set(handles.editpropor,'String',num2str(handles.Param.propor))

set(handles.strel,'Value',handles.Param.strel)
set(handles.editstrel,'String',num2str(handles.Param.strel))

set(handles.slidersize,'Value',handles.Param.nbpoints)
set(handles.editsize,'String',num2str(handles.Param.nbpoints))

set(handles.zoom,'Value',handles.Param.zoom)
set(handles.editzoom,'String',num2str(handles.Param.zoom))

KB=handles.Param.pas2^2*9.53674e-7*8;
KBwhole  = KB*handles.regl;
set(handles.sizesub,'String',sprintf(['One image: ' num2str(floor(KBwhole)) ' MB']));
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_deformation_ft_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles;

% --- Executes on button press in shuffle.
function shuffle_Callback(hObject, ~, handles)
% hObject    handle to shuffle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of shuffle
shuffleval = get(hObject,'Value');
if shuffleval == 1
    set(handles.shuffle,'Value',0);
    handles = calculregion(handles);
    handles = affichim(handles);
    handles = fftcalculus(handles);
    handles = gaussfilt(handles);
    handles = cutfun(handles);
    handles = affichcutfft(handles);
    handles = proporfft(handles);
    handles = affichproporfft(handles);
    handles = trace_defo(handles);
    
    if get(handles.sizes,'Value') 
        
        handles = ellipses_def(handles);
        handles = affichsize_ellipsdef(handles);

    end
    
    
    
    handles = filter(handles);
    
else
end
guidata(hObject, handles);



% --- Executes on button press in choose.
function choose_Callback(hObject, ~, handles)
% hObject    handle to choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of choose

a = imread([handles.Param.name{1},  handles.Anamesi(handles.Param.tstart).name]);
a = im2double(a);
get(hObject,'Value')
if get(hObject,'Value')
    F = figure(2);
    imagesc(a)
    % colormap(gray)
    hold on
    
    for win = 1:2:handles.regl
        
        x = handles.Posi(win,1)+handles.Param.pas2/2;
        y = handles.Posi(win,2)+handles.Param.pas2/2;
        text(x,y,num2str(win),'Color','r','FontSize',45);
        
        
    end
    Numbs = choose();
    waitfor(Numbs.OK,'Value',1)
    
    handles.image1 = str2double(Numbs.NB1.String);
    handles.image2 = str2double(Numbs.NB2.String);
    handles.image3 = str2double(Numbs.NB3.String);
    close(Numbs.figure1);
    %        handles.image1 = input('What is the number of the first subimage? ');
    %        handles.image2 = input('What is the number of the second subimage? ');
    %        handles.image3 = input('What is the number of the third subimage? ');
    close(F);
    handles = calculregion(handles);
    handles = affichim(handles);
    handles = fftcalculus(handles);
    handles = gaussfilt(handles);
    handles = cutfun(handles);
    handles = affichcutfft(handles);
    handles = proporfft(handles);
    handles = affichproporfft(handles);
    handles = trace_defo(handles);
    if get(handles.sizes,'Value') 
        
        handles = ellipses_def(handles);
        handles = affichsize_ellipsdef(handles);
    end
    
    
    handles = filter(handles);
    set(hObject,'value',0)
    
end
    
% else
%     handles.image1 = 0;
%     handles.image2 =0;
%     handles.image3 =0;
%     handles = calculregion(handles);
%     handles = affichim(handles);
%     handles = fftcalculus(handles);
%     handles = gaussfilt(handles);
%     handles = cutfun(handles);
%     handles = affichcutfft(handles);
%     handles = proporfft(handles);
%     handles = affichproporfft(handles);
%     handles = trace_defo(handles);
%     if get(handles.sizes,'Value')
%         
%         handles = ellipses_def(handles);
%         handles = affichsize_ellipsdef(handles);
%  
%     end
%     
%     
%     
%     handles = filter(handles);
    
%end
guidata(hObject, handles);





% --- Executes on slider movement.
function sigma_Callback(hObject, ~, handles)
% hObject    handle to sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%newval = floor(get(hObject,'Value'));
newval = get(hObject,'Value');
%   handles.sigma = newval;
handles = fftcalculus(handles);
handles = gaussfilt(handles);
handles = cutfun(handles);
handles = affichcutfft(handles);
set(handles.editsigma,'String',newval);
handles.Param.sigma = newval;
if get(handles.sizes,'Value') 
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);
 
end

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function sigma_CreateFcn(hObject, ~, ~)
% hObject    handle to sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
set(hObject,'Min',0,'Max',2,'SliderStep',[0.1,1]);

%set(hObject,'Min',0,'Max',100,'SliderStep',[1,10],'Value',1);
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function propor_Callback(hObject, ~, handles)
% hObject    handle to propor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.Param.propor = get(hObject,'Value');
handles.Param.propor = handles.Param.propor*10^-3;
handles = proporfft(handles);
handles = affichproporfft(handles);
handles = trace_defo(handles);
set(handles.editpropor,'String',handles.Param.propor);
if get(handles.sizes,'Value') 
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

end

handles = filter(handles);


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function propor_CreateFcn(hObject, ~, handles)
% hObject    handle to propor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.

set(hObject,'Min',0,'Max',200,'SliderStep',[1/50,10/50]);

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
guidata(hObject,handles);


function edit1_Callback(~, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function strel_CreateFcn(hObject, ~, handles)
% hObject    handle to strel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
set(hObject,'Min',1,'Max',10,'SliderStep',[1/9,1/9],'Visible','off');

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
guidata(hObject,handles);



% --- Executes on slider movement.
function strel_Callback(hObject, ~, handles)
% hObject    handle to strel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
newval = floor(get(hObject,'Value'));
%if newval > 4 && newval ~= handles.Param.strel
handles.Param.strel = newval;
handles = proporfft(handles);
handles = affichproporfft(handles);
handles = trace_defo(handles);
set(handles.editstrel,'String',handles.Param.strel);
if get(handles.sizes,'Value') 
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);
  
end
handles = filter(handles);

% else
% end
guidata(hObject,handles);




% --- Executes on slider movement.
function window_Callback(hObject, ~, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

nl = round(get(hObject,'Value')/2)*2;


handles.Param.pas2 = nl;
if floor(handles.Param.pas2/2)==handles.Param.pas2/2
    handles.rec = handles.Param.pas2/2;
else
    handles.rec = (handles.Param.pas2-1)/2;
end

handles = calculregion(handles);
handles = affichim(handles);
KB=handles.Param.pas2^2/16*9.53674e-7*8;
KBwhole = KB*handles.regl;
set(handles.sizesub,'String',sprintf(['One image: ' num2str(floor(KBwhole)) ' MB']))
handles = affichim(handles);
handles = fftcalculus(handles);
handles = gaussfilt(handles);
handles = cutfun(handles);
handles = affichcutfft(handles);
handles = proporfft(handles);
handles = affichproporfft(handles);
handles = trace_defo(handles);
set(handles.enterwindow,'String',handles.Param.pas2);

if get(handles.sizes,'Value') 
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

end


handles = filter(handles);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function window_CreateFcn(hObject, ~, handles)
% hObject    handle to window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
set(hObject,'Min',20,'Max',1000,'SliderStep',[2/980,20/980]);

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
guidata(hObject,handles);

% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(~, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes on button press in OK.
function OK_Callback(hObject,~, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Val = get(hObject,'Value');
if Val == 1
    % Parameters = struct('propor',handles.propor,'cut',handles.cut,'strel',handles.strel,'sigma',handles.sigma,'pas2',handles.Param.pas2,'registering',handles.register);
    Parameters=handles.Param;
    save([handles.Param.pathout,'Param.mat'],'Parameters');
    
    savefig(handles.figure1,[handles.Param.pathout,'Parameters_fig.fig'])     % save image fig
    
    hgexport(handles.figure1,[handles.Param.pathout,'Parameters_fig.png'],hgexport('factorystyle'),'Format','png');
    
    close(handles.figure1);
    
    full_analysis(handles.Param);
    
end



% Hint: get(hObject,'Value') returns toggle state of OK



% --- Executes on button press in sizes.
function sizes_Callback(hObject, ~, handles)
% hObject    handle to sizes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sizes
handles.Param.sizeview = get(hObject,'Value');


if get(hObject,'Value')  

    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

    set(handles.defe1,'Visible','on')
    set(handles.defe2,'Visible','on')
    set(handles.defe3,'Visible','on')
    set(handles.defe1t,'Visible','on')
    set(handles.defe2t,'Visible','on')
    set(handles.defe3t,'Visible','on')

else

    handles = affichcutfft(handles);
    handles = trace_defo(handles);
    set(handles.defe1,'Visible','off')
    set(handles.defe2,'Visible','off')
    set(handles.defe3,'Visible','off')
    set(handles.defe1t,'Visible','off')
    set(handles.defe2t,'Visible','off')
    set(handles.defe3t,'Visible','off')
    set(handles.regsize,'Value',0)
    
end
guidata(hObject,handles);




% --- Executes on button press in regsize.
function regsize_Callback(hObject, ~, handles)
% hObject    handle to regsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of regsize
handles.Param.regsize = get(hObject,'Value');

guidata(hObject, handles);




% --- Executes on slider movement.
function slidersize_Callback(hObject, ~, handles)
% hObject    handle to slidersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.Param.nbpoints = round(get(hObject,'Value')/10)*10;
set(handles.editsize,'String',handles.Param.nbpoints);
if get(handles.sizes,'Value')
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

else
    handles = affichcutfft(handles);
    handles = trace_defo(handles);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slidersize_CreateFcn(hObject, ~, ~)
% hObject    handle to slidersize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
set(hObject,'Min',10,'Max',200,'SliderStep',[10/190,20/190],'Value',10,'Visible','off');

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes on button press in adv.
function adv_Callback(hObject, ~, handles)
% hObject    handle to adv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of adv
if get(hObject,'Value')
    set(handles.editstrel,'Visible','On')
    set(handles.regsize,'Visible','On')
    set(handles.textstrel,'Visible','On')
    set(handles.strel,'Visible','On')
    set(handles.text11,'Visible','On')
    set(handles.text18,'Visible','on')
    set(handles.sizes,'Visible','on')
    set(handles.slidersize,'Visible','on')
    set(handles.editsize,'Visible','on')
   
    handles = filter(handles);
    
else
    set(handles.editstrel,'Visible','Off')
    set(handles.regsize,'Visible','Off')
    set(handles.textstrel,'Visible','Off')
    set(handles.strel,'Visible','Off')
    set(handles.text18,'Visible','Off')
    
    set(handles.text11,'Visible','Off')
    set(handles.sizesstring,'Visible','off')
    set(handles.sizes,'Visible','off')
    set(handles.slidersize,'Visible','off')
    set(handles.editsize,'Visible','off')
    
    
end
guidata(hObject,handles);



function handles=calculregion(handles)

[handles.Posi,handles.regl,handles.Param] = Position_gui(handles.Param);

function handles=fftcalculus(handles)
% asubs contains the subimages we will use
FTs = avfft(handles.Param.name,handles.wins,handles.Param,handles.Posi);
handles.fftsub1 = reshape(FTs(1,:,:),handles.Param.pas2,handles.Param.pas2);
handles.fftsub2 = reshape(FTs(2,:,:),handles.Param.pas2,handles.Param.pas2);
handles.fftsub3 = reshape(FTs(3,:,:),handles.Param.pas2,handles.Param.pas2);


function handles = gaussfilt(handles)
filtre = gaussianFilter(ceil(2*handles.Param.sigma),handles.Param.sigma);
if ~isnan(filtre)
    handles.spsub1 = filter2(filtre,handles.fftsub1);
    handles.spsub2 = filter2(filtre,handles.fftsub2);
    handles.spsub3 = filter2(filtre,handles.fftsub3);
else
    handles.spsub1 =handles.fftsub1;
    handles.spsub2 =handles.fftsub2;
    handles.spsub3 =handles.fftsub3;
end




% --- Executes on slider movement.
function cut_Callback(hObject, ~, handles)
% hObject    handle to cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
newval = floor(get(hObject,'Value'));
if  newval ~= handles.Param.cut
    set(hObject,'Value',newval);
    handles.Param.cut=newval;
    handles = gaussfilt(handles);
    handles = cutfun(handles);
    handles = affichcutfft(handles);
    set(handles.editcut,'String',handles.Param.cut);
    
    
    if get(handles.sizes,'Value') 
        
        handles = ellipses_def(handles);
        handles = affichsize_ellipsdef(handles);
    end

end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cut_CreateFcn(hObject, ~, handles)
% hObject    handle to cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
set(hObject,'Min',0,'Max',30,'SliderStep',[1/30,1/30],'Value',1);

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
guidata(hObject,handles);


% --- Executes on button press in register.
function register_Callback(hObject, ~, handles)
% hObject    handle to register (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of register
handles.Param.register = get(hObject,'Value');
guidata(hObject, handles);




function sizesub_Callback(~, ~, ~)
% hObject    handle to sizesub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizesub as text
%        str2double(get(hObject,'String')) returns contents of sizesub as a double


% --- Executes during object creation, after setting all properties.
function sizesub_CreateFcn(hObject, ~, ~)
% hObject    handle to sizesub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = cutfun(handles)
handles.fftsubcut1 = handles.spsub1;
handles.fftsubcut2 = handles.spsub2;
handles.fftsubcut3 = handles.spsub3;
handles.fftsubcutnf1 = handles.fftsub1;
handles.fftsubcutnf2 = handles.fftsub2;
handles.fftsubcutnf3 = handles.fftsub3;
ic = handles.Param.pas2*1/2+1;
jc = handles.Param.pas2*1/2+1;
[I,J] = ndgrid(1:handles.Param.pas2,1:handles.Param.pas2);
M = double((I-ic).^2+(J-jc).^2<=(handles.Param.cut)^2);
handles.fftsubcut1(M>0) = 0;
handles.fftsubcut2(M>0) = 0;
handles.fftsubcut3(M>0) = 0;
handles.fftsubcutnf1(M>0) = 0;
handles.fftsubcutnf2(M>0) = 0;
handles.fftsubcutnf3(M>0) = 0;



function handles=affichcutfft(handles)

imagesc(handles.fftsubcut1,'Parent',handles.fft1cut)
axes(handles.fft1cut);
zoom(handles.Param.zoom)
set(handles.fft1cut,'Visible','off')

imagesc(handles.fftsubcut2,'Parent',handles.fft2cut)
axes(handles.fft2cut);
zoom(handles.Param.zoom)
set(handles.fft2cut,'Visible','off')

imagesc(handles.fftsubcut3,'Parent',handles.fft3cut)
axes(handles.fft3cut);
zoom(handles.Param.zoom)
set(handles.fft3cut,'Visible','off')



function handles=affichim(handles)

a = choose_image(handles.Param.name{1},handles.Anamesi,handles.Param.tstart);

if handles.image1 ~=0
    win1 = handles.image1;
    win2 = handles.image2;
    win3 = handles.image3;
elseif handles.regl == 1
    win1 = 1;
    win2 = 1;
    win3 = 1;
else
    win1 = floor(rand(1)*handles.regl)+1;
    win2 = floor(rand(1)*handles.regl)+1;
    win3 = floor(rand(1)*handles.regl)+1;
    
end

set(handles.num1,'String',['Number: ' num2str(win1)]);
set(handles.num2,'String',['Number: ' num2str(win2)]);
set(handles.num3,'String',['Number: ' num2str(win3)]);


x = handles.Posi(win1,1);
y = handles.Posi(win1,2);
handles.sub1=a(y:y+handles.Param.pas2-1,x:x+handles.Param.pas2-1);
imagesc(handles.sub1,'Parent',handles.im1);
set(handles.im1,'Visible','off')

x = handles.Posi(win2,1);
y = handles.Posi(win2,2);
handles.sub2=a(y:y+handles.Param.pas2-1,x:x+handles.Param.pas2-1);
imagesc(handles.sub2,'Parent',handles.im2)
set(handles.im2,'Visible','off')

x = handles.Posi(win3,1);
y = handles.Posi(win3,2);
handles.sub3=a(y:y+handles.Param.pas2-1,x:x+handles.Param.pas2-1);
imagesc(handles.sub3,'Parent',handles.im3)
set(handles.im3,'Visible','off')
handles.wins = [win1,win2,win3];


function handles = proporfft(handles)
ic = handles.Param.pas2/2+1;
jc = handles.Param.pas2/2+1;
[I,J] = ndgrid(1:handles.Param.pas2,1:handles.Param.pas2);
M = double((I-ic).^2+(J-jc).^2<=(handles.Param.cut)^2);

handles.fftsubcutsp1 = handles.fftsubcut1;
handles.fftsubcutsp2 = handles.fftsubcut2;
handles.fftsubcutsp3 = handles.fftsubcut3;


reshaped = reshape(handles.fftsubcutsp1,[handles.Param.pas2*handles.Param.pas2 ,1]);         % Colonnes par colonnes donc l'indexage en
[~,index]= sort(reshaped ,'descend');
nbel = handles.Param.propor * handles.Param.pas2*handles.Param.pas2;
if nbel > handles.Param.pas2*handles.Param.pas2
    nbel =  handles.Param.pas2*handles.Param.pas2;
end

handles.fftsubcutsp1(index(1:floor(nbel))) = 1;
handles.fftsubcutsp1(index(floor(nbel)+1:end)) = 0;

handles.fftsubcutsp1(M>0) = 1;

spsubcutfilt = handles.fftsubcutsp1;
B = false(handles.Param.pas2);
B(spsubcutfilt>0)=1;
se=strel('disk',handles.Param.strel);
handles.fftsubcutspse1=imclose(B,se);
spsubcutfilt =  handles.fftsubcutspse1;

norm = sum(sum((spsubcutfilt).^2));
[Yg,Xg]=meshgrid(1:(handles.Param.pas2),1:(handles.Param.pas2));
xc = handles.Param.pas2/2;
yc = handles.Param.pas2/2;
Xo = Xg-xc;
Yo = Yg-yc;
Y = (Yg-yc).^2; % Lignes
X = (Xg-xc).^2; % Colonnes
YY = sum(sum((spsubcutfilt).^2.*Y))/norm;
XX = sum(sum((spsubcutfilt).^2.*X))/norm;
XY = sum(sum((spsubcutfilt).^2.*Xo.*Yo))/norm;
handles.M1 = [XX,XY;XY,YY];

reshaped = reshape(handles.fftsubcutsp2,[handles.Param.pas2*handles.Param.pas2 ,1]);         % Colonnes par colonnes donc l'indexage en
[~,index]= sort(reshaped ,'descend');
nbel = handles.Param.propor * handles.Param.pas2*handles.Param.pas2;
if nbel > handles.Param.pas2*handles.Param.pas2
    nbel =  handles.Param.pas2*handles.Param.pas2;
else
end

handles.fftsubcutsp2(index(1:floor(nbel))) = 1;
handles.fftsubcutsp2(index(floor(nbel)+1:end)) = 0;
handles.fftsubcutsp2(M>0) = 1;

spsubcutfilt = handles.fftsubcutsp2;

B = false(handles.Param.pas2);
B(spsubcutfilt>0)=1;
se=strel('disk',handles.Param.strel);
handles.fftsubcutspse2=imclose(B,se);
spsubcutfilt =  handles.fftsubcutspse2;

norm = sum(sum((spsubcutfilt).^2));
[Yg,Xg]=meshgrid(1:(handles.Param.pas2),1:(handles.Param.pas2));
xc = handles.Param.pas2/2;
yc = handles.Param.pas2/2;
Xo = Xg-xc;
Yo = Yg-yc;
Y = (Yg-yc).^2; % Lignes
X = (Xg-xc).^2; % Colonnes
YY = sum(sum((spsubcutfilt).^2.*Y))/norm;
XX = sum(sum((spsubcutfilt).^2.*X))/norm;
XY = sum(sum((spsubcutfilt).^2.*Xo.*Yo))/norm;
handles.M2 = [XX,XY;XY,YY];

reshaped = reshape(handles.fftsubcutsp3,[handles.Param.pas2*handles.Param.pas2,1]);         % Colonnes par colonnes donc l'indexage en
[~,index]= sort(reshaped ,'descend');
nbel = handles.Param.propor * handles.Param.pas2*handles.Param.pas2;
if nbel > handles.Param.pas2*handles.Param.pas2
    nbel =  handles.Param.pas2*handles.Param.pas2;
else
end

handles.fftsubcutsp3(index(1:floor(nbel))) = 1;
handles.fftsubcutsp3(index(floor(nbel)+1:end)) = 0;
handles.fftsubcutsp3(M>0) = 1;

spsubcutfilt = handles.fftsubcutsp3;
B = false(handles.Param.pas2);
B(spsubcutfilt>0)=1;
se=strel('disk',handles.Param.strel);
handles.fftsubcutspse3=imclose(B,se);
spsubcutfilt =  handles.fftsubcutspse3;

norm = sum(sum((spsubcutfilt).^2));
[Yg,Xg]=meshgrid(1:(handles.Param.pas2),1:(handles.Param.pas2));
xc = handles.Param.pas2/2;
yc = handles.Param.pas2/2;
Xo = Xg-xc;
Yo = Yg-yc;
Y = (Yg-yc).^2; % Lignes
X = (Xg-xc).^2; % Colonnes
YY = sum(sum((spsubcutfilt).^2.*Y))/norm;
XX = sum(sum((spsubcutfilt).^2.*X))/norm;
XY = sum(sum((spsubcutfilt).^2.*Xo.*Yo))/norm;
handles.M3 = [XX,XY;XY,YY];

function handles = affichproporfft(handles)

imagesc(handles.fftsubcutsp1,'Parent',handles.fft1propor)
axes(handles.fft1propor);
zoom(handles.Param.zoom)
set(handles.fft1propor,'Visible','off')

imagesc(handles.fftsubcutsp2,'Parent',handles.fft2propor)
axes(handles.fft2propor);
zoom(handles.Param.zoom)
set(handles.fft2propor,'Visible','off')

imagesc(handles.fftsubcutsp3,'Parent',handles.fft3propor)
axes(handles.fft3propor);
zoom(handles.Param.zoom)
set(handles.fft3propor,'Visible','off')


function handles = trace_defo(handles)


handles.Param.scale=sqrt(2)*handles.Param.pas2/2;
xo =  handles.Param.pas2/2;
yo =  handles.Param.pas2/2;

[~,E] = eig(handles.M1);
L1 = 2*sqrt(E(2,2)/2);
L2 = 2*sqrt(E(1,1)/2);
lgE = 1/2*(log(L1/L2));
Dev = handles.M1-1/2*trace(handles.M1)*eye(2);
[V,~] = eig(Dev);
ang=atan(V(1,2)/V(2,2));
handles.angS1 = ang+pi/2;
handles.S1 = lgE;


x1 = xo+cos(ang+pi/2)*lgE*handles.Param.scale;
y1 = yo+sin(ang+pi/2)*lgE*handles.Param.scale;
x2 = xo-cos(ang+pi/2)*lgE*handles.Param.scale;
y2 = yo-sin(ang+pi/2)*lgE*handles.Param.scale;

X1 = [xo,x1];
Y1 = [yo,y1];
X2 = [xo,x2];
Y2 = [yo,y2];
set(handles.def1,'string',num2str(lgE*100,'%.0f'));
imagesc(handles.sub1,'Parent',handles.im1)
hold(handles.im1,'on');
plot(X1,Y1,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im1);
plot(X2,Y2,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im1);
set(handles.im1,'Visible','off')
hold(handles.im1,'off');


[~,E] = eig(handles.M2);
L1 = 2*sqrt(E(2,2)/2);
L2 = 2*sqrt(E(1,1)/2);
lgE = 1/2*(log(L1/L2));
Dev = handles.M2-1/2*trace(handles.M2)*eye(2);
[V,~] = eig(Dev);
ang=atan(V(1,2)/V(2,2));
handles.angS2 = ang+pi/2;
handles.S2 = lgE;



x1 = xo+cos(ang+pi/2)*lgE*handles.Param.scale;
y1 = yo+sin(ang+pi/2)*lgE*handles.Param.scale;
x2 = xo-cos(ang+pi/2)*lgE*handles.Param.scale;
y2 = yo-sin(ang+pi/2)*lgE*handles.Param.scale;

X1 = [xo,x1];
Y1 = [yo,y1];
X2 = [xo,x2];
Y2 = [yo,y2];
set(handles.def2,'string',num2str(lgE*100,'%.0f'));
imagesc(handles.sub2,'Parent',handles.im2)
hold(handles.im2,'on');
plot(X1,Y1,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im2);
plot(X2,Y2,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im2);
set(handles.im2,'Visible','off')
hold(handles.im2,'off');


[~,E] = eig(handles.M3);
L1 = 2*sqrt(E(2,2)/2);
L2 = 2*sqrt(E(1,1)/2);
lgE = 1/2*(log(L1/L2));
Dev = handles.M3-1/2*trace(handles.M3)*eye(2);
[V,~] = eig(Dev);
ang=atan(V(1,2)/V(2,2));
handles.angS3 = ang+pi/2;
handles.S3 = lgE;


x1 = xo+cos(ang+pi/2)*lgE*handles.Param.scale;
y1 = yo+sin(ang+pi/2)*lgE*handles.Param.scale;
x2 = xo-cos(ang+pi/2)*lgE*handles.Param.scale;
y2 = yo-sin(ang+pi/2)*lgE*handles.Param.scale;

X1 = [xo,x1];
Y1 = [yo,y1];
X2 = [xo,x2];
Y2 = [yo,y2];
set(handles.def3,'string',num2str(lgE*100,'%.0f'));
imagesc(handles.sub3,'Parent',handles.im3)
hold(handles.im3,'on');
plot(X1,Y1,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im3);
plot(X2,Y2,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im3);
set(handles.im3,'Visible','off')
hold(handles.im3,'off');

function handles = ellipses_def(handles)

abs_im_fft_w = handles.fftsubcutnf1;
[yu,xu] = localMaximum_h(abs_im_fft_w,1,0,handles.Param.nbpoints);
imagesc(handles.fftsubcut1,'Parent',handles.fft1cut)
hold(handles.fft1cut,'on');
plot(handles.fft1cut,xu,yu,'Marker','+','Color','black','MarkerSize',10,'LineStyle','none')

[~,~,ai,bi,phi,~]=ellipsefit(xu,yu);

f_ellipseplotax(ai,bi,handles.Param.pas2/2+1,handles.Param.pas2/2+1,phi,'red',2,handles.fft1cut);
handles.ai1 = ai;
handles.bi1 =bi;
handles.phi1 = phi;

axes(handles.fft1cut);
zoom(handles.Param.zoom)
hold(handles.fft1cut,'off');
set(handles.fft1cut,'Visible','off')


abs_im_fft_w = handles.fftsubcutnf2;
[yu,xu] = localMaximum_h(abs_im_fft_w,1,0,handles.Param.nbpoints);
imagesc(handles.fftsubcut2,'Parent',handles.fft2cut)
hold(handles.fft2cut,'on');
plot(handles.fft2cut,xu,yu,'Marker','+','Color','black','MarkerSize',10,'LineStyle','none')

[~,~,ai,bi,phi,~]=ellipsefit(xu,yu);

f_ellipseplotax(ai,bi,handles.Param.pas2/2+1,handles.Param.pas2/2+1,phi,'red',2,handles.fft2cut);
handles.ai2 = ai;
handles.bi2 =   bi;
handles.phi2 = phi;
axes(handles.fft2cut);
zoom(handles.Param.zoom)
hold(handles.fft2cut,'off');
set(handles.fft2cut,'Visible','off')


abs_im_fft_w = handles.fftsubcutnf3;
[yu,xu] = localMaximum_h(abs_im_fft_w,1,0,handles.Param.nbpoints);


imagesc(handles.fftsubcut3,'Parent',handles.fft3cut)
hold(handles.fft3cut,'on');
plot(handles.fft3cut,xu,yu,'Marker','+','Color','black','MarkerSize',10,'LineStyle','none')

[~,~,ai,bi,phi,~]=ellipsefit(xu,yu);

f_ellipseplotax(ai,bi,handles.Param.pas2/2+1,handles.Param.pas2/2+1,phi,'red',2,handles.fft3cut);
handles.ai3 = ai;
handles.bi3 =bi;
handles.phi3 = phi;
axes(handles.fft3cut);
zoom(handles.Param.zoom);
hold(handles.fft3cut,'off');
set(handles.fft3cut,'Visible','off')








function handles = affichsize_ellipsdef(handles)


handles.Param.scale=sqrt(2)*handles.Param.pas2/2;

xo =  handles.Param.pas2/4;
yo =  handles.Param.pas2/2;


amp =- 1/2*log(handles.bi1/handles.ai1);
ang = handles.phi1+pi/2;

set(handles.defe1,'string',num2str(amp*100,'%.0f'));


x1 = xo+cos(handles.angS1)*handles.S1*handles.Param.scale;
y1 = yo+sin(handles.angS1)*handles.S1*handles.Param.scale;
x2 = xo-cos(handles.angS1)*handles.S1*handles.Param.scale;
y2 = yo-sin(handles.angS1)*handles.S1*handles.Param.scale;

X1 = [xo,x1];
Y1 = [yo,y1];
X2 = [xo,x2];
Y2 = [yo,y2];


imagesc(handles.sub1,'Parent',handles.im1)
hold(handles.im1,'on')
%set(handles.im1,'xlim',[1 size(handles.sub1,2)],'ylim',[1 size(handles.sub1,1)])
plot(X1,Y1,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im1);
plot(X2,Y2,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im1);
f_ellipseplotax(handles.Param.pas2/2*1/handles.ai1,handles.Param.pas2/2*1/handles.bi1,xo+1/2*handles.Param.pas2,yo,handles.phi1,'red',2,handles.im1);
set(handles.im1,'Visible','off')
hold(handles.im1,'off');


amp =- 1/2*log(handles.bi2/handles.ai2);
ang = handles.phi2+pi/2;
set(handles.defe2,'string',num2str(amp*100,'%.0f'));





x1 = xo+cos(handles.angS2)*handles.S2*handles.Param.scale;
y1 = yo+sin(handles.angS2)*handles.S2*handles.Param.scale;
x2 = xo-cos(handles.angS2)*handles.S2*handles.Param.scale;
y2 = yo-sin(handles.angS2)*handles.S2*handles.Param.scale;

X1 = [xo,x1];
Y1 = [yo,y1];
X2 = [xo,x2];
Y2 = [yo,y2];

imagesc(handles.sub2,'Parent',handles.im2)
hold(handles.im2,'on');
plot(X1,Y1,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im2);
plot(X2,Y2,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im2);

f_ellipseplotax(handles.Param.pas2/2*1/handles.ai2,handles.Param.pas2/2*1/handles.bi2,xo+1/2*handles.Param.pas2,yo,handles.phi2,'red',2,handles.im2);

set(handles.im2,'Visible','off')
hold(handles.im2,'off');


amp = -1/2*log(handles.bi3/handles.ai3);
ang = handles.phi3+pi/2;
set(handles.defe3,'string',num2str(amp*100,'%.0f'));


x1 = xo+cos(handles.angS3)*handles.S3*handles.Param.scale;
y1 = yo+sin(handles.angS3)*handles.S3*handles.Param.scale;
x2 = xo-cos(handles.angS3)*handles.S3*handles.Param.scale;
y2 = yo-sin(handles.angS3)*handles.S3*handles.Param.scale;

X1 = [xo,x1];
Y1 = [yo,y1];
X2 = [xo,x2];
Y2 = [yo,y2];

imagesc(handles.sub3,'Parent',handles.im3)
hold(handles.im3,'on');
plot(X1,Y1,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im3);
plot(X2,Y2,'Marker','.','LineStyle','-','Color','red','LineWidth',3,'Parent',handles.im3);
f_ellipseplotax(handles.Param.pas2/2*1/handles.ai3,handles.Param.pas2/2*1/handles.bi3,xo+1/2*handles.Param.pas2,yo,handles.phi3,'red',2,handles.im3);
set(handles.im3,'Visible','off')
hold(handles.im3,'off');




function handles = filter(handles)
imagesc(handles.fftsubcutspse1,'Parent',handles.filt1);
axes(handles.filt1);
zoom(handles.Param.zoom)
set(handles.filt1,'Visible','off');

imagesc(handles.fftsubcutspse2,'Parent',handles.filt2);
axes(handles.filt2);
zoom(handles.Param.zoom)
set(handles.filt2,'Visible','off');

imagesc(handles.fftsubcutspse3,'Parent',handles.filt3);
axes(handles.filt3);
zoom(handles.Param.zoom)
set(handles.filt3,'Visible','off');





% --- Executes on button press in OKsize.
% function OKsize_Callback(hObject, eventdata, handles)
% % hObject    handle to OKsize (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % hObject    handle to OKsize (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% set(handles.OKsize,'String',handles.Param.nbpoints);
% guidata(hObject,handles);


% --- Executes on slider movement.
function zoom_Callback(hObject, ~, handles)
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.Param.zoom = get(hObject, 'Value');
handles = gaussfilt(handles);
handles = cutfun(handles);
handles = affichcutfft(handles);

handles = proporfft(handles);
handles = affichproporfft(handles);
handles = trace_defo(handles);

set(handles.editzoom,'String',handles.Param.zoom);

if get(handles.sizes,'Value')
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

    
end


handles = filter(handles);

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function zoom_CreateFcn(hObject, ~, ~)
% hObject    handle to zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
set(hObject,'Min',0,'Max',20,'SliderStep',[1/20,1/5],'Value',8);
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




function enterwindow_Callback(hObject, ~, handles)
% hObject    handle to enterwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enterwindow as text
%        str2double(get(hObject,'String')) returns contents of enterwindow as a double
handles.Param.pas2 =  str2double(get(hObject,'String'));
set(handles.window,'Value',handles.Param.pas2);
if floor(handles.Param.pas2/2)==handles.Param.pas2/2
    handles.rec = handles.Param.pas2/2;
else
    handles.rec = (handles.Param.pas2-1)/2;
end

handles = calculregion(handles);
handles = affichim(handles);
KB=handles.Param.pas2^2/16*9.53674e-7*8;
KBwhole = KB*handles.regl;
set(handles.sizesub,'String',sprintf(['One image: ' num2str(floor(KBwhole)) ' MB']))
handles = affichim(handles);
handles = fftcalculus(handles);
handles = gaussfilt(handles);
handles = cutfun(handles);
handles = affichcutfft(handles);
handles = proporfft(handles);
handles = affichproporfft(handles);
handles = trace_defo(handles);

if get(handles.sizes,'Value') 
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

end


handles = filter(handles);



guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function enterwindow_CreateFcn(hObject, ~, ~)
% hObject    handle to enterwindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editsigma_Callback(hObject, ~, handles)
% hObject    handle to editsigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editsigma as text
%        str2double(get(hObject,'String')) returns contents of editsigma as a double
newval = str2double(get(hObject,'String'));
handles.Param.sigma = newval;
handles = fftcalculus(handles);
handles = gaussfilt(handles);
handles = cutfun(handles);
handles = affichcutfft(handles);
set(handles.sigma,'Value',newval);
if get(handles.sizes,'Value')
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

end



guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function editsigma_CreateFcn(hObject, ~, ~)
% hObject    handle to editsigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editcut_Callback(hObject, ~, handles)
% hObject    handle to editcut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editcut as text
%        str2double(get(hObject,'String')) returns contents of editcut as a double
newval = str2double(get(hObject,'String'));
set(handles.cut,'Value',newval);
if  newval ~= handles.Param.cut
    set(hObject,'Value',newval);
    handles.Param.cut=newval;
    handles = gaussfilt(handles);
    handles = cutfun(handles);
    handles = affichcutfft(handles);
    if get(handles.sizes,'Value') 
        
        handles = ellipses_def(handles);
        handles = affichsize_ellipsdef(handles);

    end

end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editcut_CreateFcn(hObject, ~, ~)
% hObject    handle to editcut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editpropor_Callback(hObject, ~, handles)
% hObject    handle to editpropor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editpropor as text
%        str2double(get(hObject,'String')) returns contents of editpropor as a double
handles.Param.propor = str2double(get(hObject,'String'));
set(handles.propor,'Value',handles.Param.propor*10^3);
% handles.propor = handles.propor*10^-3;
handles = proporfft(handles);
handles = affichproporfft(handles);
handles = trace_defo(handles);

if get(handles.sizes,'Value') 
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

    
end

handles = filter(handles);


guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function editpropor_CreateFcn(hObject, ~, ~)
% hObject    handle to editpropor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editstrel_Callback(hObject, ~, handles)
% hObject    handle to editstrel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editstrel as text
%        str2double(get(hObject,'String')) returns contents of editstrel as a double
newval = str2double(get(hObject,'String'));
set(handles.strel,'Value',newval);
if newval > 4 && newval ~= handles.Param.strel
    handles.Param.strel = newval;
    handles = proporfft(handles);
    handles = affichproporfft(handles);
    handles = trace_defo(handles);
    if get(handles.sizes,'Value')
        
        handles = ellipses_def(handles);
        handles = affichsize_ellipsdef(handles);

    end
    handles = filter(handles);

end
guidata(hObject,handles);

%


% --- Executes during object creation, after setting all properties.
function editstrel_CreateFcn(hObject, ~, ~)
% hObject    handle to editstrel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editsize_Callback(hObject, ~, handles)
% hObject    handle to editsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editsize as text
%        str2double(get(hObject,'String')) returns contents of editsize as a double

handles.Param.nbpoints = str2double(get(hObject,'String'));

set(handles.slidersize,'Value',handles.Param.nbpoints);
if get(handles.sizes,'Value') 
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

end


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editsize_CreateFcn(hObject, ~, ~)
% hObject    handle to editsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editzoom_Callback(hObject, ~, handles)
% hObject    handle to editzoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editzoom as text
%        str2double(get(hObject,'String')) returns contents of editzoom as a double
handles.Param.zoom = str2double(get(hObject, 'String'));
handles = gaussfilt(handles);
handles = cutfun(handles);
handles = affichcutfft(handles);

handles = proporfft(handles);
handles = affichproporfft(handles);
handles = trace_defo(handles);

set(handles.zoom,'Value',handles.Param.zoom);

if get(handles.sizes,'Value') 
    
    handles = ellipses_def(handles);
    handles = affichsize_ellipsdef(handles);

end


handles = filter(handles);

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function editzoom_CreateFcn(hObject, ~, ~)
% hObject    handle to editzoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes during object creation, after setting all properties.
function def1_CreateFcn(hObject, ~,~)
% hObject    handle to def1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes during object creation, after setting all properties.
function defe1_CreateFcn(hObject, ~, ~)
% hObject    handle to defe1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes during object creation, after setting all properties.
function def2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to def2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function defe2_CreateFcn(hObject, ~,~)
% hObject    handle to defe2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function def3_CreateFcn(hObject, ~, ~)
% hObject    handle to def3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function defe3_CreateFcn(hObject, ~,~)
% hObject    handle to defe3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
