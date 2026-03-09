%% 1. Defining the Environment Boundaries
% Observation Space (State: q1, q2, dq1, dq2)
obsInfo = rlNumericSpec([4 1]);
obsInfo.Name = 'ArmStates';

% Action Space (Torque: tau1, tau2) bounded to +/- 10 Nm
actInfo = rlNumericSpec([2 1], 'LowerLimit', -10, 'UpperLimit', 10);
actInfo.Name = 'JointTorques';

mdl = 'kinovagen3'; 
blk = [mdl, '/RL Agent']; 
env = rlSimulinkEnv(mdl, blk, obsInfo, actInfo);

%% 2. Constructing the SAC Agent
agentOpts = rlSACAgentOptions;
agentOpts.SampleTime = 0.1; 
agentOpts.DiscountFactor = 0.99; 
agentOpts.ExperienceBufferLength = 1e6; 

agent = rlSACAgent(obsInfo, actInfo, agentOpts);

%% 3. Executing the Training Loop
trainOpts = rlTrainingOptions(...
    'MaxEpisodes', 500, ...               
    'MaxStepsPerEpisode', 200, ...        
    'ScoreAveragingWindowLength', 50, ... 
    'Verbose', false, ...
    'Plots', 'training-progress', ...     
    'StopTrainingCriteria', 'AverageReward', ...
    'StopTrainingValue', -10);            

% Launching the solver
trainingStats = train(agent, env, trainOpts);