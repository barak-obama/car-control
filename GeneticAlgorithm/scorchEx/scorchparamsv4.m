function [varargout] = scorchparamsv4(vernum,varargin)
%SCORCHPARAMSV4 Prompt for SCORCH game parameters.
%   [PARAM1,PARAM2,...] = 
%    SCORCHPARAMSV4(VERNUM,PARAMNAME1,PARAMVALS1,PARAMNAME2,PARAMVALS2,...)
%   prompts the user for SCORCH game parameters. VERNUM is the version of
%   SCORCH, used for display purposes. For each parameter, two arguments
%   are specified: PARAMNAME<i> is a string describing the parameter (up to
%   15 characters) and PARAMVALS<i> is a 3-element array containing the
%   minimum, maximum and initial slider values, respectively. A fourth
%   element may optionally be provided for specifying the step size when
%   clicking on the slider bar. The returned PARAM<i> is the user-selected
%   value for the corresponding parameter.
%
%   Notes:
%   1. Up to 5 different parameters may be specified.
%   2. If the window is closed, all output arguments are set to [].
%   3. All parameter values (min, max, init, step size) must be integers.


%  Ron Rubinstein
%  Computer Science Department
%  Technion, Haifa 32000 Israel
%  ronrubin@cs.technion.ac.il
%
%  September 2010


maxparams = 5;


% parse function parameters
paramnames = cell(0);
paramvals = cell(0);
paramnum = 0;
for i = 1:2:length(varargin)
  paramnum = paramnum+1;
  paramnames{paramnum} = varargin{i};
  paramvals{paramnum} = varargin{i+1};
end

if (paramnum>maxparams)
  error('Too many parameters specified');
end


% create the dialog box
h = dialog('Name','Welcome to Scorched Earth !','Units','pixels','Tag','scorchparamsdlg','Position',[1 1 721 497]);
centerobj(h);

% game settings panel
hPanel = uipanel('Parent',h,'Units','pixels','Position',[10 50 205 437]);

% scorched earth image
hImage = axes('parent',h,'units','pixels','position',[225 50 486 437]);
im = imread('scorched.png');
imshow(im,'parent',hImage);

% version text
uicontrol('Parent',h,'style','text','String',sprintf('Version %d\n Copyright (c) 2010 Ron Rubinstein',vernum),'Units','pixels',...
  'FontName','FixedWidth','FontSize',10,'Position',[225 10 486 30],'HorizontalAlignment','Center');

% start button 
uicontrol('Parent',hPanel,'style','pushbutton','String','Start!','Units','pixels','Position',[20 390 100 28],...
  'FontName','FixedWidth','FontSize',10,'callback',@go_fcn);



% slider handles
hSliders = zeros(1,paramnum);

for i = 1:paramnum
  
  slidername = paramnames{i};
  slidervals = paramvals{i};
  
  minslider = slidervals(1);
  maxslider = slidervals(2);
  initslider = slidervals(3);
  
  if (numel(slidervals)>3)
    sliderstep = slidervals(4);
  else
    sliderstep = 1;
  end
  
  vpos = 315 - 68*(i-1);
  
  % slider
  hSliders(i) = uicontrol('Parent',hPanel,'style','slider','Units','pixels','Position',[20 vpos 160 18],...
    'Tag',sprintf('slider%d',i),'SliderStep',[1 sliderstep]./(maxslider-minslider),'Callback',@slider_callback,...
    'Min',minslider,'Max',maxslider,'Value',initslider,'UserData',i);
  
  % slider text
  uicontrol('Parent',hPanel,'style','text','String',sprintf('%s:',slidername),'FontSize',10,'Units','pixels',...
    'FontName','FixedWidth','Position',[20 vpos+21 145 20],'HorizontalAlignment','left');
  
  % num of players text
  uicontrol('Parent',hPanel,'style','text','String',sprintf('%d',initslider),'Units','pixels',...
    'FontName','FixedWidth','FontSize',10,'Position',[145 vpos+21 30 20],'Tag',sprintf('slider%dtext',i),'HorizontalAlignment','right');
  
end

set(h,'UserData',paramnum);
set(h,'WindowButtonMotionFcn',@windowmotion_callback);

% trick: force initialization of the persistent variable in the callback function
windowmotion_callback(h,[],1);

uiwait(h);

if (ishandle(h))
  for i = 1:paramnum
    varargout{i} = getsliderval(h,i);
  end
  close(h);
else
  for i = 1:paramnum
    varargout{i} = [];
  end
end

end


%%% slider callback functions %%%

function slider_callback(hObject, eventdata, handles)

sliderval = get(hObject, 'Value');
sliderval = round(sliderval);
slidernum = get(hObject,'UserData');
setslidertext(get(hObject,'Parent'),slidernum,sliderval);

end

function sliderval = getsliderval(hObject,slidernum)

sliderval = get(findobj(hObject,'Tag',sprintf('slider%d',slidernum)), 'Value');
sliderval = round(sliderval);

end

function setslidertext(hObject,slidernum,n)

set(findobj(hObject,'Tag',sprintf('slider%dtext',slidernum)),'String',sprintf('%d',n));

end


%%% figure callback functions %%%

function windowmotion_callback(hObject,eventdata,init)

persistent slidervals

paramnum = get(hObject,'UserData');

% initialize slider values
if (nargin>2 && init)
  slidervals = zeros(paramnum,1);
  for i = 1:paramnum
    slidervals(i) = getsliderval(hObject,i);
  end
end

% check for any change in slider values
for i = 1:paramnum
  newsliderval = getsliderval(hObject,i);
  if (newsliderval~=slidervals(i))
    setslidertext(hObject,i,newsliderval);
    slidervals(i) = newsliderval;
  end
end

end


%%% start button callback functions %%%

function go_fcn(hObject, eventdata, handles)

uiresume;

end
