function playAudio(y, varargin)
    % Play sound with PTB on a two-channel output device (default of system)
    %
    % playAudio(y, fsSound)
    % playAudio(y, fsSound, fsDevice)
    % playAudio(filepath)
    % playAudio(filepath, fsDevice)
    %
    % NOTICE: There is an approximate 100-ms delay time before playback 
    %         to prevent burst sound caused by sudden change from zero.
    % [y] is a 2-D sound wave, a sound wave vector or a sound file path.
    % [fsSound] is samplerate of sound [y].
    % If [y] is sound wave, [fsSound] should not be empty.
    % [fsDevice] is samplerate of output device (default: []).

    mIp = inputParser;
    mIp.addRequired("y", @(x) (isa(x, "double") && ndims(x) == 2) || ischar(x) || isstring(x));
    mIp.addOptional("fs", [], @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));
    mIp.addOptional("fsDevice", [], @(x) validateattributes(x, {'numeric'}, {'positive', 'scalar'}));
    mIp.parse(y, varargin{:});

    switch class(y)
        case "double"
            fsSound = mIp.Results.fs;
            fsDevice = mIp.Results.fsDevice;

            if isempty(fsSound)
                error("fsSound should not be empty for sound wave input");
            end

        case "char"
            [y, fsSound] = audioread(y);
            fsDevice = mIp.Results.fs;
        case "string"
            [y, fsSound] = audioread(y);
            fsDevice = mIp.Results.fs;
        otherwise
            error("Invalid syntax");
    end

    [a, b] = size(y);

    if a > b
        y = y(:, 1)';
    else
        y = y(1, :);
    end
    
    if ~isempty(fsDevice) && ~isequal(fsSound, fsDevice)
        disp(['Resample from ', num2str(fsSound), ' Hz to device sample rate ', num2str(fsDevice), ' Hz']);
        y = resampleData(y, fsSound, fsDevice);
    end

    y = repmat(y, [2, 1]);

    %% Play Audio
    InitializePsychSound;
    PsychPortAudio('Close');

    deviceId = []; % use default device of system
    mode = 1; % playback only
    latencyClass = 3; % strict

    pahandle = PsychPortAudio('Open', deviceId, mode, latencyClass);

    % To prevent burst sound caused by sudden change from zero
    PsychPortAudio('FillBuffer', pahandle, [zeros(1, 10); zeros(1, 10)]);
    PsychPortAudio('Start', pahandle, 1, 0, 1);
    st = PsychPortAudio('Stop', pahandle, 1, 1);

    % Play sound
    delay = 0.1; % sec
    PsychPortAudio('FillBuffer', pahandle, y);
    PsychPortAudio('Start', pahandle, 1, st + delay, 1);
    PsychPortAudio('Stop', pahandle, 1, 1);

    PsychPortAudio('Close');
end