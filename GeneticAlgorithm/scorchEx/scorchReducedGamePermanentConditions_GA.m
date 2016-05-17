function scorchReducedGamePermanentConditions_GA(BestChromosomes,Parameters)
% Third revised version - 
% 1) user parameters are set to default (wind - max
% 50, players - 2 (human and computer), and so is the level of diffuculty
% and the blast size.
% 2) no partial reduction in power, no changes in the terrain during the
% game.
% 3) has additional inputs:
%SCORCH Scorched earth game, version 14.
%
%  SCORCH is a simple Matlab re-creation of Wendell Hicken's classic
%  Scorched Earth game. The game demonstrates some of Matlab's realtime
%  user interface and animation abilities. Note that this is an ongoing
%  project, and currently implements only the very basic functionality of
%  the original game.
%
%  Usage: Enter SCORCH at the Matlab prompt.
%
%  Game controls:
%
%    Power: page up/down (fast), or up/down arrows (fine)
%    Angle: left/right arrows (fast), or shift + left/right arrows (fine)
%    Fire: space
%
%  New in this verion:
%
%    1. Improved computer strategy: targets a tank, adds error on x-axis,
%    computes trajectory and shoots. Distortion decreases with each round.
%    Also, if tank falls or the targetted tank falls, distortion increases
%    proportionally to the motion distance, to simulate calibration loss.
%    Also, if no clear path is found, the computer selects the trajectory
%    passing through the least amount of land.
% 
%    2. Max wind and missle size are now user-selectable.
%
%    3. Simulation step size and animation step size are decoupled to allow
%    separate control of simulation accuracy and animation speed.
%
%    4. Game window size now matches world size, instead of scaling down
%    the world to the window size.


%  Ron Rubinstein
%  Computer Science Department
%  Technion, Haifa 32000 Israel
%  ronrubin@cs.technion.ac.il
%
%  September 2010

global params status tanks terrain tankmap

params.version = 14;                        % version number
params.screensize = [800 600];              % world size


%%% terrain generation %%%

params.bumpiness = 7;                       % terrain bumpiness
params.terrainheight = 0.7;                 % maximal terrain height (proportional to height of screen)


%%% color parameters %%%

params.skycolor = [0.9 0.9 1];              % color of sky
params.terraincolor = [0.6 0.5 0.2];        % color of terrain
params.fallenterraincolor = [0.6 0.5 0.2];  % color of fallen terrain


%%% environment and physics %%%
%!!!!!!
params.gravity = 300;                       % gravity strength


%%% tank geometry %%%

params.tanksize = 17;                       % tank width in pixels
params.canonsize = params.tanksize*1.6;     % length of tank canon


%%% angle and power %%%

params.smallangstep = 1;                    % angle step size when pressing arrow+shift
params.largeangstep = 4;                    % angle step size when pressing arrow
params.minangle = 0;                        % minimal canon angle
params.maxangle = 180;                      % maximum canon angle
params.initangle = 49;                      % initial canon angle (automatically flipped towards screen center)

params.initpower = 200;                     % initial firing power
params.smallpwrstep = 1;                    % power step size when pressing arrow+shift
params.largepwrstep = 31;                   % power step size when pressing arrow
params.minpower = 0;                        % minimal firing power
params.maxpower = 1000;                     % maximal firing power


%%% simulation parameters %%%

params.simulationdelta = 0.004;             % time step for simulation of missle flight
params.tmax = 15;                           % maximum simulation time


%%% animation parameters %%%

params.misslesize = 13;                     % size of missle marker in animation
params.animstepsize = 8;                    % amount of simulation steps between sequential animation frames (larger = faster animation)
params.fallpauselen = 0.01;                 % pause time when animating falls (larger = slower animation)


%%% explosion animation %%%

params.firecolornum = 32;                   % number of distinct colors in fire animation (tank explosion)
params.lavacolornum = 32;                   % number of distinct colors in lava animation (missle explosion)
params.blastanimdelta = 0.03;               % time in seconds between blast animation frames
params.lavapixpersec = 150;                 % speed of lava ball expansion (in pixels per second)
params.lavaremaintime = 1;                  % num of seconds for lava animation after reaching full size
params.fireanimtime = 1.5;                  % num of seconds for fire animation


%%% computer play animation %%%

params.computerpausebefore = 0.15;          % pause time before computer shoots
params.computerpauseafter  = 0.15;          % pause time after computer shoots


%%% tank falling parameters %%%

params.tankfallthresh = 0.7;                % fraction of empty ground under tank in one side to fall to that side
params.falldrainfactor = 0.6;               % factor between fall distance and power reduction


%%% computer strategy %%%

params.mindistortion = 30;                  % minimum error in x-axis (highest computer level)
params.maxdistortion = 150;                 % maximum error in x-axis (lowest computer level)
params.distortionchange = 0.75;             % decrease in distortion each turn (lower = stronger computer)
params.resetdistortiondist = 0.1;           % if tank move this distance due to a fall (relative to screen diagonal),
                                            % distortion is reset to initial. smaller move also increases distortion proportionally

                                            
%%% user-set parameters %%%

params.minplayers = 2;
params.maxplayers = 8;
params.initplayers = 2;

params.mincomplev = 1;
params.maxcomplev = 10;
params.initcomplev = 5;

params.maxwind = 100;
params.initwind = 50;
params.windstep = 5;

params.minblastsize = 20;
params.maxblastsize = 300;
params.initblastsize = 60;
params.blastsizestep = 10;
params.mintankblastsize = 100;              % tank blast size is at least this size


%%% end parameters %%%

% I commented - only use the default paramters set above
% get game parameters
% [params.tanknum, complev, blastsize, maxwind] = scorchparamsv4(params.version,...
%   'Players', [params.minplayers params.maxplayers params.initplayers], ...
%   'Computer level', [params.mincomplev params.maxcomplev params.initcomplev], ...
%   'Explosion size', [params.minblastsize params.maxblastsize params.initblastsize params.blastsizestep], ...
%   'Max wind', [0 params.maxwind params.initwind params.windstep]);

params.tanknum = params.initplayers; % I added
complev = params.initcomplev; % I added
maxwind = params.initwind; % I added
blastsize = params.initblastsize; % I added

% parameter window was closed
if (isempty(params.tanknum))
  return;
end


% blast size
params.missleblastsize = blastsize;
params.tankblastsize = max(blastsize,params.mintankblastsize);

% min and max lava pattern comlexity (=number of "blobs" in each dimension)
% set as a function of blast size
[params.minlavacomplexity, params.maxlavacomplexity] = lavacomplexity(blastsize);

% generate random wind (from -maxwind to +maxwind)
status.wind = ceil(rand(1)*(maxwind+1)) - 1;
status.wind = status.wind * ((rand(1)>0.5)*2 - 1);

% current player
status.currtank = 1;

% parse computer difficulty
complev = (complev-params.mincomplev) / (params.maxcomplev-params.mincomplev);
params.initdistortion = round( (1-complev)*(params.maxdistortion-params.mindistortion) + params.mindistortion );
% printf('Computer difficulty settings: initial distortion = %d', params.initdistortion);

% I changed - added Path - the y path of the 'mountains' in the surronding
[terrain Path] = randterrain(params);

tankcolors = jet(params.maxplayers);

% permute tank colors for maximal difference between sequential colors
maxplayers_even = round(params.maxplayers/2+0.1)*2;
perm = reshape([1:maxplayers_even/2 ; maxplayers_even/2+1:maxplayers_even],1,[]);
tankcolors = tankcolors(perm,:);

tanknames = { 'Bob', 'Joe', 'Ralph', 'Fred', 'Max', 'George', 'Wolfgang', 'Pepe', 'Ronald', ...
  'Arnold', 'Chuck', 'Doug', 'Edward', 'Hank', 'Jacque', 'Lou', 'Norm', 'Otto', 'Ted', 'Ajax', 'Sam', ...
  'Frank', 'Bubba', 'Biff', 'Leroy', 'Newton', 'Galileo', 'Bach', 'Mozart', 'Gilligan', 'Saddam', ...
  'Atilla', 'Tito', 'Castro', 'Khadafi', 'Amin', 'Cleopatra', 'Mussolini', 'Napolean', 'Juan', ...
  'Barbarella', 'Antoinette', 'Helen', 'Elizabeth', 'Mary', 'Diane', 'Zoe', 'Persephone', 'Esther', ...
  'Rose', 'Mata', 'Hari', 'Moria', 'Bethsheba', 'Jezebel', 'Guineverre', 'Godiva', 'Medusa', 'Elvira', ...
  'Roseanne', 'Sonja', 'Charo', 'Cher', 'Madonna', 'Grace', 'Bubbles', 'Tiffany', 'Angie' };

tankorder = randperm(params.tanknum);
nameids = randperm(length(tanknames));

tanks = cell(1,params.tanknum);
prevtype = 'human';  % type of previous player (human/computer) - begin with human

for i = 1:params.tanknum
  
  tanks{i}.x = round( params.screensize(1)*(0.1 + (tankorder(i)-1)/(params.tanknum-1)*0.8) );
  tanks{i}.y = find(terrain(:,tanks{i}.x),1,'last');
  tanks{i}.angle = params.initangle;
  if (tanks{i}.x>params.screensize(1)/2)
    tanks{i}.angle = min(max(180-tanks{i}.angle,params.minangle),params.maxangle);
  end
  
  tanks{i}.power = params.initpower;
  tanks{i}.maxpower = params.maxpower;
  tanks{i}.color = tankcolors(i,:);
  tanks{i}.name = tanknames{nameids(i)};
  % I commented - one human player and one computer player
  %playertype = comphumangui(tanks{i}.color,i,prevtype);
  if i==1 % I changed
    tanks{i}.ishuman = 1;
    prevtype = 'human';
  elseif i==2 % I changed
    tanks{i}.ishuman = 0;
    prevtype = 'computer';
  else
    return;
  end
  
end

% select current enemy for each computer player
for i = 1:params.tanknum
  if (tanks{i}.ishuman), continue; end
  tanks{i}.currenemy = selectenemy(tanks,i);
  tanks{i}.currdistortion = params.initdistortion;
end

%flatten terrain under tanks
for i = 1:params.tanknum
  terrain(tanks{i}.y:end, tanks{i}.x-ceil(params.tanksize/1.9):tanks{i}.x+ceil(params.tanksize/1.9)) = 0;
  terrain(1:tanks{i}.y-1, tanks{i}.x-ceil(params.tanksize/2):tanks{i}.x+ceil(params.tanksize/2)) = 1;
end


% I added - use the default parameters
tanks{1}.x = Parameters.xTank; tanks{1}.y = Parameters.yTank;  tanks{2}.x = Parameters.xEnemy;  tanks{2}.y = Parameters.yEnemy;
params.tanksize = 17; params.canonsize = 27.2;status.wind = Parameters.wind;
params.gravity = Parameters.gravity;
params.simulationdelta = Parameters.simulationdelta;params.tmax = Parameters.tmax;terrain = Parameters.LandSky;
params.missleblastsize = Parameters.blastrad*3;


tankmap = rendertanks(tanks, params);

status.hfig = figure;

set(status.hfig,'Visible','off');

set(status.hfig,'Position',[1 1 params.screensize]);
centerobj(status.hfig);

set(status.hfig,'MenuBar','none');
set(status.hfig,'Name','Scorched Earth');
set(status.hfig,'NumberTitle','off');
set(status.hfig,'DockControls','off');

set(status.hfig,'Interruptible','off');
set(status.hfig,'BusyAction','cancel');

set(status.hfig,'Colormap',[params.skycolor ; params.terraincolor ; params.fallenterraincolor]);

set(status.hfig,'ResizeFcn',@resize);
set(status.hfig,'DeleteFcn',@deletefcn);

set(status.hfig,'Visible','on');




status.handles = drawworld(params,tanks,status);


% begin game !
count = 0;
while (length(tanks)>1)
  
  if (tanks{status.currtank}.ishuman)
    count = count+1;
    % human player
    set(status.hfig,'KeyPressFcn','');
    
    if (isempty(tanks)), break; end;  % figure was closed
    tanks{1}.angle = BestChromosomes(1,count);
    tanks{1}.power = BestChromosomes(2,count);
    tankid = status.currtank;

    status.handles = refreshstatus(params,tanks,status);
    status.handles = redrawtank(params,tanks,status,tankid);
    pause(params.computerpausebefore);

    [status,tanks] = shoot(params,tanks,status);
     pause(params.computerpauseafter);

  else
    
    % computer player
    set(status.hfig,'KeyPressFcn','');
    [tanks,status] = computermove(params,tanks,status);
    
    pause(params.computerpausebefore);
    [status,tanks] = shoot(params,tanks,status);
    pause(params.computerpauseafter);
    
  end
  
  
  % detect end of game %
  
  if (length(tanks) <= 1)
    if (length(tanks)==1)
      msg = sprintf('Game over, %s wins!', tanks{1}.name);
    else
      msg = 'Game over, no winner.';
    end
    uiwait(msgbox(msg,'Game over','modal'));
    close(status.hfig);
    return;
  end
  
  
  % increment player %

  status.currtank = status.currtank+1;
  if (status.currtank > length(tanks))
    status.currtank = 1;
  end
  
  status.handles = refreshstatus(params,tanks,status);
  
end

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                         Terrain generation                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% generate random terrain %%
% I changed
function [terrain Path] = randterrain(params)

w = params.screensize(1);
h = params.screensize(2);

terrain = zeros(h,w,'uint8');
y = randcurve(rand(1),rand(1),w,1,params.bumpiness);
y = (y-min(y))/(max(y)-min(y));
y = (y + 0.000*randn(size(y))) * params.terrainheight * h;
y = min(max(ceil(y),1),h);

% I added
Path = y;
[X,Y] = meshgrid(1:w,1:h);
terrain(Y <= y(X)) = 1;

end



% generate smooth random 1-D function
% y0, y1 - boundary values
% n - number of samples
% a - max amplitude
% b - bumpiness (>=3)

function y = randcurve(y0,y1,n,a,b)

% random vector of length b
y = [0 rand(1,b-2)-0.5 0];

% x coordinates of y values
x = (0:b-1)/(b-1);

% interpolate to length n
y = interp1(x,y,(0:n-1)/(n-1),'spline');

% normalize and stretch the curve to specified amplitude
y = y/max(abs(y))*a;

% apply boundary conditions by adding straight line
y = y + linspace(y0,y1,n);

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                         Graphical display                              %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% draw the world 

function handles = drawworld(params,tanks,status)

global terrain

figure(status.hfig); clf;
image(terrain);
axis xy; axis off; axis equal; 
axis([1 params.screensize(1) 1 params.screensize(2)]);
set(gca,'Position',get(gca,'OuterPosition'));

hold on;
for i = 1:length(tanks)
  [handles.hcanon(i), handles.hbase(i)] = plottank(tanks{i}, params);
end

handles.htext = printstatus(params,tanks,status);

if (status.wind>0)
  windstr = sprintf('Wind: %d \\rightarrow', status.wind);
elseif (status.wind<0)
  windstr = sprintf('Wind: \\leftarrow %d', -status.wind);
else
  windstr = 'Wind: 0';
end
text(params.screensize(1)-20, params.screensize(2)-20, ...
  windstr, 'FontName', 'Courier', 'HorizontalAlignment', 'Right');

end



% redraw tank %

function handles = redrawtank(params,tanks,status,tankid)

figure(status.hfig);
handles = status.handles;

hcanonprev = handles.hcanon(tankid);
hbaseprev = handles.hbase(tankid);

[handles.hcanon(tankid) , handles.hbase(tankid)] = plottank(tanks{tankid}, params);

delete(hcanonprev);
delete(hbaseprev);

end



% refresh status message %

function handles = refreshstatus(params,tanks,status)

figure(status.hfig);
handles = status.handles;
htextprev = handles.htext;
handles.htext = printstatus(params,tanks,status);
delete(htextprev.statustext);
delete(htextprev.nametext);

end



% print status text

function htext = printstatus(params,tanks,status)

figure(status.hfig);
htext.statustext = text(20, params.screensize(2)-20, ...
  sprintf('Initial Velocity: %-4d  Angle: %-3d', ...
  round(tanks{status.currtank}.power),round(tanks{status.currtank}.angle)), ...
  'FontName', 'FixedWidth');

sz = get(htext.statustext,'Extent');
htext.nametext = text(sz(1)+sz(3), params.screensize(2)-20, ['  ' tanks{status.currtank}.name], ...
  'FontName', 'FixedWidth', 'FontWeight', 'bold', 'Color', tanks{status.currtank}.color);

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                         Callback functions                             %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% callback function for keyboard %

function keypress(h,evt)

global params tanks status

if (length(evt.Modifier)==1 && strcmp(evt.Modifier{1},'shift'))
  angstep = params.smallangstep;
else
  angstep = params.largeangstep;
end

switch (evt.Key)
  
  case 'leftarrow'
    tanks{status.currtank}.angle = min(tanks{status.currtank}.angle+angstep, params.maxangle);
    status.handles = redrawtank(params,tanks,status,status.currtank);
    status.handles = refreshstatus(params,tanks,status);

  case 'rightarrow'
    tanks{status.currtank}.angle = max(tanks{status.currtank}.angle-angstep, params.minangle);
    status.handles = redrawtank(params,tanks,status,status.currtank);
    status.handles = refreshstatus(params,tanks,status);
    
  case 'pageup'
    tanks{status.currtank}.power = min(tanks{status.currtank}.power+params.largepwrstep, tanks{status.currtank}.maxpower);
    status.handles = redrawtank(params,tanks,status,status.currtank);
    status.handles = refreshstatus(params,tanks,status);
    
  case 'pagedown'
    tanks{status.currtank}.power = max(tanks{status.currtank}.power-params.largepwrstep, params.minpower);
    status.handles = redrawtank(params,tanks,status,status.currtank);
    status.handles = refreshstatus(params,tanks,status);
    
  case 'uparrow'
    tanks{status.currtank}.power = min(tanks{status.currtank}.power+params.smallpwrstep, tanks{status.currtank}.maxpower);
    status.handles = redrawtank(params,tanks,status,status.currtank);
    status.handles = refreshstatus(params,tanks,status);

  case 'downarrow'
    tanks{status.currtank}.power = max(tanks{status.currtank}.power-params.smallpwrstep, params.minpower);
    status.handles = redrawtank(params,tanks,status,status.currtank);
    status.handles = refreshstatus(params,tanks,status);
    
  case 'space'
    uiresume;
    
end

end



% callback function for window resize %

function resize(h,evt)

global params tanks status

status.handles = drawworld(params,tanks,status);

end



% callback function for deleting a game %

function deletefcn(h,evt)

global params tanks status terrain tankmap

% clear memory
params = [];
tanks = [];
status = [];
terrain = [];
tankmap = [];

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                       Physics and animation                            %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% shoot! %

function [status,tanks] = shoot(params,tanks,status)

global terrain tankmap

printf('-------------------------');

tank = tanks{status.currtank};
theta = tank.angle*pi/180;

p = canon_end(tank, params)';
v = [cos(theta) ; sin(theta)] * tank.power;
a = [0 ; -1]*params.gravity + [1 ; 0]*status.wind;
t = 0:params.simulationdelta:params.tmax;

% compute trajectory
P = p*ones(1,length(t)) + v*t + a*t.^2/2;
P = round(P);

% determine if there was a hit
hit = 0;

% determine trajectory within screen
outscreen = find(P(1,:)<1 | P(2,:)<1 | P(1,:)>params.screensize(1),1,'first');
if (~isempty(outscreen))  
  if (P(2,outscreen) < 1), hit=1; end   % hit bottom of screen
  P = P(:,1:outscreen-1);
end

% part of trajectory in sky
insky = P(2,:)>params.screensize(2);

% part of trajectory in land
P1 = P; P1(:,insky) = 1;  % to avoid out-of-bounds
inland = terrain(sub2ind(size(terrain),P1(2,:),P1(1,:))) & ~insky;

% find contact with land
firstland = find(inland,1,'first');
if (~isempty(firstland))
  hit = 1;
  P = P(:,1:firstland);
  P1 = P1(:,1:firstland);
  insky = insky(1:firstland);
end

% detect tank hits
tankhit = tankmap(sub2ind(size(tankmap),P1(2,:),P1(1,:))) & ~insky;
tankpos = find(tankhit,1,'first');
if (~isempty(tankpos))
  hit = 1;
  P = P(:,1:tankpos);
end

% reduce simulated trajectory by animation step size factor
P = P(:,[1:params.animstepsize:end-1 end]);

% animate
if (~isempty(P))
  missle = line('xdata',P(1,1),'ydata',P(2,1),'marker','.','erasemode','xor','markersize',params.misslesize);
end
for i = 1:size(P,2)
  set(missle,'xdata',P(1,i),'ydata',P(2,i));
  drawnow;
  pause(0.01);
end
delete(missle);


% no hit
if (hit==0)
  return;
end


% contains -1 for a missle explosion, or a tankid for a tank explosion
blastQ(1) = -1;

while (~isempty(blastQ))
  
  % get current blast properties
  if (blastQ(1) == -1)
    
    % missle blast
    blastpoint = P(:,end);
    blastradius = params.missleblastsize/2;
    blasttype = 'lava';
  else
    
    % tank blast
    blastpoint = [tanks{blastQ(1)}.x , tanks{blastQ(1)}.y];
    blastradius = params.tankblastsize/2;
    blasttype = 'fire';
  end

  % animate explosion
  animateblast(blastpoint,blastradius,params,status,blasttype);
  
  % eliminate tank
  if (blastQ(1) > -1)
    [status,tanks] = removetank(tanks,status,params,blastQ(1));
    blastQ(blastQ>blastQ(1)) = blastQ(blastQ>blastQ(1))-1;
  end
  
  % I commented - remove all parts with hiting ground, tank falling or
  % loosing power
  % remove dirt
%   terrain( getblastregion(blastpoint,blastradius,params) ) = 0;
   status.handles = drawworld(params,tanks,status);
% 
%   % ground fall
%   pause(0.2);
%   terrain = groundfall(terrain);
%   status.handles = drawworld(params,tanks,status);
% 
%   % compute blast damage
   tanks = computeblastdamage(blastpoint,blastradius,params,tanks);
% 
%   % tank fall
%[status, tanks] = tankfall(status,params,tanks);

  % update blast queue
  blastQ = blastQ(2:end);
  for i = 1:length(tanks)
    if (tanks{i}.maxpower <= 0 && isempty(find(blastQ==i,1)))
      blastQ(end+1) = i;
      printf('tank %s has been killed', tanks{i}.name);
    end
  end
  
  pause(0.2);  % pause between blasts
  
end

end



% animate explosion! %
% blastpoint - coordinates of explosion center in world coordinates
% blastrad - radius of blast in world coordinates
% blasttype - either 'lava' or 'fire'

function animateblast(blastpoint, blastrad, params, status, blasttype)

% type of blast

lavablast = 1;
fireblast = 2;

switch(lower(blasttype))
  case 'lava'
    blasttype = lavablast;
  otherwise
    blasttype = fireblast;
end

if (blasttype == lavablast && params.maxlavacomplexity==0)
  return;
end

figure(status.hfig);

% render figure as rgb image
frame = getframe;
frame = flipdim(frame(1).cdata,1);

image(frame,'xdata',[1 params.screensize(1)],'ydata',[1 params.screensize(2)],'erasemode','none');
drawnow;

% blast center in frame coordinates
ctrx = round(blastpoint(1)/params.screensize(1)*size(frame,2));
ctry = round(blastpoint(2)/params.screensize(2)*size(frame,1));

% blast size (radius) in frame coordinates
sizex = ceil(blastrad/params.screensize(1)*size(frame,2));
sizey = ceil(blastrad/params.screensize(2)*size(frame,1));

% blast coordinates in frame units
blastx = ctrx-sizex : ctrx+sizex;
blasty = ctry-sizey : ctry+sizey;

% precomputed smooth blast intensity values
if (blasttype == fireblast)
  blastintensities = uint8((1 + sin((1:params.firecolornum)/params.firecolornum*pi)) * 127.5);
else
  blastintensities = uint8((1 + sin((1:params.lavacolornum)/params.lavacolornum*2*pi)) * 127.5);
end

% blast pattern
if (blasttype == fireblast)
  % smooth ring pattern
  [X,Y] = meshgrid((blastx-ctrx)/sizex, (blasty-ctry)/sizey);
  blastpattern = sqrt(X.^2 + Y.^2);
else
  % random smooth lava pattern
  xcomplexity = floor(rand(1)*(params.maxlavacomplexity-params.minlavacomplexity+1)) + params.minlavacomplexity;
  ycomplexity = floor(rand(1)*(params.maxlavacomplexity-params.minlavacomplexity+1)) + params.minlavacomplexity;
  blastpattern = imresize( rand(ycomplexity, xcomplexity) , [2*sizey+1 2*sizex+1] );
end

% transform blast pattern range from [0,1] to [1,length(blastintensities)]
blastpattern = ceil(blastpattern*length(blastintensities));
blastpattern = min(max(blastpattern,1),length(blastintensities));

% restrict blast pattern to within frame range
blastpattern = blastpattern(blasty>=1 & blasty<=size(frame,1) , blastx>=1 & blastx<=size(frame,2));
blastx = blastx(blastx>=1 & blastx<=size(frame,2));
blasty = blasty(blasty>=1 & blasty<=size(frame,1));

% normalized distance map for blast pattern
[X,Y] = meshgrid((blastx-ctrx)/sizex, (blasty-ctry)/sizey);
blastdistancemap = sqrt(X.^2 + Y.^2);

% extract animated region from frame
framepatch = frame(blasty,blastx,:);

% rgb image of blast
rgbblastimage = zeros(size(framepatch),'uint8');


%% animate growing lava ball %%

if (blasttype == fireblast)
  blastradiuses = blastrad * ones(1,round(params.fireanimtime/params.blastanimdelta));
else
  blastradiuses = [ 1 : params.blastanimdelta*params.lavapixpersec : blastrad ...
                    blastrad * ones(1,round(params.lavaremaintime/params.blastanimdelta)) ];
end

for rad = blastradiuses
  
  % record computation beginning time
  tic;
  
  % binary image of current blast ball
  blastmask = blastdistancemap <= rad/blastrad;
  blastmask = repmat(blastmask,[1 1 3]);
  
  % update red channel of blast image
  rgbblastimage(:,:,1) = blastintensities(blastpattern);

  % write blast image to frame patch
  framepatch(blastmask) = rgbblastimage(blastmask);
  
  % update blast pattern   
  if (blasttype == fireblast)
    blastpattern = blastpattern-1;
    blastpattern(blastpattern<1) = length(blastintensities);
  else
    blastpattern = blastpattern+1;
    blastpattern(blastpattern>length(blastintensities)) = 1;
  end
  
  % draw
  image(framepatch,'xdata',[blastx(1) blastx(end)]/size(frame,2)*params.screensize(1),...
                   'ydata',[blasty(1) blasty(end)]/size(frame,1)*params.screensize(2),'erasemode','none');
                   
  drawnow; 
  
  % pause for remaining time
  pause(params.blastanimdelta-toc);
end

end



% compute falling tank

function [status,tanks] = tankfall(status,params,tanks)

global terrain tankmap

xmin=zeros(length(tanks),1);
xmax=zeros(length(tanks),1);
ymin=zeros(length(tanks),1);
ymax=zeros(length(tanks),1);

for i = 1:length(tanks)
  [xmin(i),xmax(i),ymin(i),ymax(i)] = gettankcoords(tanks{i},params);
end

ids = [ (1:length(tanks))' ymin ];
ids = sortrows(ids,2);

rigidarea = (terrain~=0 | tankmap~=0);

for i = 1:length(tanks)
  
  tank = tanks{ids(i)};
  [xmin,xmax,ymin,ymax] = gettankcoords(tank, params);
  initheight = ymin;
  
  initx = tank.x;
  inity = tank.y;
  
  rigidarea(ymin:ymax,xmin:xmax) = 0;
  tankmap(ymin:ymax,xmin:xmax) = 0;
  
  % if tank falls two times in a row a drop height of zero but with two
  % opposite directions, stop to avoid infinite loop
  prevdir = nan;
  prevdropheight = nan;

  % while tank has not falling to screen bottom
  while (ymin>1)
    
    % detect rigid area under tank and empty areas on both sides
    undertank = rigidarea(ymin-1,xmin:xmax);
    leftempty = find(undertank,1,'first')-1;
    rightempty = length(undertank)-find(undertank,1,'last');
    
    % detect falling direction
    if (isempty(leftempty))
      dir = 0;
    elseif (leftempty >= length(undertank)*params.tankfallthresh)
      if (any(rigidarea(ymin:ymax,xmin-1))), break; end
      dir = -1;
    elseif (rightempty >= length(undertank)*params.tankfallthresh)
      if (any(rigidarea(ymin:ymax,xmin+1))), break; end
      dir = 1;
    else
      break;
    end
    
    newheight = max(sum(rigidarea(:,(xmin+dir:xmax+dir)))) + 1;
    dropheight = ymin-newheight;
    if (dropheight<0 || (dropheight<1 && prevdropheight<1 && dir==-prevdir))
      break;
    end
    
    xmin = xmin + dir;
    xmax = xmax + dir;
    tank.x = tank.x + dir;
    
    ymin = ymin - dropheight;
    ymax = ymax - dropheight;
    tank.y = tank.y-dropheight;
    
    tanks{ids(i)} = tank;
    status.handles = redrawtank(params,tanks,status,ids(i));
    drawnow; pause(params.fallpauselen);
    
    prevdir = dir;
    prevdropheight = dropheight;

  end
  
  rigidarea(ymin:ymax,xmin:xmax) = 1;
  tankmap(ymin:ymax,xmin:xmax) = ids(i);
  powerdrain = round(params.maxpower * (initheight-ymin)/params.screensize(2) * params.falldrainfactor);
  tanks{ids(i)}.maxpower = tanks{ids(i)}.maxpower - powerdrain;
  tanks{ids(i)}.power = min(tanks{ids(i)}.power, tanks{ids(i)}.maxpower);
  if (powerdrain>0)
    printf('tank %s has sustained %d fall damage, remaining %d power', tanks{ids(i)}.name, powerdrain, tanks{ids(i)}.maxpower);
  end
  
  
  %%% update distortion for current tank and all tanks targeting it %%%
  
  % normalized move distance relative to the distortion reset distance
  movedist = sqrt((tank.x-initx)^2 + (tank.y-inity)^2);
  movedist = movedist / (norm(params.screensize)*params.resetdistortiondist);
  movedist = min(movedist, 1);
  
  if (movedist > 0)
    for j = 1:length(tanks)
      if (~tanks{j}.ishuman && (ids(i)==j || ids(i)==tanks{j}.currenemy))
        tanks{j}.currdistortion = max(tanks{j}.currdistortion, params.initdistortion*movedist);
      end
    end
  end
  
end

end



% simulate falling ground %

function terrain = groundfall(terrain)

for i = 1:size(terrain,2)
  rigidterrain = find(terrain(:,i)~=1,1,'first') - 1;
  totalterrain = sum(terrain(:,i)~=0);
  terrain(1:rigidterrain,i) = 1;
  terrain(rigidterrain+1:totalterrain,i) = 2;
  terrain(totalterrain+1:end,i) = 0;
end

end



% compute damage to tanks from blast %

function tanks = computeblastdamage(blastpoint,blastrad,params,tanks)

global tankmap

[blastx,blasty] = getblastids(blastpoint, blastrad, params);
[X,Y] = meshgrid(blastx, blasty);
blastdistmap = sqrt((X-blastpoint(1)).^2 + (Y-blastpoint(2)).^2);

tmap = tankmap(blasty,blastx);
for i = 1:length(tanks)
  tankdist = min(blastdistmap(tmap == i));
  if (isempty(tankdist)), continue; end
  powerdrain = round( max((1 - tankdist/blastrad), 0) * params.maxpower * 1.02 );
  % I added the if, so that there will be no partial reduction in the power, but
  % just a full reduction, if there is a hit.
  PrecisionOfHit = 0.3; % if this is 1 then the hit should be very precise. As smaller it is - the hit should be less precise

  if powerdrain>tanks{i}.maxpower*PrecisionOfHit  
      tanks{i}.maxpower = tanks{i}.maxpower - tanks{i}.maxpower*1.02;% - powerdrain;
      tanks{i}.power = min(tanks{i}.power, tanks{i}.maxpower);
  end
  % I commented
  %printf('tank %s has sustained %d explosion damage, remaining %d power', tanks{i}.name, powerdrain, tanks{i}.maxpower);
end

end



% x & y index ranges of blast region in terrain map

function [blastx,blasty] = getblastids(blastpoint, blastrad, params)

blastradius = -ceil(blastrad) : ceil(blastrad);

blastx = blastpoint(1)+blastradius;
blastx = blastx(blastx>=1 & blastx<=params.screensize(1));
blasty = blastpoint(2)+blastradius;
blasty = blasty(blasty>=1 & blasty<=params.screensize(2));

end



% indices of blast circle in terrain map

function blastids = getblastregion(blastpoint, blastrad, params)

[blastx,blasty] = getblastids(blastpoint, blastrad, params);
[X,Y] = meshgrid(blastx, blasty);
blastdistmap = sqrt((X-blastpoint(1)).^2 + (Y-blastpoint(2)).^2);
blastarea = find(blastdistmap <= blastrad);

blastids = sub2ind([params.screensize(2) params.screensize(1)], Y(blastarea), X(blastarea));

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                            Tank geometry                               %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% draw a tank %

function [hcanon,hbase] = plottank(tank, params)

[canonx,canony,canonw,canonh] = getcanonparams(tank,params);
[basex,basey,basew,basehl,basehu] = getbaseparams(tank,params);

hcanon = drawcanon(canonx, canony, canonw, canonh, tank.angle*pi/180, tank.color);
hbase  = drawbase(basex, basey, basew, basehl, basehu, tank.color);

end


% get dimensions of tank base and point of origin %

function [basex,basey,basew,basehl,basehu] = getbaseparams(tank,params)

basex = tank.x;
basey = tank.y;
basew = params.tanksize;
basehl = params.tanksize/7;
basehu = params.tanksize/3;

end


% get dimensions of canon and point of origin %

function [canonx,canony,canonw,canonh] = getcanonparams(tank,params)

canonx = tank.x;
canony = tank.y+params.tanksize/4;
canonw = params.canonsize/12;
canonh = params.canonsize/2;

end



% get the coordinates of the canon exit point %

function p = canon_end(tank, params)

theta = tank.angle*pi/180;

[canonx,canony,canonw,canonh] = getcanonparams(tank,params);
p = [canonx+canonh*cos(theta) canony+canonh*sin(theta)];

end



% return the integer coordinates of a tank in the world %

function [xmin,xmax,ymin,ymax] = gettankcoords(tank, params)

[basex,basey,basew,basehl,basehu] = getbaseparams(tank,params);
xmin = max(round(basex - basew/2),1);
xmax = min(round(basex + basew/2),params.screensize(1));
ymin = max(round(basey),1);
ymax = min(round(basey + basehl + basehu),params.screensize(2));

end




% draw the tank canon
% x,y - coordinates of canon origin
% w,l - width and length
% theta - angle in radians
% c - color

function hcanon = drawcanon(x,y,w,l,theta,c)

mat = [cos(theta) -sin(theta) ; sin(theta) cos(theta)];
P = mat*[0 l l 0 ; -w/2 -w/2 w/2 w/2];
hcanon = fill(P(1,:)+x,P(2,:)+y,c);

end



% draw the tank base
% x,y - coordinates of bottom-center
% w  - width of base
% hl - height of lower part
% hr - height of upper part
% c - color

function hbase = drawbase(x,y,w,hl,hu,c)

theta = (0:100)'/100*pi;
X = w/2*cos(theta) + x;
Y = hu*sin(theta) + y;

X = [X(1) ; X ; X(end)];
Y = [Y(1) ; Y+hl ; Y(end)];

hbase = fill(X,Y,c);
       
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                            Computer play                               %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [tanks,status] = computermove(params,tanks,status)

global terrain

tankid = status.currtank;
tank = tanks{tankid};

% target point
x1 = [tanks{tank.currenemy}.x ; tanks{tank.currenemy}.y];

% add distortion to target
x1(1) = x1(1) + (round(rand(1))*2-1)*tank.currdistortion;
x1(1) = min(x1(1),params.screensize(1)-1);
x1(1) = max(x1(1),2);

% acceleration vector
a = [0 ; -1]*params.gravity + [1 ; 0]*status.wind;


%%% find a path to x1 %%%

foundpath = 0;
minlandamount = inf;

% iterate angles in order, starting from current angle
angles = [tank.angle : params.maxangle , tank.angle-1 : -1 : params.minangle];

for angle = angles
  
  anglerad = angle*pi/180;
  u = [cos(anglerad) ; sin(anglerad)];
  uorth = [-sin(anglerad) ; cos(anglerad)];
  
  % starting point is canon end for current angle
  tank.angle = angle;
  x0 = canon_end(tank, params)';
  
  % hit time squared
  tsqr = 2*(((x1-x0)'*uorth) / (a'*uorth));
  
  % no solution for this angle
  if (tsqr<0 || tsqr>params.tmax^2)
    continue; 
  end
  
  % hit time
  t = sqrt(tsqr);
  
  % fire power
  power = ((x1-x0)'*u-(a'*u)*t^2/2)/t;
  power = round(power);
  
  % make sure power is valid for this tank
  if (power<0 || power>tank.maxpower)
    continue;
  end
  
  % initial velocity
  v0 = power*u;
  
  % compute trajectory
  t = 0:params.simulationdelta:t;
  P = x0*ones(1,length(t)) + v0*t + a*t.^2/2;
  P = round(P);
  
  % make sure trajectory is within the screen
  outscreen = P(1,:)<1 | P(2,:)<1 | P(1,:)>params.screensize(1);
  if (any(outscreen))
    continue;
  end
  
  % part of trajectory in sky
  insky = P(2,:)>params.screensize(2);
  
  % part of trajectory in land
  P1 = P; P1(:,insky) = 1;  % to avoid out-of-bounds
  inland = terrain(sub2ind(size(terrain),P1(2,:),P1(1,:))) & ~insky;
  
  % amount of land in trajectory
  landamount = sum(inland(1:end-1));
  
  if (landamount == 0)   % found a clear trajectory!
    foundpath = 1;
    break;
  elseif (landamount < minlandamount)
    minlandamount = landamount;
    bestpower = power;
    bestangle = angle;
  end

end

if (~foundpath)
  if (minlandamount < inf)
    % use path passing through the least land
    power = bestpower;
    angle = bestangle;
    
  else
    % no path found - use random power and angle
    power = ceil((rand(1)*0.8+0.2)*tank.maxpower);
    angle = ceil(rand(1)*(params.maxangle-params.minangle+1)) +  params.minangle - 1;
  end
end

% reduce tank distortion
tanks{tankid}.currdistortion = tanks{tankid}.currdistortion * params.distortionchange;

% animate canon motion
if (tanks{tankid}.angle < angle)
  angles = [tanks{tankid}.angle : params.largeangstep : angle-1 angle];
else
  angles = [tanks{tankid}.angle : -params.largeangstep : angle+1 angle];
end

for ang = angles
  tanks{tankid}.angle = ang;
  status.handles = refreshstatus(params,tanks,status);
  status.handles = redrawtank(params,tanks,status,tankid);
  pause(0.01);
end


% animate power change
if (tanks{tankid}.power < power)
  powers = [tanks{tankid}.power : params.largepwrstep : power-1 power];
else
  powers = [tanks{tankid}.power : -params.largepwrstep : power+1 power];
end

for pwr = powers
  tanks{tankid}.power = pwr;
  status.handles = refreshstatus(params,tanks,status);
  pause(0.01);
end



% update tank power
% tanks{tankid}.power = power;

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                        %
%                           Other functions                              %
%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% render image with tank locations

function tankmap = rendertanks(tanks, params)

w = params.screensize(1);
h = params.screensize(2);

tankmap = zeros(h,w,'uint8');

for i = 1:length(tanks)
  [xmin,xmax,ymin,ymax] = gettankcoords(tanks{i},params);  
  tankmap(ymin:ymax,xmin:xmax) = i;
end

end



% eliminate tank

function [status, tanks] = removetank(tanks,status,params,tankid)

global tankmap

% delete from world
figure(status.hfig);
delete(status.handles.hcanon(tankid));
delete(status.handles.hbase(tankid));

status.handles.hcanon = status.handles.hcanon([1:tankid-1 tankid+1:end]);
status.handles.hbase  = status.handles.hbase([1:tankid-1 tankid+1:end]);

% remove from tank map and update indices
[xmin,xmax,ymin,ymax] = gettankcoords(tanks{tankid},params);  
tankmap(ymin:ymax,xmin:xmax) = 0;
tankmap(tankmap>tankid) = tankmap(tankmap>tankid)-1;

% remove from tanks array
tanks = tanks([1:tankid-1 tankid+1:end]);

% update current tank id
if (status.currtank >= tankid)
  status.currtank = status.currtank-1;
  if (status.currtank < 1)
    status.currtank = length(tanks);
  end
end

% update enemy indices for computer players
for i = 1:length(tanks)
  
  if (tanks{i}.ishuman), continue; end
  
  if (tanks{i}.currenemy>tankid)
    tanks{i}.currenemy = tanks{i}.currenemy-1;
  elseif (tanks{i}.currenemy==tankid)
    tanks{i}.currenemy = selectenemy(tanks,i);
    tanks{i}.currdistrtion = params.initdistortion;
  end
end

end



% select random enemy for computer player

function enemyid = selectenemy(tanks,tankid)

if (length(tanks)==1)
  % this only happens at the end of the game
  enemyid = 1;
else  
  p = randperm(length(tanks));
  if (p(1)~=tankid)
    enemyid = p(1);
  else
    if (length(p)>1)
      enemyid = p(2);
    end
  end
end
  
end



% minimum and maximum lava pattern comlexity (=number of "blobs" in each dimension)

function [minlavacomplexity, maxlavacomplexity] = lavacomplexity(blastsize)

if (blastsize <= 40)
  minlavacomplexity = 0;
  maxlavacomplexity = 0;
elseif (blastsize <= 60)
  minlavacomplexity = 3;
  maxlavacomplexity = 3;  
elseif (blastsize <= 80)
  minlavacomplexity = 4;
  maxlavacomplexity = 4;
elseif (blastsize <= 130)
  minlavacomplexity = 4;
  maxlavacomplexity = 5;
elseif (blastsize <= 200)
  minlavacomplexity = 5;
  maxlavacomplexity = 7;
else
  minlavacomplexity = 7;
  maxlavacomplexity = 9;
end

end
