classdef someapp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        ExportButton            matlab.ui.control.Button
        RysujSinusoidaButton    matlab.ui.control.Button
        RysujButton             matlab.ui.control.Button
        WzmocnienieSlider       matlab.ui.control.Slider
        WzmocnienieSliderLabel  matlab.ui.control.Label
        WczytajButton           matlab.ui.control.Button
        UIAxes2                 matlab.ui.control.UIAxes
        UIAxes                  matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        dane % Description
        t % czas 
        t1 % wekotor czasu
        x % iks
    end

    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: WczytajButton
        function WczytajButtonPushed(app, event)
            app.dane=evalin('base', 'dane');
            app.t=evalin('base', 't');
            app.RysujButton.Enable="on";
        end

        % Button pushed function: RysujButton
        function RysujButtonPushed(app, event)
            plot(app.UIAxes,app.t,app.dane);
        end

        % Button pushed function: RysujSinusoidaButton
        function RysujSinusoidaButtonPushed(app, event)
            app.WzmocnienieSlider.Enable='on';
            app.t1=0:0.01:10;
            app.x=app.WzmocnienieSlider.Value*sin(2*pi*app.t1);
            plot(app.UIAxes2,app.t1,app.x);
            app.ExportButton.Enable='on';  
        end

        % Value changed function: WzmocnienieSlider
        function WzmocnienieSliderValueChanged(app, event)
            value = app.WzmocnienieSlider.Value;
            app.x=value*sin(2*pi*app.t1);
            plot(app.UIAxes2,app.t1,app.x);
        end

        % Button pushed function: ExportButton
        function ExportButtonPushed(app, event)
            assignin("base",'czas',app.t1);
            assignin("base",'sinus',app.x);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 946 659];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Sygnał losowy')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [441 431 300 185];

            % Create UIAxes2
            app.UIAxes2 = uiaxes(app.UIFigure);
            title(app.UIAxes2, 'Sinusoida')
            xlabel(app.UIAxes2, 'X')
            ylabel(app.UIAxes2, 'Y')
            zlabel(app.UIAxes2, 'Z')
            app.UIAxes2.Position = [57 431 300 185];

            % Create WczytajButton
            app.WczytajButton = uibutton(app.UIFigure, 'push');
            app.WczytajButton.ButtonPushedFcn = createCallbackFcn(app, @WczytajButtonPushed, true);
            app.WczytajButton.Position = [492 399 100 23];
            app.WczytajButton.Text = 'Wczytaj';

            % Create WzmocnienieSliderLabel
            app.WzmocnienieSliderLabel = uilabel(app.UIFigure);
            app.WzmocnienieSliderLabel.HorizontalAlignment = 'right';
            app.WzmocnienieSliderLabel.Enable = 'off';
            app.WzmocnienieSliderLabel.Position = [92 410 77 22];
            app.WzmocnienieSliderLabel.Text = 'Wzmocnienie';

            % Create WzmocnienieSlider
            app.WzmocnienieSlider = uislider(app.UIFigure);
            app.WzmocnienieSlider.Limits = [0 10];
            app.WzmocnienieSlider.ValueChangedFcn = createCallbackFcn(app, @WzmocnienieSliderValueChanged, true);
            app.WzmocnienieSlider.Enable = 'off';
            app.WzmocnienieSlider.Position = [190 419 150 3];
            app.WzmocnienieSlider.Value = 1;

            % Create RysujButton
            app.RysujButton = uibutton(app.UIFigure, 'push');
            app.RysujButton.ButtonPushedFcn = createCallbackFcn(app, @RysujButtonPushed, true);
            app.RysujButton.Enable = 'off';
            app.RysujButton.Position = [641 399 100 23];
            app.RysujButton.Text = 'Rysuj';

            % Create RysujSinusoidaButton
            app.RysujSinusoidaButton = uibutton(app.UIFigure, 'push');
            app.RysujSinusoidaButton.ButtonPushedFcn = createCallbackFcn(app, @RysujSinusoidaButtonPushed, true);
            app.RysujSinusoidaButton.Position = [215 350 100 23];
            app.RysujSinusoidaButton.Text = 'RysujSinusoida';

            % Create ExportButton
            app.ExportButton = uibutton(app.UIFigure, 'push');
            app.ExportButton.ButtonPushedFcn = createCallbackFcn(app, @ExportButtonPushed, true);
            app.ExportButton.Enable = 'off';
            app.ExportButton.Position = [376 301 100 23];
            app.ExportButton.Text = 'Export';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = someapp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
