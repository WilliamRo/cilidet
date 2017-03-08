function f = newfig(name)
%NEWFIG ...
%   ...

%% Open a new figure with the given names
% get screen size
screenSize = get(0, 'ScreenSize');
screenSize = screenSize(3:4);
f = figure('Name', name, 'NumberTitle', 'off', ...
           'ToolBar', 'none', 'MenuBar', 'none', 'Units', 'pixels');
figSize = f.Position(3:4);
f.Position = [(screenSize - figSize) / 2, figSize];
f.KeyPressFcn = @btnPressed;

end

%% Callback functions
function btnPressed(f, callbackdata)
    % ...
    switch lower(callbackdata.Key)
        case {'escape', 'return'}
            fprintf('>> [%s] figure has been closed.\n', f.Name)
            close(f)
    end
end

