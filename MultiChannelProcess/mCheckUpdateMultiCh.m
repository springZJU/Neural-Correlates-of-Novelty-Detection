function mCheckUpdateMultiCh(logstr, syncOpt)
    % Commit your work and check update for current project.
    % Putting it in your startup.m is RECOMMENDED.
    % To use it for other projects, rename and put it in the root path of the project.
    %
    % logstr: log information, in string or char
    % syncOpt: if set true, your local change will be pushed to remote. (default: false)

    narginchk(0, 2);

    if nargin < 2
        syncOpt = false;
    end
    
    currentPath = pwd;
    cd(fileparts(mfilename("fullpath")));
    [~, currentUser] = system("whoami");
    currentUser = split(currentUser, '\');
    
    system("git add .");

    if nargin < 1 || isempty(char(logstr))
        system(strcat("git commit -m ""update ", string(datetime), " by ", currentUser{1}, """"));
    else
        logstr = strrep(logstr, '"', '""');
        system(strcat("git commit -m """, logstr, """"));
    end

    system("git pull origin main");

    if syncOpt
        system("git push origin main");
    end
    
    cd(currentPath);
    return;
end