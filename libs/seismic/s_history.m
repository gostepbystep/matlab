function seismic=s_history(seismic,action,parameters)
% Function operates on the history field of a seismic structure; displays data set history
% if no output argument is given
%
% Written by: E. R.: March, 2001
% Last updated: March 28, 2006: streamline code 
%
%             seismic=s_history(seismic,action,parameters)
% INPUT
% seismic  seismic structure whose history field needs to be modified
% action   string describing the action to take; possible values are:
%         'add'      Add a history field to the seismic structure
%         'append'   Append new information about the present command
%                    to seismic.history (if it exists)
%         'merge'    Append history field from another seismic structure
%         'delete'   Delete the last cell of seismic.history 
%                    (if the history field exists; not yet implemented)
%         'list'     List seismic.history (default if no action specified)
% parameters for 'add' and 'append': character string to be posted in history field;
%            for 'merge': history field of a seismic structure
% OUTPUT
% seismic    seismic structure whose history field has been created/appended
%
%
% EXAMPLE
%        seismic=s_data;
%        s_history(seismic)

global S4M

if ~S4M.history | isempty(S4M.start_time) 
   return
end

if nargin == 1
   action='list';
end

if ~isfield(seismic,'history') & ~strcmpi(action,'add')
   return
end 

if ~strcmp(action,'list')

%       Find level and name of the calling program; return to calling program if
%       level is too deep.

   temp=dbstack;  
   if length(temp) < 2         % Return if not called by function
      return
   end
   level=size(temp,1)-1;
   if isempty(S4M.start_level)
      S4M.start_level=level;
      level_difference=0;
   else
      level_difference=level-S4M.start_level;
      if  level_difference > S4M.history_level
         return
      elseif level_difference < 0
         level_difference=0;
      end
   end
   [dummy,filename] = fileparts(temp(2).name);
   program=upper(filename);
end

if nargin < 3
   parameters=[];
end
      
switch action


             case 'add'

if isempty(S4M.start_time)
   S4M.start_time=clock;    % Date and time as 6-elemenmt array 
end
if isempty(S4M.time)
   S4M.time=datum;          % Date and time as string 
end
if S4M.history    
   t=clock-S4M.start_time;
   seismic.history={[blanks(level_difference),S4M.time, ...
       blanks(S4M.history_level-level_difference)], ...
       round(((24*t(3)+t(4))*60+t(5))*60+t(6)),program,parameters};
end


             case  'append'
t=clock-S4M.start_time;
seismic.history=[seismic.history;{[blanks(level_difference),S4M.time,blanks(S4M.history_level-level_difference)], ...
         round(((24*t(3)+t(4))*60+t(5))*60+t(6)),program,parameters}];


             case  'merge'
merge=parameters;
m=size(merge,1);
prefix='<< ';
for ii=1:m
  seismic.history=[seismic.history; ...
    {[prefix,merge{ii,1}],merge{ii,2},merge{ii,3},merge{ii,4}}];
end


             case 'list'
if ~isfield(seismic,'history')
  disp(' Input data set has no history field')
  clear seismic;
  return
end

display_seismic_history(seismic)


             otherwise
error(['Action "',action,'" unknown or not yet implemented'])
             
end

if nargout == 0 
   if ~strcmpi(action,'list')
      display_seismic_history(seismic)
   end
   clear seismic
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function display_seismic_history(seismic)

spaces=blanks(size(seismic.history,1)+1)';
% commas=char(44*ones(size(seismic.history,1)+1,1));
history=[char('Day/Time of Program Start',char(seismic.history(:,1))),spaces,...
         char(' TiP',num2str(cat(1,seismic.history{:,2}))), spaces, ...
         char('Program',char(seismic.history(:,3))),spaces, ...
         char('Parameters',char(seismic.history{:,4}))];
disp(history)
