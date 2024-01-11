function protName = protNameTable(behaviorType, MATNAME)
if contains(MATNAME, "neu139") && strcmpi(behaviorType, "behavior1")
    behaviorType = "behavior8";
end

if contains(MATNAME, "neu139") && strcmpi(behaviorType, "nobehavior1")
    behaviorType = "nobehavior8";
end

if contains(MATNAME, "neuInt") && strcmpi(behaviorType, "behavior4")
    behaviorType = "behaviorInt";
end

if contains(MATNAME, "neuInt") && strcmpi(behaviorType, "nobehavior4")
    behaviorType = "nobehaviorInt";
end

protName = [];
switch behaviorType
    case "behaviorInt"
        protName = "ActiveIntLow";
    case "nobehaviorInt"
        protName = "PassiveIntLow"; 
    case "behavior1"
        protName = "ActiveFreqRight";
    case "nobehavior1"
        protName = "PassiveFreqRight";
    case "behavior2"
        protName = "ActiveFreqLeft";
    case "nobehavior2"
        protName = "PassiveFreqLeft";
    case "behavior4"
        protName = "ActiveFreqNoResponse";
    case "nobehavior4"
        protName = "PassiveFreqNoResponse";
    case "behavior5"
        protName = "ActiveNoneFreqRight";
    case "nobehavior5"
        protName = "PassiveNoneFreqRight";  
    case "behavior8"
        protName = "ActiveFreq139";
    case "nobehavior8"
        protName = "PassiveFreq139";
    case "tone"
        protName = "ToneCF";
    case "noise"
        protName = "Noise";
end
if isempty(protName)
    protName = behaviorType;
end
end