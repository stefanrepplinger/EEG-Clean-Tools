function [paramsOut] = lineNoiseGUI(hObject, callbackdata, inputData)%#ok<INUSL>
theTitle = 'Clean line noise parameters';
defaultStruct = inputData.userData.lineNoise;

while(true)
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    if isempty(userdata) || ~isfield(userdata, 'lineNoise')
        paramsOut = struct();
    else
        paramsOut = userdata.lineNoise;
    end
    [defaultStruct, errors] = checkStructureDefaults(paramsOut, defaultStruct);
    
    if ~isempty(errors)
        warning('lineNoiseGUI:bad parameters', getMessageString(errors)); %#ok<CTPCT>
    end
    
    % Creates structure for
    fNamesDefault = fieldnames(defaultStruct);
    for k = 1:length(fNamesDefault)
        textColorStruct.(fNamesDefault{k}) = 'k';
    end
    
    closeOpenWindows(theTitle);
    geometry = {[1,2.5], [1,2.5], 1, [1, .75, 1, .75], ...
        [1, .75, 1, .75], [1, .75, 1, .75], [1, .75, 1, .75], ...
        [1, .75, 1, .75]};
    geomvert = [];
    uilist = {{'style', 'text', 'string', 'Line noise channels', ...
        'TooltipString', defaultStruct.lineNoiseChannels.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.lineNoiseChannels.value), ...
        'tag', 'lineNoiseChannels', 'ForegroundColor', ...
        textColorStruct.lineNoiseChannels}...
        {'style', 'text', 'string', 'Line frequencies removed', ...
        'TooltipString', defaultStruct.lineFrequencies.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.lineFrequencies.value), ...
        'tag', 'lineFrequencies', 'ForegroundColor', ...
        textColorStruct.lineFrequencies}...
        {'style', 'text', 'string', ''}...
        {'style', 'text', 'string', 'Sampling frequency', ...
        'TooltipString', defaultStruct.Fs.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.Fs.value), 'tag', ...
        'Fs', 'ForegroundColor', textColorStruct.Fs}...
        {'style', 'text', 'string', 'Significance level cutoff ("p")', ...
        'TooltipString', defaultStruct.p.description}...
        {'style', 'edit', 'string', num2str(defaultStruct.p.value), ...
        'tag', 'p', 'ForegroundColor', textColorStruct.p}...
        {'style', 'text', 'string', 'Significant line bandwidth', ...
        'TooltipString', defaultStruct.fScanBandWidth.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.fScanBandWidth.value), ...
        'tag', 'fScanBandWidth', 'ForegroundColor', ...
        textColorStruct.fScanBandWidth}...
        {'style', 'text', 'string', 'Taper bandwidth', 'TooltipString', ...
        defaultStruct.taperBandWidth.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.taperBandWidth.value), 'tag', ...
        'taperBandWidth', 'ForegroundColor', ...
        textColorStruct.taperBandWidth}...
        {'style', 'text', 'string', 'Taper window size', 'TooltipString', ...
        defaultStruct.taperWindowSize.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.taperWindowSize.value), ...
        'tag', 'taperWindowSize', 'ForegroundColor', ...
        textColorStruct.taperWindowSize}...
        {'style', 'text', 'string', 'FFT padding factor', ...
        'TooltipString', defaultStruct.pad.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.pad.value), ...
        'tag', 'pad', 'ForegroundColor', textColorStruct.pad}...
        {'style', 'text', 'string', 'Taper window step', ...
        'TooltipString', defaultStruct.taperWindowStep.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.taperWindowStep.value), ...
        'tag', 'taperWindowStep', 'ForegroundColor', ...
        textColorStruct.taperWindowStep}...
        {'style', 'text', 'string', 'Frequency band used', ...
        'TooltipString', defaultStruct.fPassBand.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.fPassBand.value), ...
        'tag', 'fPassBand', 'ForegroundColor', ...
        textColorStruct.fPassBand}...
        {'style', 'text', 'string', 'Window smoothing factor', ...
        'TooltipString', defaultStruct.tau.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.tau.value), ...
        'tag', 'tau', 'ForegroundColor', textColorStruct.tau}...
        {'style', 'text', 'string', 'Maximum iterations', ...
        'TooltipString', defaultStruct.maximumIterations.description}...
        {'style', 'edit', 'string', ...
        num2str(defaultStruct.maximumIterations.value), ...
        'tag', 'maximumIterations', 'ForegroundColor', ...
        textColorStruct.maximumIterations}};
    [~, ~, ~, paramsOut] = ...
        inputgui('geometry', geometry, 'geomvert', geomvert, ...
        'uilist', uilist, 'title', theTitle, 'helpcom', ...
        'pophelp(''pop_prepPipeline'')');
    if(isempty(paramsOut))
        break;
    end
    [paramsOut, typeErrors, fNamesErrors] = ...
        changeType(paramsOut, defaultStruct);
    mainFigure = findobj('Type', 'Figure', '-and', 'Name', inputData.name);
    userdata = get(mainFigure, 'UserData');
    userdata.lineNoise = paramsOut;
    set(mainFigure, 'UserData', userdata);
    if isempty(typeErrors)
        break;
    end
    textColorStruct = highlightErrors(fNamesErrors, ...
        fNamesDefault, textColorStruct);
    displayErrors(typeErrors); % Displays the errors and restarts GUI
    
end
end