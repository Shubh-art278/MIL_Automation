function runUnitTestHarnessSingle()
    % Ask user to select the unit test model
    [modelFile, modelPath] = uigetfile('*.slx','Select the unit test harness model (.slx)');
    if isequal(modelFile,0), error('No model selected.'); end
    modelFullPath = fullfile(modelPath,modelFile);
    [~, baseName, ~] = fileparts(modelFullPath);

    % Open the model (leave it open)
    open_system(modelFullPath);

    % Run the model with StartTime=0 and StopTime from the model
    stopTime = get_param(baseName,'StopTime');
    simOutObj = sim(baseName,'StartTime','0','StopTime',stopTime);

    % Access simOut struct directly from SimulationOutput
    if isprop(simOutObj,'simOut')
        y = simOutObj.simOut;
        simTime = y.time;
        simData = y.signals.values;

        % Find referenced unit model inside harness
        modelBlocks = find_system(baseName,'SearchDepth',1,'BlockType','ModelReference');
        outputNames = {};
        if ~isempty(modelBlocks)
            refModel = get_param(modelBlocks{1},'ModelName');
            % Get Outports from the referenced model
            outPorts = find_system(refModel,'SearchDepth',1,'BlockType','Outport');
            if ~isempty(outPorts)
                portNums = cellfun(@str2double,get_param(outPorts,'Port'));
                [~,order] = sort(portNums);
                outputNames = get_param(outPorts(order),'Name');
                outputNames = reshape(outputNames,1,[]);
            end
        end

        % Adjust names to match signals
        numSignals = size(simData,2);
        if numSignals ~= numel(outputNames)
            warning('Mismatch in %s: %d signals vs %d Outports.', baseName, numSignals, numel(outputNames));
            if numSignals < numel(outputNames)
                outputNames = outputNames(1:numSignals);
            else
                extraNames = arrayfun(@(j) sprintf('extra%d',j), ...
                    1:(numSignals-numel(outputNames)), 'UniformOutput', false);
                outputNames = [outputNames extraNames];
            end
        end

        % Round data to 2 decimal places
        simTime = round(simTime,2);
        simData = round(simData,2);

        % Build table with proper names
        Tout = array2table([simTime simData], ...
            'VariableNames',[{'time'}, outputNames]);

        % Write to Excel
        outFile = fullfile(modelPath,[baseName '_Out.xlsx']);

        % Write numeric table
        writetable(Tout,outFile,'Sheet','Outputs');

        % Open Excel via COM
        Excel = actxserver('Excel.Application');
        WB = Excel.Workbooks.Open(outFile);
        WS = WB.Sheets.Item('Outputs');

        % Format all numeric cells to 2 decimals
        WS.Columns.Item('A:Z').NumberFormat = '0.00';

        WB.Save;
        WB.Close(false);
        Excel.Quit;
        delete(Excel);

        fprintf('Simulation complete. Outputs written to %s\n',outFile);
    else
        warning('SimulationOutput does not contain simOut.');
    end

    % Leave the model open
end
