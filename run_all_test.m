%% run_all_tests.m
clc; clear; close all;

import matlab.unittest.TestRunner
import matlab.unittest.TestSuite
import matlab.unittest.plugins.XMLPlugin

% Folders
modelsDir = fullfile(pwd,'Vcu_model');   % your model folder
testsDir  = fullfile(pwd,'tests');       % unit tests folder
artifacts = fullfile(pwd,'Artifacts');    % simulation outputs
results   = fullfile(pwd,'Test_Results'); % Jenkins XML reports

% Create folders if not exist
if ~exist(artifacts,'dir'), mkdir(artifacts); end
if ~exist(results,'dir'),   mkdir(results); end

% ----------------------------
% 1) Simulate all models (.slx)
% ----------------------------
modelFiles = dir(fullfile(modelsDir,'*.slx'));
disp(['Found ', num2str(numel(modelFiles)), ' Simulink model(s).']);

for i = 1:numel(modelFiles)
    mdlFile = modelFiles(i).name;
    [~, name, ~] = fileparts(mdlFile);

    disp(['Simulating: ', name]);
    try
        load_system(fullfile(modelsDir, mdlFile));
        simOut = sim(name,'SaveOutput','on');  % normal or MIL as needed

        % Save artifact
        save(fullfile(artifacts,[name '_sim.mat']),'simOut');

        close_system(name,0);
    catch ME
        warning(['Simulation error for ', name, ': ', ME.message]);
    end
end

% ----------------------------
% 2) Run MATLAB Unit Tests
% ----------------------------
disp('Running MATLAB unit tests...');
suite  = TestSuite.fromFolder(testsDir,'IncludingSubfolders',true);
runner = TestRunner.withTextOutput;
xmlPlugin = XMLPlugin.producingJUnitFormat(fullfile(results,'MATLAB_TestResults.xml'));
runner.addPlugin(xmlPlugin);
runner.run(suite);

disp('All tests completed.');