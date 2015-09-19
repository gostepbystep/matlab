function aux=s_cplot(seismic,varargin)
% Plot seismic data in color-coded form.
%
% Written by: E. R.: May 16, 2000
% Last updated: April 22, 2009: bug fix if number of traces is 1
%
%             aux=s_cplot(seismic,varargin)
% INPUT
% seismic     seismic structure
% varargin    one or more cell arrays; the first element of each cell array
%             is a keyword, the other elements are parameters.
%             Presently, keywords are:
%     'annotation'  header mnemonic to use for the horizontal axis
%             Default: {'annotation','trace_no'}
%     'clim'  two numbers representing fractions of the difference between smallest and 
%             largest sample  value (see also keyword 'limits') to compute lower and 
%             upper limits limit of values to which colors will be assigned.
%             limits(1)=min(seismic.traces) + (max(seismic.traces)-min(seismic.traces)*clim(1)
%             limits(2)=max(seismic.traces) - (max(seismic.traces)-min(seismic.traces)*clim(2)
%             Default: {'clim',0.3333,0.3333}
%     'colorbar' plot colorbar; possible values are 'yes' and 'no'.
%             Default: {'colorbar','yes'}
%     'colormap'  colormap to use to map seismic amplitudes to color. Can be 
%             any of those predefined in MATLAB (such as 'copper','hot'); 
%             type "help graph3d" in MATLAB for a list of color maps. 
%             Also {'colormap','gray'} creates a gray-scale color map 
%             (the smaller the value the darker the color)
%             Default: {colormap,'seismic'}; this creates a blue-to-red colormap 
%                                            (function "mycolormap('seismic')")
%     'direction'  plot direction. Possible values are: left-to-right, 'l2r', 
%             and right-to-left, 'r2l'.
%             Default: {'direction','l2r') 
%     'figure'   Specifies if new figure should be created or if the seismic 
%             traces should be plotted to an existing figure. 
%             Possible values are 'new' and any other string. 
%             Default: {'figure','new'} 
%     'flip_colormap' keyword to flip the colormap (e.g. the default "blue-to-red" 
%             colormap is converted to "red-to-blue"); possible values are 'yes'
%             and any other string.
%             Default: {'flip_colormap','no'}
%     'imagemenu'  Specifies if figure should have a menu button to allow 
%             interactive change of color parameters. 
%             Possible values are: 'yes' and 'no'
%             Default: {'imagemenu','yes'}
%     'interpol'    2-element cell array {'interpol','no'|'cubic'}
%             Default: {'interpol','cubic'}
%     'limits' lower and upper limit of values to which colors will be assigned; 
%             if given it overrides parameters specified via keyword 'clim'. 
%             Default: {'limits',[],[]}
%                      specifies how data should be interpolated in time
%     'orient' Plot orientation. Possible values are: 'portrait' and 'landscape'
%             Default: {'orient','landscape'}
%     'polarity'    2-element cell array. Possible values are 1 and -1;
%             Default: {'polarity',1}
%     'scale'       2-element cell array which specifies if individual traces
%             should be scaled relative to one another. There are two scaling options: 
%             'median'  makes the median of the absolute values of each trace the same. 
%             'max'    makes the maximum of the absolute values of each trace the same. 
%             The third alternative is 'no', meaning data are displayed "as is".
%             The previously used option 'yes' is the same as 'median' and, 
%             while deprecated, still works.
%             Default: {'scale','no'}
%     'shading'  color shading (see Matlab function "shading")
%             possible values are '', 'flat', 'faceted', 'interp'
%             if not empty function "pcolor" is used to create the plot
%             with the type of shading specified. Shading 'interp" tends to 
%             give a more continuous display.
%             Otherwise, function imagesc" is used. This is faster.
%             Default: {'shading',''}
%     'times'       2-element or 3-element cell array 
%             {'times',vector of first and last time to plot} or ('times',first,last}. 
%             Default: {'times',seismic.first,seismic.last} which is
%                      equivalent to {'times',[seismic.first,seismic.last]}
%     'time_lines'  Two-element or three-element cell array. the second and
%             third element indicate time intervals at multiples of which 
%             time lines will be plotted. The time lines of the third
%             element (if given), are thicker than those of the first.
%             No time lines are plotted if {'time_lines',[]}.
%             Default: {'time_lines',500,1000}   
%     'title'       2-element cell array. The second element is a plot title.
%             Default: {'title',seismic.name}
%     'traces'      2-element or 3-element cell array. The second element can 
%             be an array of trace numbers or it can be a string. If it is a  
%             string it can be a header mnemonic or it can contain a logical
%             expression involving header values to include.
%             The "pseudo-header" 'trace_no' can also be used.
%             If the second element is a string containing a header mnemonic 
%             there must be a third element containing a vector of values 
%             (see "s_select")
%             Default:  {'traces',[]} which is equivalent to 
%                       {'traces',1:ntr} where ntr denotes the number of traces  
%                           in the input data set (ntr = size(seismic.traces,2))
%     'tracking' track cursor position; possible values are 'yes', 'no', and ''.
%             In the latter case a tracking button is created if the the
%             seismic is plotted in a new figure. Otherwise it is not.
%             Default: {'tracking',''}
% OUTPUT
% aux         structure with information about the plot
%     'figure_handle'    handle of the figure with this plot
%
% EXAMPLE
%          seismic=s_data;
%          s_cplot(seismic,{'limits',-1,1},{'colormap','copper'})
%          s_cplot(seismic,{'limits',-1,1},{'colormap','copper'},{'shading','faceted'})

% UPDATE HISTORY
%          July 25, 2007: Use a function for subset creation


if ~istype(seismic,'seismic')
   if isnumeric(seismic)
      seismic=s_convert(seismic,1,1);
      seismic.units='Samples';
   else
      error('First input argument must be a seismic dataset or a matrix.')
   end
end

run_presets_if_needed

nsamp=size(seismic.traces,1);
if nsamp == 1
   disp('Only one sample per trace; data set not plotted')
   return
end

%     Set default valuesz
param.annotation='trace_no';
param.clim={0.3333,0.3333};
param.colorbar='yes';
param.colormap='seismic';
param.direction='l2r';
param.figure='new';
param.figure_only='no';
param.flip_colormap='no';
param.flip_colors=[];   % Deprecated
param.imagemenu='yes';
param.interpol='v5cubic';
param.limits=cell(1,2);
param.npixels=1000;
param.orient='landscape';
param.polarity=1;
param.scale='no';
param.shading='';
param.time_lines={500,1000};
param.times=[];
param.title=seismic.name;
param.traces=[];
param.tracking='';

%       Decode input arguments
param=assign_input(param,varargin,'s_cplot');

if ~isempty(param.flip_colors)
   alert(' Keyword "flip_colors" has been replaced by "flip_colormap".')
   param.flip_colormap=param.flip_colors;
end

%	Select subset of seismic data
seismic=select_subset_of_seismic_traces(seismic,param.times,param.traces);

%{
if ~isempty(param.traces)  || ~isempty(param.times)
   history=S4M.history;       % Preserve value of global variable S4M.history
   S4M.history=false;

   if iscell(param.traces)
      param.traces=cell2num(param.traces);
   end

   if isempty(param.times)
      seismic=s_select(seismic,{'traces',param.traces});

   elseif iscell(param.times)
      seismic=s_select(seismic,{'traces',param.traces},{'times',param.times{1},param.times{2}});

   else
      seismic=s_select(seismic,{'traces',param.traces},{'times',param.times(1),param.times(2)});

   end

   S4M.history=history;		% Restore history setting
end
%}


[nsamp,ntr]=size(seismic.traces);
if nsamp == 1
   disp('Only one sample per trace; data set not plotted')
   return
end

%     Change polarity if necessary
if param.polarity < 0
   seismic.traces=-seismic.traces;
end

%     Interpolate data in time if necessary
if strcmpi(param.interpol,'cubic')  &&  nsamp < param.npixels
   npix=round(param.npixels/(nsamp-1))*(nsamp-1);
   dti=(seismic.last-seismic.first)/npix;
   times=(seismic.first:dti:seismic.last)';

   if isnull(seismic)   % Turn off warnings caused by NaN's in seismic traces
      warning('off','MATLAB:interp1:NaNinY')
      yi=interp1(seismic.first:seismic.step:seismic.last,seismic.traces,times,param.interpol);
      warning('on','MATLAB:interp1:NaNinY')
   else
      yi=interp1(seismic.first:seismic.step:seismic.last,seismic.traces,times,param.interpol);
   end

else
   dti=seismic.step;
   yi=seismic.traces;
end


%     Compute horizontal trace locations
xi=s_gh(seismic,param.annotation);
if min(xi) == max(xi)  &&  ntr  >  1
   error([' Header requested for annotation (',param.annotation,') is constant'])
end

%       Check if header values change uniformly from one trace to the next.
if ntr == 1 || isconstant(diff(xi),0.001)
   text2append='';
else
   text2append=' - approximate';
   alert(['Trace annotation with header "',param.annotation,'" is only an approximation.'])
end

if strcmpi(param.figure,'new')
   if strcmpi(param.orient,'portrait')
      figure_handle=pfigure;
   else
      figure_handle=lfigure;
   end
else
   figure_handle=gcf;
end
bgGray		% Gray background

if nargout > 0
   aux.figure_handle=figure_handle;
end
set(figure_handle,'DoubleBuffer','on')
if ntr > 1
   dxi=min(diff(xi))*0.5;
else
   dxi=0.5;
end

if isyes(param.colorbar)
   colorbar
end

axis([min(xi)-dxi,max(xi)+dxi,seismic.first,seismic.last])
ha=get(figure_handle,'CurrentAxes');
set(ha,'TickDir','out','YDir','reverse','XAxisLocation','top')
hold on

%    Handle reversal of plot direction
if strcmpi(param.direction,'r2l')
   set(ha,'xdir','reverse')
%   yi=fliplr(yi);
elseif ~strcmpi(param.direction,'l2r')
   error(['Keyword for plot direction is wrong (',param.direction,')'])
end

if strcmpi(param.figure_only,'yes')
   return
end

%     Scale traces relative to one another
switch param.scale

   case {'yes','median'}
      trace_max=zeros(1,ntr);
      for ii=1:ntr
         temp=abs(yi(:,ii));
         trace_max(ii)=median(temp(temp>0  &  ~isnan(temp)));
      end
      trace_max(isnan(trace_max))=1;
      yi=mrt(yi,mean(trace_max)./(trace_max+eps));

   case 'max'
      trace_max=max(abs(yi));
      yi=mrt(yi,mean(trace_max)./(trace_max+eps));
      
   otherwise
      % Do nothing
end

% 	Compute limits for color display
if iscell(param.limits)
   param.limits=cat(2,param.limits{:});
end
  
ma=max(yi(~isnan(yi)));
if isempty(ma)
   iname=inputname(1);
   if strcmpi(iname,'')
      iname='data set';
   end
   alert([' All elements of ',iname,' are null values']);
   return
end
mi=min(yi(~isnan(yi)));
if ma*mi < 0
   ma=(ma-mi)*0.5;
%   ma=max(ma,-mi);
   mi=-ma;
elseif ma == mi
   ma=ma+10000*max(ma*eps,eps);
   mi=mi-10000*max(mi*eps,eps);
end
dmami=ma-mi;

if isempty(param.limits)
   if iscell(param.clim)
      param.clim=cat(2,param.clim{:});
   end
   param.limits(2)=ma-dmami*param.clim(2);
   param.limits(1)=mi+dmami*param.clim(1);
   if param.limits(1) >= param.limits(2)
      alert(' clim(1) + clim(2) must be less than 1; present values ignored')
      param.limits(1)=mi;
      param.limits(2)=ma;
   end
else
   if param.limits(1) >= param.limits(2)
      alert(' limits(1) must be less than limits(2); present values ignored')
      param.limits(1)=mi;
      param.limits(2)=ma;
   end
end

%       Define colormap to use
try
   cm=mycolormap(param.colormap);
catch %#ok
   disp(' Reqested colormap not found; seismic colormap used instead.')
   cm=mycolormap('seismic');
end

%       Flip color matrix if requested
if isyes(param.flip_colormap)
   cm=flipud(cm);
end 

%    Plot data
if isempty(param.shading)
   cplot_no1(yi,seismic.first,dti,xi,param.direction,cm, ...
         param.limits,ha)
else
   cplot_no2(yi,seismic.first,dti,xi,param.direction,cm, ...
         param.limits,ha,param.shading)
end


%  Title
if ~isempty(param.title)
   if iscell(param.title)		% Handle multi-line titles
      mytitle(param.title{1})
   else
      mytitle(param.title)
   end
end

%	Add annotation of horizontal axis
xtext=s_gd(seismic,param.annotation);
hunits=s_gu(seismic,param.annotation);

if ~isempty(xtext) && ~strcmpi(xtext,'not available')
   if ~isempty(hunits) && ~strcmpi(hunits,'n/a')
      xtext=[xtext,' (',hunits,')'];
   end
   xlabel([xtext,text2append])
end


if ~isempty(param.time_lines)
   if ~iscell(param.time_lines)
      param.time_lines={param.time_lines};
   end
   v=axis;
   width=1;
   for ii=1:length(param.time_lines)
      t1=ceil(v(3)/param.time_lines{ii})*param.time_lines{ii};
      temp=t1:param.time_lines{ii}:v(4);
      mygrid(temp,'h','k',width);
      width=width*1.5;
   end
end

box on
grid on 
zoom on
set(ha,'gridlinestyle','-','xgrid','off','Layer','top')

%	Button for figure-export menu
% figure_export_menu(figure_handle);

%	Button for scroll bars
cseismic_scrollbar_menu(figure_handle,seismic,param.direction)

%	Button for cursor tracking
if (isempty(param.tracking) && strcmpi(param.figure,'new'))  ||  ...
    strcmpi(param.tracking,'yes')       % Add cursor tracking
    
   [dummy,xinfo]=s_gh(seismic,param.annotation);   %#ok First output argument is not required
   y=linspace(seismic.first,seismic.last,nsamp);
   yinfo=info4time(seismic);
   initiate_3d_tracking(seismic.traces,xi,y,xinfo,yinfo,{'amplitude','','Amplitude'})
else
   yinfo=info4time(seismic);
   ylabel([yinfo{3},' (',yinfo{2},')'])
end

%	Button for menu to change image (color, etc. ...)
if strcmpi(param.imagemenu,'yes')
   myimagemenu  %	Create menu button to interactively change colors, etc.
end

%       Update colorbar
if isyes(param.colorbar)
   colorbar
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cplot_no1(seis,stm,prm,xannot,plot_dir,cm,param_scale,ha)
% Function plot seismic data as image plot
%
%          cplot(seis,stm,prm,xannot,plot_dir,cm,param_scale,ha,colbar)
% INPUT
% seis   seismic traces
% stm    start time
% prm    sample interval
% xannot x-axis annotation
% plot_dir  plot direction ('l2r' or 'r2l'); default: 'l2r'
% cm     color matrix
% param_scale  a 2-element vector containing clow and chigh (see imagesc and colormap).
%
%        or by global variable param.clim which computes 
%        ma=max(seis(:)); 
%        if ma > 0
%           param_scale(2)=ma*param.clim(2);
%        else
%           param_scale(2)=ma/param.clim(2);
%        end
%        mi=min(seis(:)); 
%        if mi > 0
%           param_scale(1)=mi/param.clim(1);
%        else
%           param_scale(1)=mi*param.clim(1);
%        end
%        if param_scale(1) >= param_scale(2)
%           cc=mean(param_scale);
%           param_scale(1)=cc*(1-eps);
%           param_scale(2)=cc*(1+eps);
%        end
% ha     handle of axis

[nbin,ntr]=size(seis);

% 	Handle plot and CDP direction
if strcmp(plot_dir,'r2l') == 1 && xannot(1) < xannot(ntr), 
   flip_axis=1;
elseif strcmp(plot_dir,'r2l') ~= 1 && xannot(1) > xannot(ntr), 
   xannot=flipud(xannot(:));
   seis=fliplr(seis);
   flip_axis=1;
elseif strcmp(plot_dir,'r2l') == 1 && xannot(1) > xannot(ntr),
   xannot=flipud(xannot(:));
   flip_axis=0;
   seis=fliplr(seis);
else
   flip_axis=0;
end

%axis([xannot(1)-0.5,xannot(ntr)+0.5,stm,stm+(nbin-1)*prm])
if ~isempty(param_scale) && ~all(isconstant(seis))
   handle=imagesc(xannot,stm:prm:(nbin-1)*prm+stm,seis,param_scale);
else
   handle=imagesc(xannot,stm:prm:(nbin-1)*prm+stm,seis);
end 
set(handle,'Tag','image_displayed') % Create tag for image object which is  
                                    % used in "myimagemenu"
try
   colormap(cm),
catch  %#ok
   % Do nothing
end

set(ha,'XAxisLocation','top','YDir','Reverse');
if flip_axis == 1,
   set(ha,'XDir','Reverse');
end

drawnow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cplot_no2(seis,stm,prm,xannot,plot_dir,cm,param_scale,ha,param_shading)
% Function plot seismic data using "pcolor"
%
%          cplot(seis,stm,prm,xannot,plot_dir,cm,param_scale,ha,colbar)
% INPUT
% seis   seismic traces
% stm    start time
% prm    sample interval
% xannot x-axis annotation
% plot_dir  plot direction ('l2r' or 'r2l'); default: 'l2r'
% cm     color matrix
% param_scale  a 2-element vector containing clow and chigh (see imagesc and colormap).
%
%        or by global variable param.clim which computes 
%        ma=max(seis(:)); 
%        if ma > 0
%           param_scale(2)=ma*param.clim(2);
%        else
%           param_scale(2)=ma/param.clim(2);
%        end
%        mi=min(seis(:)); 
%        if mi > 0
%           param_scale(1)=mi/param.clim(1);
%        else
%           param_scale(1)=mi*param.clim(1);
%        end
%        if param_scale(1) >= param_scale(2)
%           cc=mean(param_scale);
%           param_scale(1)=cc*(1-eps);
%           param_scale(2)=cc*(1+eps);
%        end
% ha     handle of axis

[nbin,ntr]=size(seis);

% 	Handle plot and CDP direction
if strcmp(plot_dir,'r2l') == 1 && xannot(1) < xannot(ntr), 
   flip_axis=1;
   xannot=xannot(:);
elseif strcmp(plot_dir,'r2l') ~= 1 && xannot(1) > xannot(ntr), 
   xannot=flipud(xannot(:));
   seis=fliplr(seis);
   flip_axis=1;
elseif strcmp(plot_dir,'r2l') == 1 && xannot(1) > xannot(ntr),
   xannot=flipud(xannot(:));
   flip_axis=0;
   seis=fliplr(seis);
else
   flip_axis=0;
   xannot=xannot(:);
end

try
   colormap(cm),
catch  %#ok
   % Do nothing
end

%axis([xannot(1)-0.5,xannot(ntr)+0.5,stm,stm+(nbin-1)*prm])
seis=double(seis);
seis(end+1,end+1)=0;
seis(:,end)=seis(:,end-1);
% shading flat

handle=pcolor([0;xannot]+0.5,stm-prm/2:prm:(nbin-1)*prm+stm+prm/2,seis);
if ~isempty(param_scale)
   set(gca, 'CLim', param_scale);
end 
set(handle,'Tag','image_displayed') % Create tag for pplot object which is  
                                    % used in "myimagemenu"
try
   shading(param_shading)
catch  %#ok
   disp([' Unknown parameter for keyword "shading": ',param_shading])
end

set(ha,'XAxisLocation','top','YDir','Reverse');
if flip_axis == 1,
   set(ha,'XDir','Reverse');
end

drawnow
