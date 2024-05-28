% HEARTBEAT COUNTING TASK

% Clear the workspace and the screen
close all;
clear all;
sca

code= 6 %insert participant number
session= 2 %insert session number

% Connect to NI-box aka Create NI session (once in an expt - put at the start of the script)
s = daq.createSession('ni');5
addDigitalChannel(s,'Dev1','Port1/Line0','OutputOnly');   % Use NI Dev1 (check NI Max if unsure), open port/line0 (check numbers where the cables are screwed into the NI box), set port as output
fprintf('Done!\n')

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

Screen('Preference', 'SkipSyncTests', 1);

% Select the external screen if it is present, else revert to the native
% screen
screenNumber = max(screens);

% Define black, white and grey
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);
grey = white / 2;

% Open an on screen window and color it grey
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window in pixels
% For help see: Screen WindowSize?
 %                                               
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);
        
% Get the centre coordinate of the window in pixels
% For help see: help RectCenter
[xCenter, yCenter] = RectCenter(windowRect);

% Set the blend function for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

%spaceKey = KbName('Space');

%EXPERIMENT STARTING


% Draw text in the middle of the screen in Times in white
Screen('TextSize', window, 50);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Welcome to our experiment!\n\n Silently count your heartbeat simply by listening to your body.\n\n You are not allowed to take your pulse while you do this.\n\n You can keep your eyes open or closed and breathe normally.\n\n If you have any question, please ask the experimenter before starting.\n\n Please press "Enter" to start!', 'center', 'center', white);

% Flip to the screen
Screen('Flip', window);

% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo.
KbStrokeWait;

%Starting

% Start LabChart recording
outputSingleScan(s, 0);
outputSingleScan(s, 1);
outputSingleScan(s, 0);

% Wait for two seconds
%WaitSecs(2);

% Draw text in the bottom of the screen in Times in white
Screen('TextSize', window, 100);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Rest', 'center', 'center', white);

% Flip to the screen
Screen('Flip', window);

% Wait for two seconds
WaitSecs(15);

% A list including duration of trials
duration = [25, 30, 35, 40, 45, 50];
%duration = [1, 2, 3, 4, 5];
%practice = 2;
practice = 28;
nTrials = length(duration);


%LOOP STARTING
% heartbeat = [];
% confidence = [];

% Start a loop between 1 to 6
for trial = 0:nTrials

    % This is practice session
    if trial==0
        % practice trial, just try but not written excel
        nduration=practice;

        % Draw text in the bottom of the screen in Times in white
        Screen('TextSize', window, 80);
        Screen('TextFont', window, 'Times');
        DrawFormattedText(window, 'This is practice session\n\n Please press "Enter" to start!', 'center', 'center', white);
        
        % Flip to the screen
        Screen('Flip', window);

        %WaitSecs(2);
        KbStrokeWait;
        %TODO:KEY PRESS-Enter
      
    end


        
    %randomise the trials in the experiment
    if 0<trial
            
        r=randi([1,nTrials])
        % call the duration into the loop in order
        nduration= duration(r)

        duration(r)=[]
        %extract the trial done from the next randomisation to show each
        %trials once during the experiment.
        nTrials=nTrials-1
        
    end
    
    % A screen including text before the real experiment starting
    if trial==1
        

        % Draw text in the bottom of the screen in Times in white
        Screen('TextSize', window, 80);
        Screen('TextFont', window, 'Times');
        DrawFormattedText(window, 'Experiment is starting here\n\n Please press "Enter" to start!', 'center', 'center', white);
        
        % Flip to the screen
        Screen('Flip', window);

        %WaitSecs(2);
        KbStrokeWait;

        %TODO:KEY PRESS-Enter

    end
    

    
    % Draw text in the bottom of the screen in Times in white
    Screen('TextSize', window, 90);
    Screen('TextFont', window, 'Times');
    DrawFormattedText(window, 'Start Counting', 'center', 'center', [0 1 0]);
    
  

    % Send trig
    outputSingleScan(s, 1);  
    % Send trag
    outputSingleScan(s, 0);

    
    % Flip to the screen
    Screen('Flip', window);
    
    % Wait for one second
    WaitSecs(2);
    
    % Draw text in the bottom of the screen in Times in white
    Screen('TextSize', window, 90);
    DrawFormattedText(window, '+', 'center', 'center', white);
    
    % Flip to the screen
    Screen('Flip', window);
    
    nduration

    % Wait for two second
    WaitSecs(nduration);
    
    % Draw text in the bottom of the screen in Times in white
    Screen('TextSize', window, 90);
    Screen('TextFont', window, 'Times');
    DrawFormattedText(window, 'Stop Counting', 'center', 'center', [1 0 0]);
   % Send trig
    outputSingleScan(s, 1);  
    % Send trag
    outputSingleScan(s, 0);
    
    % Flip to the screen
    Screen('Flip', window);
    
    % Wait for two second
    WaitSecs(2);
    if trial>0
        fduration(trial)=nduration;
    end

    % Number input for number of heartbeat counted
    numhb = 'How many heartbeat did you count? ';
    answ1 = Ask(window, numhb, white, black, 'GetChar','center','center', 70);
    answ1 = str2double(answ1);
   % answ1 = input(numhb);
    if trial>0
        heartbeat(trial)=answ1;
    end
    
    % Flip to the screen
    Screen('Flip', window);
    
    % Number input for confidence rating
   % confi = "How confident are you on a scale of 1 (not at all) to 10 (very)? ";
    confi = 'How confident are you on a scale of 1 (not at all) to 10 (very)? ';
    answ2 = Ask(window, confi, white, black, 'GetChar','center','center', 60);
    answ2 = str2double(answ2);
    if trial>0
        confidence(trial)=answ2;
    end
    

    % A loop not to display Rest screen in the end of experiment
    if trial < nTrials
        % Draw text in the bottom of the screen in Times in white
        Screen('TextSize', window, 100);
        Screen('TextFont', window, 'Times');
        DrawFormattedText(window, 'Rest', 'center', 'center', white);
        
        % Flip to the screen
        Screen('Flip', window);
        
        % Wait for two second
        WaitSecs(15);
    end
    

end

% Close NI session (once in an expt - put at the end of the script)
outputSingleScan(s, 0);
stop(s)

% Create big array to write in excel called output
output = [fduration;heartbeat;confidence]

% transpose the data to write excel file in order
toutput = transpose(output)

% Write to Excel
%filename = ['hbc_' code '_' session '.xlsx'];
%filename = 'hbc_%d_%d.xlsx',code, session;

filename = sprintf('hbc_code%d_session%d.xlsx',code, session)
xlswrite(filename,{'Duration'},'Sheet',"A1");
xlswrite(filename,{'Heartbeat'},'Sheet',"B1");
xlswrite(filename,{'Confidence'},'Sheet',"C1");

xlswrite(filename,toutput(:,:,:),'Sheet',"A2"); %(filename,variable,excelfilename,cell_location)
%xlswrite(filename,toutput,1); %(filename,variable,excelfilename,cell_location)

% Draw text in the bottom of the screen in Times in white
Screen('TextSize', window, 90);
Screen('TextFont', window, 'Times');
DrawFormattedText(window, 'Thank you for participanting in our study!', 'center', 'center', white);

% Flip to the screen
Screen('Flip', window);

% Wait for two second
WaitSecs(2);

% Clear the screen
sca;

