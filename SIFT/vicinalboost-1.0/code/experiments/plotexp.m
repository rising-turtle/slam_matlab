function plotexp(rs, aggr, split, print_path)
% PLOTEXP  Plot experiment results
%
%  PLOTEXP(RS, AGGR) plot the experiments RS. AGGR is a cell array of
%  string listing the fileds of the RS structure that should be used
%  to identify uniquely an experiment (experiments with the same
%  values of this field are treated as equivalent folds and aggregate
%  in the plotted statistics).

cfg.do_bars = 1 ;

rs = [rs{:}] ;

if nargin < 3 || isequal(split, [])
  split = aggr{end} ;
end

if nargin < 3
  print_path = [] ;
end

styles = { { 'color', [1 .75 .75], 'linestyle', '--', 'marker', 'none' }, ...
           { 'color', [1 .5   .5], 'linestyle', '-', 'marker', 'none' }, ...
           { 'color', [1  0    0], 'linestyle', '-', 'marker', '.' }, ...
           { 'color', [.75 1 .75], 'linestyle', '--', 'marker', 'none' }, ...
           { 'color', [.5  1  .5], 'linestyle', '-', 'marker', 'none' }, ...
           { 'color', [0   1   0], 'linestyle', '-', 'marker', '.' }, ...
           { 'color', [.75 .75 1], 'linestyle', '--', 'marker', 'none' }, ...
           { 'color', [.5  .5  1], 'linestyle', '-', 'marker', 'none' }, ...
           { 'color', [0   0   1], 'linestyle', '-', 'marker', '.' } } ;

% --------------------------------------------------------------------
%                                      Aggregate and split experiments
% --------------------------------------------------------------------
% The fields in SPLIT are used to divide the experiments in
% multplipe figures.

% valies assumed by the split fields
splitr  = unique_cells({rs.(split)}) ;

% remove from aggr fields the one appearing among the split fields
aggr_ = aggr ;
aggr_(strcmp(split, aggr_)) = [] ;

% -------------------------------------------------------------------
%                                             For each split a figure
% -------------------------------------------------------------------

for splitv = splitr
  
  legend_content = {} ;
	bar_data = [] ;
  
  % create a new figure
  figure(find(splitv == splitr)) ; clf ; 
	subplot(2,1,1) ; hold on ;
    
  % find subset of experiments with this value of the split parameter
  sel_split = find_cells({rs.(split)}, splitv) ;
  rs_split  = rs(sel_split) ;
  
  % for all experiment in the split, aggregate the data and plot
  % the corresponding curves
  n_curve = 1 ;
  while ~ isempty(rs_split)
    % ---------------------------------------------------------------
    %                                                 For this figure
    % ---------------------------------------------------------------
		% Aggregate folds
    sel_aggr = 1:length(rs_split) ;
		legend_content{end+1} = '' ;
		
    for af = aggr_      
      % value of the next aggr field
      af = af{1} ;
      aggrv = rs_split(1).(af) ;
      
      % find all experiments with that value of the aggr field
      sel_aggr = intersect(sel_aggr, find_cells({rs_split.(af)}, aggrv)) ;

			legend_content{end} = [legend_content{end} ...
                    sprintf('%s=%g ', af, aggrv)] ;
    end
    
    % collect error curves
    e01 = rs_split(sel_aggr(1)).e01t ;
    for s=sel_aggr(2:end)
      e01 = [e01 ; rs_split(s).e01t] ;
    end
		
		std_e01 = std(e01,1) ;
		avg_e01 = mean(e01,1) ;
		
		% add to bar data
		bar_data = [bar_data, ...
								[mean(avg_e01(end-3:end)); mean(std_e01(end-3:end)) ; ] ];
				
    % plot
    if cfg.do_bars
			prec = std_e01 / sqrt(length(sel_aggr)) ;
      h = errorbar(1:size(e01,2), 100 * avg_e01, 100 * prec) ;
    else
      h = plot(1:size(e01,2), 100*mean(e01,1)) ;
    end

		if n_curve <= length(styles)
			set(h, styles{n_curve}{:}) ;
		else
			extra_cols = jet(256) ;
			set(h, 'color', extra_cols(n_curve, :)) ;
		end
    yl = get(gca,'ylim') ; yl(1)=0; set(gca,'ylim',yl) ;
    xlim([0 size(e01,2)]) ;
		
    % remove the aggregate set of experiments from the split
    rs_split(sel_aggr)  = [] ;
    
    % next curve
    n_curve = n_curve + 1 ;
		
%		keyboard
  end
    
	if n_curve <= 10
		h=legend(legend_content{:},'location','northeastoutside') ;
	else
		h=legend(legend_content{1:10},'...','location','northeastoutside') ;
	end
	for k=1:length(legend_content)
		fprintf('%5d: %s\n', k, legend_content{k}) ;
	end
  set(h,'interpreter','none')
  xlabel('num. WCs') ;
  ylabel('test error (%)') ;  
  ylim([0 30]) ;
  title(sprintf('%s = %g', split, splitv)) ;
	
	% bar plot
	subplot(2,1,2) ;
	clear bard ;
	bard(1,:) = bar_data(1,:) - bar_data(2,:) ;
	bard(2,:) = bar_data(2,:) ;
	bard(3,:) = bar_data(2,:) ;
	bar(bard','stacked') ;
	xlabel('curve number') ;
	
	if ~isempty(print_path)
		name = [print_path sprintf('-%d',find(splitv == splitr))] ;		
		print(fullfile('figures', name),'-depsc') ; 
	end
end

% --------------------------------------------------------------------
function b = unique_cells(a)
% --------------------------------------------------------------------

if isnumeric(a{1})
  b = unique([a{:}]) ;
else
  b = unique(a) ;
end

% --------------------------------------------------------------------
function b = find_cells(a, x)
% --------------------------------------------------------------------

b = [] ;

for t = 1:numel(a) 
  if isequal(a{t}, x), b = [b t] ; end 
end
