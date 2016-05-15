function perf = mse(net,varargin)
persistent INFO;
if isempty(INFO), INFO = nnModuleInfo(mfilename); end
if nargin == 0, perf = INFO; return; end

% NNET Backward Compatibility
% WARNING - This functionality may be removed in future versions
if ischar(net) && strcmp(net,'info')
  perf = INFO; return
elseif ischar(net) || ~(isa(net,'network') || isstruct(net))
  perf = nnet7.performance_fcn(mfilename,net,varargin{:}); return
end

% Arguments
param = nn_modular_fcn.parameter_defaults(mfilename);
[args,param,nargs] = nnparam.extract_param(varargin,param);
if (nargs < 2), error(message('nnet:Args:NotEnough')); end
t = args{1};
y = args{2};
if nargs < 3, ew = {1}; else ew = varargin{3}; end
net.performParam = param;
net.performFcn = mfilename;

% Apply
perf = nncalc.perform(net,t,y,ew,param);
