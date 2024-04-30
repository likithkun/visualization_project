function dyad_data = read_dyad_data(ca,peer);
% read_dyad_data.m
% Reads dyad data from .dtx files
%
% Usage:
% dyad_data = read_dyad_data(ca,peer);
%
% eg:
% luke_lydia = read_dyad_data('albert','lydia');
%
% dayd_data is a structure with the fields:
% ca: name of CA (STR)
% peer: name of peer (STR)
% number.*: number of sessions
% day.in_pre/out_pre/in_post/out_post: number of day
% raw.*{n}: raw data (?x3, [category start stop])
% filename.*{n}: filename of data file (this is to help debug data files)
% duration.*: fraction of time per category (NxCATEGORIES)
% mean_duration.*: mean fractions of time
% error_duration.*: standard error in means
% sd_duration.*: standard deviations
% score.*: mean combined score
% score_error.*: standard error in mean combined score
% session_score.*: session-by-session combined score
%       .cog_in_pre
%       .cog_in_post
%       .cog_out_pre
%       .cog_out_post
%       .soc_in_pre
%       .soc_in_post
%       .soc_out_pre
%       .soc_out_post

dyad_data.ca = ca;
dyad_data.peer = peer;

cognitive_categories = 7;
social_categories = 7;
start_date = datenum('05/24/1999');

social_weights = [ -1; 0; 1; 2; 2; 3; 5 ];
cognitive_weights = [ 0; -1; 1; 2; 2; 3; 5 ];

% Get filenames

% cognitive
%    indoor
%       pre
files_cog_in_pre = dir(['cog-*-base-*-' ca '-' peer '-indoor.dtx']);
dyad_data.number.cog_in_pre = size(files_cog_in_pre,1);
%       post
files_cog_in_post = dir(['cog-*-inter-*-' ca '-' peer '-indoor.dtx']);
dyad_data.number.cog_in_post = size(files_cog_in_post,1);
%    outdoor
%       pre
files_cog_out_pre = dir(['cog-*-base-*-' ca '-' peer '-outdoor.dtx']);
dyad_data.number.cog_out_pre = size(files_cog_out_pre,1);
%       post
files_cog_out_post = dir(['cog-*-inter-*-' ca '-' peer '-outdoor.dtx']);
dyad_data.number.cog_out_post = size(files_cog_out_post,1);

% social
%    indoor
%       pre
files_soc_in_pre = dir(['so-*-base-*-' ca '-' peer '-indoor.dtx']);
dyad_data.number.soc_in_pre = size(files_soc_in_pre,1);
%       post
files_soc_in_post = dir(['so-*-inter-*-' ca '-' peer '-indoor.dtx']);
dyad_data.number.soc_in_post = size(files_soc_in_post,1);
%    outdoor
%       pre
files_soc_out_pre = dir(['so-*-base-*-' ca '-' peer '-outdoor.dtx']);
dyad_data.number.soc_out_pre = size(files_soc_out_pre,1);
%       post
files_soc_out_post = dir(['so-*-inter-*-' ca '-' peer '-outdoor.dtx']);
dyad_data.number.soc_out_post = size(files_soc_out_post,1);

% Sort files by date.
% cog in pre
days = zeros(dyad_data.number.cog_in_pre,1);
for n = 1:dyad_data.number.cog_in_pre
   session_date = files_cog_in_pre(n).name(5:10);
   session_date = [ session_date(3:4) '/' session_date(1:2) '/19' session_date(5:6) ];
   days(n) = datenum(session_date) - start_date;
end
[dyad_data.day.in_pre,sort_index] = sort(days);
files_cog_in_pre = files_cog_in_pre(sort_index);
% cog in post
days = zeros(dyad_data.number.cog_in_post,1);
for n = 1:dyad_data.number.cog_in_post
   session_date = files_cog_in_post(n).name(5:10);
   session_date = [ session_date(3:4) '/' session_date(1:2) '/19' session_date(5:6) ];
   days(n) = datenum(session_date) - start_date;
end
[dyad_data.day.in_post,sort_index] = sort(days);
files_cog_in_post = files_cog_in_post(sort_index);
% cog out pre
days = zeros(dyad_data.number.cog_out_pre,1);
for n = 1:dyad_data.number.cog_out_pre
   session_date = files_cog_out_pre(n).name(5:10);
   session_date = [ session_date(3:4) '/' session_date(1:2) '/19' session_date(5:6) ];
   days(n) = datenum(session_date) - start_date;
end
[dyad_data.day.out_pre,sort_index] = sort(days);
files_cog_out_pre = files_cog_out_pre(sort_index);
% cog out post
days = zeros(dyad_data.number.cog_out_post,1);
for n = 1:dyad_data.number.cog_out_post
   session_date = files_cog_out_post(n).name(5:10);
   session_date = [ session_date(3:4) '/' session_date(1:2) '/19' session_date(5:6) ];
   days(n) = datenum(session_date) - start_date;
end
[dyad_data.day.out_post,sort_index] = sort(days);
files_cog_out_post = files_cog_out_post(sort_index);
% We already have the day numbers from the cognitive sessions - just check them here
% soc in pre 
days = zeros(dyad_data.number.soc_in_pre,1);
for n = 1:dyad_data.number.soc_in_pre
   session_date = files_soc_in_pre(n).name(4:9);
   session_date = [ session_date(3:4) '/' session_date(1:2) '/19' session_date(5:6) ];
   days(n) = datenum(session_date) - start_date;
end
[days,sort_index] = sort(days);
if dyad_data.day.in_pre ~= days
   warning('Dates for cognitive & social sessions do not match: in, pre');
end
files_soc_in_pre = files_soc_in_pre(sort_index);
% soc in post
days = zeros(dyad_data.number.soc_in_post,1);
for n = 1:dyad_data.number.soc_in_post
   session_date = files_soc_in_post(n).name(4:9);
   session_date = [ session_date(3:4) '/' session_date(1:2) '/19' session_date(5:6) ];
   days(n) = datenum(session_date) - start_date;
end
[days,sort_index] = sort(days);
if dyad_data.day.in_post ~= days
   warning('Dates for cognitive & social sessions do not match: in, post');
end
files_soc_in_post = files_soc_in_post(sort_index);
% soc out pre
days = zeros(dyad_data.number.soc_out_pre,1);
for n = 1:dyad_data.number.soc_out_pre
   session_date = files_soc_out_pre(n).name(4:9);
   session_date = [ session_date(3:4) '/' session_date(1:2) '/19' session_date(5:6) ];
   days(n) = datenum(session_date) - start_date;
end
[days,sort_index] = sort(days);
if dyad_data.day.out_pre ~= days
   warning('Dates for cognitive & social sessions do not match: out, pre');
end
files_soc_out_pre = files_soc_out_pre(sort_index);
% soc out post
days = zeros(dyad_data.number.soc_out_post,1);
for n = 1:dyad_data.number.soc_out_post
   session_date = files_soc_out_post(n).name(4:9);
   session_date = [ session_date(3:4) '/' session_date(1:2) '/19' session_date(5:6) ];
   days(n) = datenum(session_date) - start_date;
end
[days,sort_index] = sort(days);
if dyad_data.day.out_post ~= days
   warning('Dates for cognitive & social sessions do not match: out, post');
end
files_soc_out_post = files_soc_out_post(sort_index);

% Read data files and find means and errors
% cognitive
%    indoor
%       pre
dyad_data.durations.cog_in_pre = zeros(dyad_data.number.cog_in_pre,cognitive_categories);
for n = 1:dyad_data.number.cog_in_pre
   current_data = read_data_file(files_cog_in_pre(n).name);
   dyad_data.raw.cog_in_pre{n} = current_data;
   dyad_data.filename.cog_in_pre{n} = files_cog_in_pre(n).name;
   number_of_behaviours = size(current_data,1);
   for m = 1:number_of_behaviours
      dyad_data.durations.cog_in_pre(n,current_data(m,1)) = ...
         dyad_data.durations.cog_in_pre(n,current_data(m,1)) ...
         + current_data(m,3) - current_data(m,2);
      % Do some basic checks on correctness of data
      if m == 1
         if current_data(m,2) ~= 0
            warning(['Start time != 0 in: ' files_cog_in_pre(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      else
         if current_data(m,2) ~= current_data(m-1,3)
            warning(['Stop/start time mismatch in: ' files_cog_in_pre(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      end
      if current_data(m,3) <= current_data(m,2)
         warning(['Stop time <= start time in: ' files_cog_in_pre(n).name ]);
         fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
      end
   end
   dyad_data.durations.cog_in_pre(n,:) = ...
      dyad_data.durations.cog_in_pre(n,:)/current_data(end,3);
   if abs( sum(dyad_data.durations.cog_in_pre(n,:)) - 1 ) > 10*eps
      warning(['Durations in ' dyad_data.filename.cog_in_pre{n} ' do not add up to 1!']);
   end
end
dyad_data.mean_duration.cog_in_pre = mean(dyad_data.durations.cog_in_pre,1);
dyad_data.sd_duration.cog_in_pre = std(dyad_data.durations.cog_in_pre,0,1);
dyad_data.error_duration.cog_in_pre = ...
   dyad_data.sd_duration.cog_in_pre / sqrt(dyad_data.number.cog_in_pre);
%       post
dyad_data.durations.cog_in_post = zeros(dyad_data.number.cog_in_post,cognitive_categories);
for n = 1:dyad_data.number.cog_in_post
   current_data = read_data_file(files_cog_in_post(n).name);
   dyad_data.raw.cog_in_post{n} = current_data;
   dyad_data.filename.cog_in_post{n} = files_cog_in_post(n).name;
   number_of_behaviours = size(current_data,1);
   for m = 1:number_of_behaviours
      dyad_data.durations.cog_in_post(n,current_data(m,1)) = ...
         dyad_data.durations.cog_in_post(n,current_data(m,1)) ...
         + current_data(m,3) - current_data(m,2);
      % Do some basic checks on correctness of data
      if m == 1
         if current_data(m,2) ~= 0
            warning(['Start time != 0 in: ' files_cog_in_post(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      else
         if current_data(m,2) ~= current_data(m-1,3)
            warning(['Stop/start time mismatch in: ' files_cog_in_post(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      end
      if current_data(m,3) <= current_data(m,2)
         warning(['Stop time <= start time in: ' files_cog_in_post(n).name ]);
         fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
      end
   end
   dyad_data.durations.cog_in_post(n,:) = ...
      dyad_data.durations.cog_in_post(n,:)/current_data(end,3);
   if abs( sum(dyad_data.durations.cog_in_post(n,:)) - 1 ) > 10*eps
      warning(['Durations in ' dyad_data.filename.cog_in_post{n} ' do not add up to 1!']);
   end
end
dyad_data.mean_duration.cog_in_post = mean(dyad_data.durations.cog_in_post,1);
dyad_data.sd_duration.cog_in_post = std(dyad_data.durations.cog_in_post,0,1);
dyad_data.error_duration.cog_in_post = ...
   dyad_data.sd_duration.cog_in_post / sqrt(dyad_data.number.cog_in_post);
%    outdoor
%       pre
dyad_data.durations.cog_out_pre = zeros(dyad_data.number.cog_out_pre,cognitive_categories);
for n = 1:dyad_data.number.cog_out_pre
   current_data = read_data_file(files_cog_out_pre(n).name);
   dyad_data.raw.cog_out_pre{n} = current_data;
   dyad_data.filename.cog_out_pre{n} = files_cog_out_pre(n).name;
   number_of_behaviours = size(current_data,1);
   for m = 1:number_of_behaviours
      dyad_data.durations.cog_out_pre(n,current_data(m,1)) = ...
         dyad_data.durations.cog_out_pre(n,current_data(m,1)) ...
         + current_data(m,3) - current_data(m,2);
      % Do some basic checks on correctness of data
      if m == 1
         if current_data(m,2) ~= 0
            warning(['Start time != 0 in: ' files_cog_out_pre(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      else
         if current_data(m,2) ~= current_data(m-1,3)
            warning(['Stop/start time mismatch in: ' files_cog_out_pre(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      end
      if current_data(m,3) <= current_data(m,2)
         warning(['Stop time <= start time in: ' files_cog_out_pre(n).name ]);
         fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
      end
   end
   dyad_data.durations.cog_out_pre(n,:) = ...
      dyad_data.durations.cog_out_pre(n,:)/current_data(end,3);
   if abs( sum(dyad_data.durations.cog_out_pre(n,:)) - 1 ) > 10*eps
      warning(['Durations in ' dyad_data.filename.cog_out_pre{n} ' do not add up to 1!']);
   end
end
dyad_data.mean_duration.cog_out_pre = mean(dyad_data.durations.cog_out_pre,1);
dyad_data.sd_duration.cog_out_pre = std(dyad_data.durations.cog_out_pre,0,1);
dyad_data.error_duration.cog_out_pre = ...
   dyad_data.sd_duration.cog_out_pre / sqrt(dyad_data.number.cog_out_pre);
%       post
dyad_data.durations.cog_out_post = zeros(dyad_data.number.cog_out_post,cognitive_categories);
for n = 1:dyad_data.number.cog_out_post
   current_data = read_data_file(files_cog_out_post(n).name);
   dyad_data.raw.cog_out_post{n} = current_data;
   dyad_data.filename.cog_out_post{n} = files_cog_out_post(n).name;
   number_of_behaviours = size(current_data,1);
   for m = 1:number_of_behaviours
      dyad_data.durations.cog_out_post(n,current_data(m,1)) = ...
         dyad_data.durations.cog_out_post(n,current_data(m,1)) ...
         + current_data(m,3) - current_data(m,2);
      % Do some basic checks on correctness of data
      if m == 1
         if current_data(m,2) ~= 0
            warning(['Start time != 0 in: ' files_cog_out_post(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      else
         if current_data(m,2) ~= current_data(m-1,3)
            warning(['Stop/start time mismatch in: ' files_cog_out_post(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      end
      if current_data(m,3) <= current_data(m,2)
         warning(['Stop time <= start time in: ' files_cog_out_post(n).name ]);
         fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
      end
   end
   dyad_data.durations.cog_out_post(n,:) = ...
      dyad_data.durations.cog_out_post(n,:)/current_data(end,3);
   if abs( sum(dyad_data.durations.cog_out_post(n,:)) - 1 ) > 10*eps
      warning(['Durations in ' dyad_data.filename.cog_out_post{n} ' do not add up to 1!']);
   end
end
dyad_data.mean_duration.cog_out_post = mean(dyad_data.durations.cog_out_post,1);
dyad_data.sd_duration.cog_out_post = std(dyad_data.durations.cog_out_post,0,1);
dyad_data.error_duration.cog_out_post = ...
   dyad_data.sd_duration.cog_out_post / sqrt(dyad_data.number.cog_out_post);

% social
%    indoor
%       pre
dyad_data.durations.soc_in_pre = zeros(dyad_data.number.soc_in_pre,social_categories);
for n = 1:dyad_data.number.soc_in_pre
   current_data = read_data_file(files_soc_in_pre(n).name);
   dyad_data.raw.soc_in_pre{n} = current_data;
   dyad_data.filename.soc_in_pre{n} = files_soc_in_pre(n).name;
   number_of_behaviours = size(current_data,1);
   for m = 1:number_of_behaviours
      dyad_data.durations.soc_in_pre(n,current_data(m,1)) = ...
         dyad_data.durations.soc_in_pre(n,current_data(m,1)) ...
         + current_data(m,3) - current_data(m,2);
      % Do some basic checks on correctness of data
      if m == 1
         if current_data(m,2) ~= 0
            warning(['Start time != 0 in: ' files_soc_in_pre(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      else
         if current_data(m,2) ~= current_data(m-1,3)
            warning(['Stop/start time mismatch in: ' files_soc_in_pre(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      end
      if current_data(m,3) <= current_data(m,2)
         warning(['Stop time <= start time in: ' files_soc_in_pre(n).name ]);
         fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
      end
   end
   dyad_data.durations.soc_in_pre(n,:) = ...
      dyad_data.durations.soc_in_pre(n,:)/current_data(end,3);
   if abs( sum(dyad_data.durations.soc_in_pre(n,:)) - 1 ) > 10*eps
      warning(['Durations in ' dyad_data.filename.soc_in_pre{n} ' do not add up to 1!']);
   end
end
dyad_data.mean_duration.soc_in_pre = mean(dyad_data.durations.soc_in_pre,1);
dyad_data.sd_duration.soc_in_pre = std(dyad_data.durations.soc_in_pre,0,1);
dyad_data.error_duration.soc_in_pre = ...
   dyad_data.sd_duration.soc_in_pre / sqrt(dyad_data.number.soc_in_pre);
%       post
dyad_data.durations.soc_in_post = zeros(dyad_data.number.soc_in_post,social_categories);
for n = 1:dyad_data.number.soc_in_post
   current_data = read_data_file(files_soc_in_post(n).name);
   dyad_data.raw.soc_in_post{n} = current_data;
   dyad_data.filename.soc_in_post{n} = files_soc_in_post(n).name;
   number_of_behaviours = size(current_data,1);
   for m = 1:number_of_behaviours
      dyad_data.durations.soc_in_post(n,current_data(m,1)) = ...
         dyad_data.durations.soc_in_post(n,current_data(m,1)) ...
         + current_data(m,3) - current_data(m,2);
      % Do some basic checks on correctness of data
      if m == 1
         if current_data(m,2) ~= 0
            warning(['Start time != 0 in: ' files_soc_in_post(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      else
         if current_data(m,2) ~= current_data(m-1,3)
            warning(['Stop/start time mismatch in: ' files_soc_in_post(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      end
      if current_data(m,3) <= current_data(m,2)
         warning(['Stop time <= start time in: ' files_soc_in_post(n).name ]);
         fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
      end
   end
   dyad_data.durations.soc_in_post(n,:) = ...
      dyad_data.durations.soc_in_post(n,:)/current_data(end,3);
   if abs( sum(dyad_data.durations.soc_in_post(n,:)) - 1 ) > 10*eps
      warning(['Durations in ' dyad_data.filename.soc_in_post{n} ' do not add up to 1!']);
   end
end
dyad_data.mean_duration.soc_in_post = mean(dyad_data.durations.soc_in_post,1);
dyad_data.sd_duration.soc_in_post = std(dyad_data.durations.soc_in_post,0,1);
dyad_data.error_duration.soc_in_post = ...
   dyad_data.sd_duration.soc_in_post / sqrt(dyad_data.number.soc_in_post);
%    outdoor
%       pre
dyad_data.durations.soc_out_pre = zeros(dyad_data.number.soc_out_pre,social_categories);
for n = 1:dyad_data.number.soc_out_pre
   current_data = read_data_file(files_soc_out_pre(n).name);
   dyad_data.raw.soc_out_pre{n} = current_data;
   dyad_data.filename.soc_out_pre{n} = files_soc_out_pre(n).name;
   number_of_behaviours = size(current_data,1);
   for m = 1:number_of_behaviours
      dyad_data.durations.soc_out_pre(n,current_data(m,1)) = ...
         dyad_data.durations.soc_out_pre(n,current_data(m,1)) ...
         + current_data(m,3) - current_data(m,2);
      % Do some basic checks on correctness of data
      if m == 1
         if current_data(m,2) ~= 0
            warning(['Start time != 0 in: ' files_soc_out_pre(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      else
         if current_data(m,2) ~= current_data(m-1,3)
            warning(['Stop/start time mismatch in: ' files_soc_out_pre(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      end
      if current_data(m,3) <= current_data(m,2)
         warning(['Stop time <= start time in: ' files_soc_out_pre(n).name ]);
         fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
      end
   end
   dyad_data.durations.soc_out_pre(n,:) = ...
      dyad_data.durations.soc_out_pre(n,:)/current_data(end,3);
   if abs( sum(dyad_data.durations.soc_out_pre(n,:)) - 1 ) > 10*eps
      warning(['Durations in ' dyad_data.filename.soc_out_pre{n} ' do not add up to 1!']);
   end
end
dyad_data.mean_duration.soc_out_pre = mean(dyad_data.durations.soc_out_pre,1);
dyad_data.sd_duration.soc_out_pre = std(dyad_data.durations.soc_out_pre,0,1);
dyad_data.error_duration.soc_out_pre = ...
   dyad_data.sd_duration.soc_out_pre / sqrt(dyad_data.number.soc_out_pre);
%       post
dyad_data.durations.soc_out_post = zeros(dyad_data.number.soc_out_post,social_categories);
for n = 1:dyad_data.number.soc_out_post
   current_data = read_data_file(files_soc_out_post(n).name);
   dyad_data.raw.soc_out_post{n} = current_data;
   dyad_data.filename.soc_out_post{n} = files_soc_out_post(n).name;
   number_of_behaviours = size(current_data,1);
   for m = 1:number_of_behaviours
      dyad_data.durations.soc_out_post(n,current_data(m,1)) = ...
         dyad_data.durations.soc_out_post(n,current_data(m,1)) ...
         + current_data(m,3) - current_data(m,2);
      % Do some basic checks on correctness of data
      if m == 1
         if current_data(m,2) ~= 0
            warning(['Start time != 0 in: ' files_soc_out_post(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      else
         if current_data(m,2) ~= current_data(m-1,3)
            warning(['Stop/start time mismatch in: ' files_soc_out_post(n).name ]);
            fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
         end
      end
      if current_data(m,3) <= current_data(m,2)
         warning(['Stop time <= start time in: ' files_soc_out_post(n).name ]);
         fprintf(1,'Data: %d %d %d\n\n',current_data(m,:));   
      end
   end
   dyad_data.durations.soc_out_post(n,:) = ...
      dyad_data.durations.soc_out_post(n,:)/current_data(end,3);
   if abs( sum(dyad_data.durations.soc_out_post(n,:)) - 1 ) > 10*eps
      warning(['Durations in ' dyad_data.filename.soc_out_post{n} ' do not add up to 1!']);
   end
end
dyad_data.mean_duration.soc_out_post = mean(dyad_data.durations.soc_out_post,1);
dyad_data.sd_duration.soc_out_post = std(dyad_data.durations.soc_out_post,0,1);
dyad_data.error_duration.soc_out_post = ...
   dyad_data.sd_duration.soc_out_post / sqrt(dyad_data.number.soc_out_post);

% Find combined scores, and errors in scores
% dyad_data.score.cog_in_pre   = dyad_data.mean_duration.cog_in_pre * cognitive_weights;
% dyad_data.score.cog_in_post  = dyad_data.mean_duration.cog_in_post * cognitive_weights;
% dyad_data.score.cog_out_pre  = dyad_data.mean_duration.cog_out_pre * cognitive_weights;
% dyad_data.score.cog_out_post = dyad_data.mean_duration.cog_out_post * cognitive_weights;
% dyad_data.score.soc_in_pre   = dyad_data.mean_duration.soc_in_pre * social_weights;
% dyad_data.score.soc_in_post  = dyad_data.mean_duration.soc_in_post * social_weights;
% dyad_data.score.soc_out_pre  = dyad_data.mean_duration.soc_out_pre * social_weights;
% dyad_data.score.soc_out_post = dyad_data.mean_duration.soc_out_post * social_weights;
% 
% dyad_data.score_error.cog_in_pre = ...
%    dyad_data.mean_duration.cog_in_pre.*dyad_data.error_duration.cog_in_pre * cognitive_weights;
% dyad_data.score_error.cog_in_post = ...
%    dyad_data.mean_duration.cog_in_post.*dyad_data.error_duration.cog_in_post * cognitive_weights;
% dyad_data.score_error.cog_out_pre = ...
%    dyad_data.mean_duration.cog_out_pre.*dyad_data.error_duration.cog_out_pre * cognitive_weights;
% dyad_data.score_error.cog_out_post = ...
%    dyad_data.mean_duration.cog_out_post.*dyad_data.error_duration.cog_out_post * cognitive_weights;
% dyad_data.score_error.soc_in_pre = ...
%    dyad_data.mean_duration.soc_in_pre.*dyad_data.error_duration.soc_in_pre * social_weights;
% dyad_data.score_error.soc_in_post = ...
%    dyad_data.mean_duration.soc_in_post.*dyad_data.error_duration.soc_in_post * social_weights;
% dyad_data.score_error.soc_out_pre = ...
%    dyad_data.mean_duration.soc_out_pre.*dyad_data.error_duration.soc_out_pre * social_weights;
% dyad_data.score_error.soc_out_post = ...
%    dyad_data.mean_duration.soc_out_post.*dyad_data.error_duration.soc_out_post * social_weights;

dyad_data.session_score.cog_in_pre   = dyad_data.durations.cog_in_pre * cognitive_weights;
dyad_data.session_score.cog_in_post  = dyad_data.durations.cog_in_post * cognitive_weights;
dyad_data.session_score.cog_out_pre  = dyad_data.durations.cog_out_pre * cognitive_weights;
dyad_data.session_score.cog_out_post = dyad_data.durations.cog_out_post * cognitive_weights;
dyad_data.session_score.soc_in_pre   = dyad_data.durations.soc_in_pre * social_weights;
dyad_data.session_score.soc_in_post  = dyad_data.durations.soc_in_post * social_weights;
dyad_data.session_score.soc_out_pre  = dyad_data.durations.soc_out_pre * social_weights;
dyad_data.session_score.soc_out_post = dyad_data.durations.soc_out_post * social_weights;

dyad_data.score.cog_in_pre   = mean(dyad_data.session_score.cog_in_pre);
dyad_data.score.cog_in_post  = mean(dyad_data.session_score.cog_in_post);
dyad_data.score.cog_out_pre  = mean(dyad_data.session_score.cog_out_pre);
dyad_data.score.cog_out_post = mean(dyad_data.session_score.cog_out_post);
dyad_data.score.soc_in_pre   = mean(dyad_data.session_score.soc_in_pre);
dyad_data.score.soc_in_post  = mean(dyad_data.session_score.soc_in_post);
dyad_data.score.soc_out_pre  = mean(dyad_data.session_score.soc_out_pre);
dyad_data.score.soc_out_post = mean(dyad_data.session_score.soc_out_post);

dyad_data.score_sd.cog_in_pre   = std(dyad_data.session_score.cog_in_pre);
dyad_data.score_sd.cog_in_post  = std(dyad_data.session_score.cog_in_post);
dyad_data.score_sd.cog_out_pre  = std(dyad_data.session_score.cog_out_pre);
dyad_data.score_sd.cog_out_post = std(dyad_data.session_score.cog_out_post);
dyad_data.score_sd.soc_in_pre   = std(dyad_data.session_score.soc_in_pre);
dyad_data.score_sd.soc_in_post  = std(dyad_data.session_score.soc_in_post);
dyad_data.score_sd.soc_out_pre  = std(dyad_data.session_score.soc_out_pre);
dyad_data.score_sd.soc_out_post = std(dyad_data.session_score.soc_out_post);

dyad_data.score_error.cog_in_pre   = dyad_data.score_sd.cog_in_pre / sqrt(dyad_data.number.cog_in_pre);
dyad_data.score_error.cog_in_post  = dyad_data.score_sd.cog_in_post / sqrt(dyad_data.number.cog_in_post);
dyad_data.score_error.cog_out_pre  = dyad_data.score_sd.cog_out_pre / sqrt(dyad_data.number.cog_out_pre);
dyad_data.score_error.cog_out_post = dyad_data.score_sd.cog_out_post / sqrt(dyad_data.number.cog_out_post);
dyad_data.score_error.soc_in_pre   = dyad_data.score_sd.soc_in_pre / sqrt(dyad_data.number.soc_in_pre);
dyad_data.score_error.soc_in_post  = dyad_data.score_sd.soc_in_post / sqrt(dyad_data.number.soc_in_post);
dyad_data.score_error.soc_out_pre  = dyad_data.score_sd.soc_out_pre / sqrt(dyad_data.number.soc_out_pre);
dyad_data.score_error.soc_out_post = dyad_data.score_sd.soc_out_post / sqrt(dyad_data.number.soc_out_post);

return

function session_data = read_data_file(filename)
   current_file = fopen(filename,'r');
   data_remaining = 1;
   session_data = [];
   while data_remaining
      current_line = fgets(current_file);
      if current_line(1) > '0' & current_line(1) < '9'
         current_data = sscanf(current_line,'%d,%d,%d');
         if length(current_data) ~= 3
            error(filename);
         end
         if isempty(session_data)
            session_data = current_data.';
         else
            session_data = [ session_data; current_data.' ];
         end
         if current_data(3) >= 360
            data_remaining = 0;
         end
      end
      if current_line(1) == '*'
         data_remaining = 0;
      end
      if current_line == -1
         data_remaining = 0;
      end
   end
   fclose(current_file);
   if isempty(session_data)
      warning(['Data file ' filename ' contains no data!']);
   end
return

