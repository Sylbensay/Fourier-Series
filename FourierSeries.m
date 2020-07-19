function varargout = Fourier_Series(varargin)
% FOURIER_SERIES M-file for Fourier_Series.fig
%      FOURIER_SERIES, by itself, creates a new FOURIER_SERIES or raises the existing
%      singleton*.
%cl
%      H = FOURIER_SERIES returns the handle to a new FOURIER_SERIES or the handle to
%      the existing singleton*.
%
%      FOURIER_SERIES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOURIER_SERIES.M with the given input arguments.
%
%      FOURIER_SERIES('Property','Value',...) creates a new FOURIER_SERIES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Fourier_Series_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Fourier_Series_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Fourier_Series

% Last Modified by GUIDE v2.5 25-Sep-2018 13:57:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fourier_Series_OpeningFcn, ...
                   'gui_OutputFcn',  @Fourier_Series_OutputFcn, ...
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


% --- Executes just before Fourier_Series is made visible.
function Fourier_Series_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Fourier_Series (see VARARGIN)

% Choose default command line output for Fourier_Series
handles.output = hObject;

handles.An='sin(pi*n/2)/(pi*n/2)';
handles.Bn='0';
set(handles.edit1,'String',handles.An)
set(handles.edit2,'String',handles.Bn)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Fourier_Series wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Fourier_Series_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
A0=get(handles.A0Box,'Value');
An=get(handles.edit1,'String');
%An=An{1};
Bn=get(handles.edit2,'String');
%Bn=Bn{1};
N=get(handles.NumHarmonicsBox,'Value');
T=get(handles.PeriodBox,'Value');
terms=get(handles.radiobutton_plotterms,'Value');
if (get(handles.popupmenu1,'Value')==1),
    [t,x,s]=trig_fs_fn(A0,An,Bn,N,T,terms);
elseif (get(handles.popupmenu1,'Value')==2),
    [t,x,s]=trig_fs_fn(A0,sprintf('%s*cos(%s)',An,Bn),...
        sprintf('-%s*sin(%s)',An,Bn),N,T,terms);
elseif (get(handles.popupmenu1,'Value')==3),
    [t,x,s]=exp_fs_fn(A0,An,N,T,terms);
end

if get(handles.HoldGraphs,'Value')
    hold(handles.axes1,'on');
    hold(handles.axes2,'on');
    hold(handles.axes3,'on');
else
    hold(handles.axes1,'off');
    hold(handles.axes2,'off');
    hold(handles.axes3,'off');
end


% Plot time-domain signal
plot(handles.axes1,t,real(x));
if (max(abs(imag(x(:))))*100>=max(abs(real(x(:)))))
    ih=ishold(handles.axes1);
    hold(handles.axes1,'on');
    plot(handles.axes1,t,imag(x),'--');
    if ~ih 
        hold(handles.axes1,'off');
    end
end
        
    
    
grid(handles.axes1,'on');

% Plot Spectrum
if get(handles.SpectrumUnitsHz,'Value')
    fscale=1/(2*pi);
else
    fscale=1;
end;

if get(handles.SpectrumTypeMagPhase,'Value')
    % Magnitude/Phase form
    stem(handles.axes2,s(2,:)*fscale,abs(s(1,:)),'filled');
    grid(handles.axes2,'on');
    title(handles.axes2,'Magnitude Spectrum');
    stem(handles.axes3,s(2,:)*fscale,angle(s(1,:)),'filled');
    grid(handles.axes3,'on');
    title(handles.axes3,'Phase Spectrum');
else
    % Real/Imaginary or An/Bn
    stem(handles.axes2,s(2,:)*fscale,real(s(1,:)),'filled');
    grid(handles.axes2,'on');
    title(handles.axes2,'Real or Cosine Spectrum');
    stem(handles.axes3,s(2,:)*fscale,imag(s(1,:)),'filled');
    grid(handles.axes3,'on');
    title(handles.axes3,'Imaginary or Sine Spectrum');
end

if get(handles.SpectrumUnitsHz,'Value')
    xlabel(handles.axes2,'Hz');
    xlabel(handles.axes3,'Hz');
else
    xlabel(handles.axes2,'radians/s');
    xlabel(handles.axes3,'radians/s');
end

    
    





function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
n=1;
str=lower(get(hObject,'String'));
try
    eval(str);
catch
    set(hObject,'String',handles.An)
    errordlg([str ' is not a valid MATLAB expression. Use n for the variable.'],'Doh!')
end
handles.An=get(hObject,'String');
set(handles.predefined_menu,'Value',3);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

n=1;
str=lower(get(hObject,'String'));
try
    eval(str);
catch
    set(hObject,'String',handles.Bn)
        errordlg([str ' is not a valid MATLAB expression. Use n for the variable.'],'Doh!')
end
handles.Bn=get(hObject,'String');
set(handles.predefined_menu,'Value',3);
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

val=get(hObject,'Value');
if (val==3)
    set(handles.edit2,'Enable','off');
    set(handles.text5,'String','d_0');
    set(handles.text3,'String','d_n');
    set(handles.text4,'String','');
elseif (val==2)
    set(handles.edit2,'Enable','on');
    set(handles.text5,'String','C_0');
    set(handles.text3,'String','C_n');
    set(handles.text4,'String','theta_n');
elseif (val==1)
    set(handles.edit2,'Enable','on');
    set(handles.text5,'String','A_0');
    set(handles.text3,'String','A_n');
    set(handles.text4,'String','B_n');
end

predefined_menu_Callback(handles.predefined_menu,[],handles)

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu1.
function popupmenu1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function NumHarmonicsBox_Callback(hObject, eventdata, handles)
% hObject    handle to NumHarmonicsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumHarmonicsBox as text
%        str2double(get(hObject,'String')) returns contents of NumHarmonicsBox as a double

val = str2double(get(hObject,'String'));

% Determine whether val is a number between 0 and 1.
if (isnumeric(val) && length(val)==1 && val >= 0 && val <= 100)
   set(hObject,'Value',round(val));
end
set(hObject,'String',num2str(get(hObject,'Value')));




% --- Executes during object creation, after setting all properties.
function NumHarmonicsBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumHarmonicsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A0Box_Callback(hObject, eventdata, handles)
% hObject    handle to A0Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A0Box as text
%        str2double(get(hObject,'String')) returns contents of A0Box as a double

val = str2double(get(hObject,'String'));

% Determine whether val is a number 
if (isnumeric(val) && length(val)==1)
   set(hObject,'Value',val);
end
set(hObject,'String',num2str(get(hObject,'Value')));


% --- Executes during object creation, after setting all properties.
function A0Box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A0Box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PeriodBox_Callback(hObject, eventdata, handles)
% hObject    handle to PeriodBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PeriodBox as text
%        str2double(get(hObject,'String')) returns contents of PeriodBox as a double

val = str2double(get(hObject,'String'));

% Determine whether val is a number 
if (isnumeric(val) && length(val)==1)
   set(hObject,'Value',val);
end
set(hObject,'String',num2str(get(hObject,'Value')));


% --- Executes during object creation, after setting all properties.
function PeriodBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PeriodBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in predefined_menu.
function predefined_menu_Callback(hObject, eventdata, handles)
% hObject    handle to predefined_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns predefined_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from predefined_menu

switch get(hObject,'Value')
    case 1,
        % Put square wave coefficients into the coefficient fields
        switch get(handles.popupmenu1,'Value')
            case 1
                % Trigonometric FS case
                set(handles.A0Box,'Value',0.5);
                set(handles.A0Box,'String','0.5');
                handles.An='sin(pi*n/2)/(pi*n/2)';
                handles.Bn='0';
            case 2
                % Harmonic FS case
                set(handles.A0Box,'Value',0.5);
                set(handles.A0Box,'String','0.5');
                handles.An='abs(sin(n*pi/2)/(n*pi/2))';
                handles.Bn='atan2(0,sin(n*pi/2)/(n*pi/2))';

            case 3
                % Complex FS case
                set(handles.A0Box,'Value',0.5);
                set(handles.A0Box,'String','0.5');
                handles.An='sin(pi*n/2)/(pi*n)';
                handles.Bn='0';
        end
        
    case 2
        % Put Triangle wave coefficients into the coefficient fields
        switch get(handles.popupmenu1,'Value')
            case 1
                % Trigonometric FS case
                set(handles.A0Box,'Value',0.5);
                set(handles.A0Box,'String','0.5');
                handles.An='0';
                handles.Bn='4*sin(pi*n/2)/(pi^2*n^2)';
            case 2
                % Harmonic FS case
                set(handles.A0Box,'Value',0.5);
                set(handles.A0Box,'String','0.5');
                handles.An='abs(4*sin(pi*n/2)/(pi^2*n^2))';
                handles.Bn='atan2(-4*sin(pi*n/2)/(pi^2*n^2),0)';
            case 3
                % Complex FS case
                set(handles.A0Box,'Value',0.5);
                set(handles.A0Box,'String','0.5');
                handles.An='2*sin(pi*n/2)/(j*pi^2*n^2)';
                handles.Bn='0';
        end
        
    case 3
        % Don't do anything
end

set(handles.edit1,'String',handles.An)
set(handles.edit2,'String',handles.Bn)
if get(hObject,'Value')<3
    for n=1:2,
        set(handles.edit1,'ForegroundColor',[1 0 0]);
        set(handles.edit2,'ForegroundColor',[1 0 0]);
        pause(0.125);
        set(handles.edit1,'ForegroundColor',[0 0 0]);
        set(handles.edit2,'ForegroundColor',[0 0 0]);
        pause(0.125)
    end
end
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function predefined_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to predefined_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in HoldGraphs.
function HoldGraphs_Callback(hObject, eventdata, handles)
% hObject    handle to HoldGraphs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of HoldGraphs
