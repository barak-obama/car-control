function y = comphumangui(color,playernum,defaulttype)
%COMPHUMANGUI Animated computer/human gui prompt.
%   Y = COMPHUMANGUI(COLOR,PLAYERNUM,DEFAULTTYPE) prompts the user to
%   select a player type (computer/human). COLOR is the base color of the
%   window background, PLAYERNUM is the number of the player, and
%   DEFAULTTYPE is the initially selected player type (can be either
%   'human' or 'computer'). If DEFAULTTYPE is not specified, the initial
%   player type is 'human'. The returned Y is one of the strings 'Computer'
%   or 'Human'. If the window is closed, Y is set to [].

%  Ron Rubinstein
%  Computer Science Department
%  Technion, Haifa 32000 Israel
%  ronrubin@cs.technion.ac.il
%
%  September 2010


% default player type
if (nargin<3)
  defaulttype = 'human';
end
if strcmpi(defaulttype,'human')
  humandefault = 1;
elseif strcmpi(defaulttype,'computer')
  humandefault = 0;
else
  error('invalid default type');
end

% create window
hfig = figure; 
set(hfig,'Visible','off');
set(hfig,'Units','pixels'); 
set(hfig,'Position',[1 1 520 360]);
set(hfig,'Name','Scorched Earth');
set(hfig,'MenuBar','none');
set(hfig,'NumberTitle','off');
set(hfig,'WindowStyle','modal');
set(hfig,'DockControls','off');
set(hfig,'Resize','off');

% center window on screen
centerobj(hfig);

% show image
res = [240 320];
im = cat(3,ones(res)*color(1),ones(res)*color(2),ones(res)*color(3));
lines = ones(res(1),1)*kron([9.5 9:-1:0 1:9]/10,ones(1,res(2)/20));
im = im.*cat(3,lines,lines,lines);
him = image(im);

% maximize image in window
haxis = gca; axis off; 
set(haxis,'Position',get(haxis,'OuterPosition'));

hPanel = uipanel('Parent',hfig,'Units','pixels','Position',[1 1 230 100],'BorderType','beveledout');
centerobj(hPanel);

uicontrol('Parent',hPanel,'style','text','String',sprintf('Player %d:',playernum),'FontSize',10,...
  'FontName','FixedWidth','Units','pixels','Position',[30 54 90 20],'HorizontalAlignment','left');

hButtons = uibuttongroup('Parent',hPanel,'Units','pixels','BorderType','none',...
  'Position',[20 20 150 50]);
hHuman = uicontrol('Parent',hButtons,'style','radiobutton','String','Human','FontSize',10,'Units','pixels',...
  'FontName','FixedWidth','Position',[10 1 100 20]);
hComp = uicontrol('Parent',hButtons,'style','radiobutton','String','Computer','FontSize',10,'Units','pixels',...
  'FontName','FixedWidth','Position',[100 1 100 20]);

if humandefault
  set(hButtons,'SelectedObject',hHuman);
else
  set(hButtons,'SelectedObject',hComp);
end

uicontrol('Parent',hPanel,'style','pushbutton','String','OK','Units','pixels','Position',[130 55 70 23],...
  'FontName','FixedWidth','callback',@ok_fcn);


% make window visible
set(hfig,'Visible','on');

T = timer('TimerFcn',@updatebg,'Period',0.03,'ExecutionMode','FixedRate','TasksToExecute',inf,'UserData',him);

start(T); 
uiwait;
stop(T);

if (ishandle(hfig))
  y = get(get(hButtons,'selectedobject'),'String');
  close(hfig);
else
  y = [];
end

end


function updatebg(obj,evt)
him = get(obj,'UserData');
if (ishandle(him))
  set(him,'CData',circshift(get(him,'CData'),[0,-8,0]));
  drawnow;
end
end


function ok_fcn(hObject, eventdata, handles)
uiresume;
end
