%% Run through the high pass and look at the spectrum afterwards
pop_editoptions('option_single', false, 'option_savetwofiles', false);
params = struct();
indir = 'E:\\CTAData\\ARL_BCIT_Program\\STDL1'; % Input data directory used for this demo

%outdir = 'N:\\ARL_BCIT_Program\\Level2A';

outdir = 'N:\\ARL_BCIT_Program\\BCITStandardLevel2UnRef';
params.detrendType = 'high pass';
params.detrendCutoff = 0.3;

%% Get a list of the files in the driving data from level 1
in_list = dir(indir);
in_names = {in_list(:).name};
in_types = [in_list(:).isdir];
in_names = in_names(~in_types);
params.lineFrequencies = [60, 120, 180, 240];

%% Read in the data and high-pass filter it.
for k = 2000:length(in_names)
    ext = in_names{k}((end-3):end);
    if ~strcmpi(ext, '.set')
        continue;
    end
    basename = in_names{k}(1:(end-4));
    thisName = basename;
    fname = [indir filesep in_names{k}];
    fprintf('%d: %s\n', k, fname);
    EEG = pop_loadset(fname);
    EEG.data = double(EEG.data);
    chanblk = 32* floor(size(EEG.data, 1)/32);
    params.name = thisName;
    params.referenceChannels = 1:chanblk;
    params.evaluationChannels = 1:chanblk;
    params.rereferencedChannels = 1:(chanblk+6);
    params.detrendChannels = 1:(chanblk+6);
    params.lineNoiseChannels = 1:(chanblk+6);
    [EEG, computationTimes] = standardLevel2Pipeline(EEG, params);
    fprintf('Computation times (seconds):\n   %s\n', ...
        getStructureString(computationTimes));
    fname = [outdir filesep thisName '.set'];
    save(fname, 'EEG', '-mat', '-v7.3');
end