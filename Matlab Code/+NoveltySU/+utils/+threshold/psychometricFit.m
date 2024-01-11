function [R2,yFit,fitRes,Threshold,norx, xFit] = psychometricFit(be,plotYN,defopt,varargin)

for i = 1:2:length(varargin)
    eval([ varargin{i} '=varargin{i+1};']);
end
parseStruct(defopt);

if plotYN
    figure
end

if size(be,2) > 1
    hh = waitbar(0,'please wait');
end
for i=1:size(be,2)
    if size(be,2) > 1
        str=['Fitting, current: ' num2str(i) , '(' num2str(i) '/' num2str(size(be,2)) ')' ];
        waitbar(i/size(be,2),hh,str);
    end
    if exist('lanmuda','var')
        x = lanmuda';%(:,i)
    end
    if x(1) < x(end)
        %         xFit = x(1):1e-3:x(end);
        xFit = linspace(x(1), x(end), 1000);
    else
        xFit = linspace(x(end), x(1), 1000);
    end
    y = be(:,i);
    method = defopt.fitMethod;
    if ~iscell(method) && ischar(method)
        method = cellstr(method);
    end
    for methodN = 1:length(method)
        switch method{methodN}
            %% sigmoid
            case 'sigmoid'
                try
                    % Define Start points, fit-function and fit curve
                    x0 = [1 0];
                    fitfun = fittype( @(a,b,x) 1./(1+exp(-a*x-b)));
                    [fitresult,gof] = fit(x,y,fitfun,'StartPoint',x0);

                    yFit = 1./(1+exp(-fitresult.a*xFit-fitresult.b));
                    fitLoop = 0;
                    while (yFit(1)>0.2 || yFit(1) <0 || yFit(end)<0.8) && fitLoop<20
                        try
                            fitLoop = fitLoop + 1;
                            [fitresult,gof] = fit(x,y,fitfun,'StartPoint',x0);
                            yFit = 1./(1+exp(-fitresult.a*xFit-fitresult.b));
                        catch
                            continue
                        end
                    end
                    fitRes = fitresult;
                    norx = x;

                    %计算阈值
                    Threshold = find(1./(1+exp(-fitresult.a*xFit-fitresult.b)) >= yThr, 1, "first");
                    if isempty(Threshold)
                        Threshold = xThr;
                    elseif Threshold > xThr
                        Threshold = xThr;
                    end
                    fitSuccsess = true;
                    %plot（yes/no）
                    if plotYN
                        subplot(2,2,1)
                        h = plot( fitresult, x, y );hold on;
                        legend('off')

                        % Label axes
                        xlabel( 'x', 'Interpreter', 'none' );
                        ylabel( 'y', 'Interpreter', 'none' );
                        title('sigmoid')
                    end
                    R2=gof.rsquare;
                catch
                    R2=-1;
                    Threshold = xThr;
                end
                %% logistic
            case 'logistic'
                try

                    [xData, yData] = prepareCurveData( x, y );
                    ft = fittype( '1-1./(1+(x/a)^b)', 'independent', 'x', 'dependent', 'y' );
                    [fitresult, gof] = fit( xData, yData, ft );
                    yFit  = 1-1./(1+(xFit/fitresult.a).^fitresult.b);
                    fitLoop = 0;
                    while (yFit(1)>0.2 || yFit(1) <0 || yFit(end)<0.8) && fitLoop<20
                        try
                            fitLoop = fitLoop + 1;
                            [fitresult, gof] = fit( xData, yData, ft);
                            yFit = 1-1./(1+(xFit/fitresult.a).^fitresult.b);
                        catch
                            continue
                        end
                    end
                    fitRes = fitresult;
                    norx = x;

                    %计算阈值
                    Threshold = find(1-1./(1+(xFit/fitresult.a).^fitresult.b) >= yThr, 1, "first");
                    if isempty(Threshold)
                        Threshold = xThr;
                    elseif Threshold > xThr
                        Threshold = xThr;
                    end

                    %plot（yes/no）
                    if plotYN
                        % Plot fit with data.
                        subplot(2,2,2)
                        h = plot( fitresult, xData, yData );hold on;
                        legend('off')

                        % Label axes
                        xlabel( 'x', 'Interpreter', 'none' );
                        ylabel( 'y', 'Interpreter', 'none' );
                        title('logistic')
                    end
                    R2=gof.rsquare;
                catch
                    R2=-1;
                    Threshold = xThr;
                end
                %% weibull
            case 'weibull'
                try

                    [xData, yData] = prepareCurveData( x, y );
                    ft = fittype( '1-exp(-(x/a)^b)', 'independent', 'x', 'dependent', 'y' );
                    [fitresult, gof] = fit( xData, yData, ft );
                    yFit = 1-exp(-(xFit/fitresult.a).^fitresult.b);
                    fitLoop = 0;
                    while (yFit(1)>0.2 || yFit(1) <0 || yFit(end)<0.8) && fitLoop<20
                        try
                            fitLoop = fitLoop + 1;
                            [fitresult, gof] = fit( xData, yData, ft);
                            yFit = 1-exp(-(xFit/fitresult.a).^fitresult.b);
                        catch
                            continue
                        end
                    end
                    fitRes = fitresult;
                    norx = x;

                    %计算阈值
                    Threshold = find(1-exp(-(xFit/fitresult.a).^fitresult.b) >= yThr, 1, "first");
                    if isempty(Threshold)
                        Threshold = xThr;
                    elseif Threshold > xThr
                        Threshold = xThr;
                    end

                    %plot（yes/no）
                    if plotYN
                        % Plot fit with data.
                        subplot(2,2,3)
                        h = plot( fitresult, xData, yData );hold on;
                        legend('off')

                        % Label axes
                        xlabel( 'x', 'Interpreter', 'none' );
                        ylabel( 'y', 'Interpreter', 'none' );
                        title('webull')
                    end
                    R2=gof.rsquare;
                catch
                    R2=-1;
                    Threshold = xThr;
                end
                %% gaussint
            case 'gaussint'
                try
                    clear solx
                    [xData, yData] = prepareCurveData( x, y );
                    %                     ft = fittype( 'erf(c*x-b/(sqrt(2)*a))', 'independent', 'x', 'dependent', 'y' );
                    ft = fittype( '(erf(c*x-a)-erf(-a))/2', 'independent', 'x', 'dependent', 'y' );
                    try
                        [fitresult, gof] = fit( xData, yData, ft);
                        %                         yFit = erf(fitresult.c*xFit-fitresult.b/(sqrt(2)*fitresult.a));
                        yFit = (erf(fitresult.c*xFit-fitresult.a)-erf(-fitresult.a))/2;
                    catch
                        fitresult = [];
                        yFit = zeros(1,sampleRate+1);
                    end
                    fitLoop = 0;
                    while yFit(end) < 0 || yFit(1) > 0.99 || (yFit(end) < yThr) && fitLoop<20
                        try
                            fitLoop = fitLoop + 1;
                            [fitresult, gof] = fit( xData, yData, ft);
                            %                             yFit = erf(fitresult.c*xFit-fitresult.b/(sqrt(2)*fitresult.a));
                            yFit = (erf(fitresult.c*xFit-fitresult.a)-erf(-fitresult.a))/2;
                        catch
                            continue
                        end
                    end

                    if yFit(end) < yThr && yFit(end) > yFit(1)
                        if xFit(end) < 3
                            xData = [xData; 3];
                            xFit = linspace(xData(1), 3, 2000);
                        elseif xFit(end) < 5
                            xData = [xData; 5];
                            xFit = linspace(xData(1), 5, 3000);
                        else
                            xData = [xData; 6];
                            xFit = linspace(xData(1), 6, 4000);
                        end
                        yData = [yData; 1];
                        [fitresult, gof] = fit( xData, yData, ft);
                        %                         yFit = erf(fitresult.c*xFit-fitresult.b/(sqrt(2)*fitresult.a));
                        yFit = (erf(fitresult.c*xFit-fitresult.a)-erf(-fitresult.a))/2;
                    end
                    fitRes = fitresult;
                    norx = x;

                    %计算阈值
                    Threshold = xFit(find(yFit >= yThr, 1, "first"));
                    if isempty(Threshold)
                        Threshold = xThr;
                    elseif Threshold > xThr
                        Threshold = xThr;
                    end
                    %plot（yes/no）
                    if plotYN
                        subplot(2,2,4)
                        h = plot( fitresult, xData, yData );hold on;

                        legend('off')
                        % Label axes
                        xlabel( 'x', 'Interpreter', 'none' );
                        ylabel( 'y', 'Interpreter', 'none' );
                        ylim([0 1]);
                        title('gaussint')
                    end
                    R2=gof.rsquare;
                catch
                    R2=-1;

                    norx = x;
                    Threshold = xThr;
                end
        end
    end
end
if size(be,2) > 1
    delete(hh);
end
% figure
% for i=1:4
% subplot(2,2,i)
% nbins=0:0.2:2;
% histogram(R2{i},nbins)
% title(num2str(mean(R2{i}(find(R2{i}(:)>0),1))))
% end
