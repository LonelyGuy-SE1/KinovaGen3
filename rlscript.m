% 1. Define the Observation Space (State: q1, q2, dq1, dq2) (4x1)
obsInfo = rlNumericSpec([4 1]);
obsInfo.Name = 'ArmStates';

% 2. Define the Action Space (Torque: tau1, tau2) (2x1)
% physical limits
actInfo = rlNumericSpec([2 1], 'LowerLimit', -10, 'UpperLimit', 10);
actInfo.Name = 'JointTorques';

% 3. bind model to env
mdl = 'kinovagen3'; 
blk = [mdl, '/RL Agent']; %path to agent

% Construct the environment
env = rlSimulinkEnv(mdl, blk, obsInfo, actInfo);

env.ResetFcn = @(in) setVariable(in, 'seed', randi(100));