% Método de Müller 
% Estudiante: KIMBERLING DE LOS ANGELES ALVAREZ SANCHEZ
% Carnet: 2512-21-4708

function muller()
    % Crear la ventana de la calculadora
    fig = uifigure('Name', 'Calculadora Método de Müller By:Kimberling Alvarez', 'Position', [100 100 800 600], 'Color', [0.2, 0.9, 0.9]);

    % Crear campos y etiquetas para la función
    lblFuncion = uilabel(fig, 'Position', [50 540 100 22], 'Text', 'Función:', 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [0.9, 0.9, 1]);
    txtFuncion = uieditfield(fig, 'text', 'Position', [150 540 400 22]);

    % Crear campos y etiquetas para x0 inicial
    lblX0 = uilabel(fig, 'Position', [50 500 100 22], 'Text', 'x0:', 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [0.9, 0.9, 1]);
    txtX0 = uieditfield(fig, 'numeric', 'Position', [150 500 100 22]);

    % Crear campos y etiquetas para x1 inicial
    lblX1 = uilabel(fig, 'Position', [50 460 100 22], 'Text', 'x1:', 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [0.9, 0.9, 1]);
    txtX1 = uieditfield(fig, 'numeric', 'Position', [150 460 100 22]);

    % Crear campos y etiquetas para x2 inicial
    lblX2 = uilabel(fig, 'Position', [50 420 100 22], 'Text', 'x2:', 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [0.9, 0.9, 1]);
    txtX2 = uieditfield(fig, 'numeric', 'Position', [150 420 100 22]);

    % Crear campos y etiquetas para el número de iteraciones
    lblIteraciones = uilabel(fig, 'Position', [50 380 100 22], 'Text', 'Iteraciones:', 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [0.9, 0.9, 1]);
    txtIteraciones = uieditfield(fig, 'numeric', 'Position', [150 380 100 22]);

    % Crear campos y etiquetas para el error porcentual
    lblError = uilabel(fig, 'Position', [50 340 100 22], 'Text', 'Error (%):', 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [0.9, 0.9, 1]);
    txtError = uieditfield(fig, 'numeric', 'Position', [150 340 100 22]);

    % Crear botón para calcular
    btnCalcular = uibutton(fig, 'Position', [50 300 100 22], 'Text', 'Calcular', 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [0.6, 0.4, 0.8], ...
        'ButtonPushedFcn', @(btnCalcular, event) calcularRaices(txtFuncion, txtX0, txtX1, txtX2, txtIteraciones, txtError, fig));
    
    % Crear botón para limpiar los datos
    btnLimpiarDatos = uibutton(fig, 'Position', [160 300 100 22], 'Text', 'Limpiar Datos', 'FontSize', 12, 'FontWeight', 'bold', 'BackgroundColor', [1, 0.4, 0.4], ...
        'ButtonPushedFcn', @(btnLimpiarDatos, event) limpiarDatos(txtFuncion, txtX0, txtX1, txtX2, txtIteraciones, txtError, fig));

    % Crear el eje para la gráfica al lado derecho de los campos de entrada
    ax = uiaxes(fig, 'Position', [300 300 450 150], 'BackgroundColor', [1, 1, 1]);
    
    % Crear la tabla para las iteraciones
    uit = uitable(fig, 'Position', [50 20 700 260], ...
        'ColumnName', {'Iteración', 'x0', 'x1', 'x2', 'f(x0)', 'f(x1)', 'f(x2)', 'h0', 'h1', 'σ0', 'σ1', 'a', 'b', 'c', 'x3'}, ...
        'ColumnEditable', false, ...
        'ColumnFormat', {'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric', 'numeric'}, ...
        'RowName', []);

    % Guardar la tabla y el eje en la figura para acceso posterior
    fig.UserData = struct('iterTable', uit, 'graphAxes', ax);
end

function calcularRaices(txtFuncion, txtX0, txtX1, txtX2, txtIteraciones, txtError, fig)
    % Obtener los valores de los campos
    funcion_str = txtFuncion.Value;
    x0 = txtX0.Value;
    x1 = txtX1.Value;
    x2 = txtX2.Value;
    num_iteraciones = txtIteraciones.Value;
    error_porcentual = txtError.Value;
    
    % Convertir la función a una función anónima
    funcion = str2func(['@(x) ' funcion_str]);

    % Graficar la función
    ax = fig.UserData.graphAxes;
    fplot(ax, funcion, [-10, 10]); % Puedes ajustar el rango [-10, 10] según tu función
    xlabel(ax, 'x');
    ylabel(ax, 'f(x)');
    grid(ax, 'on');
    
    % Método de Müller
    tolerancia = error_porcentual / 100;
    iter_data = {};

    for iter = 1:num_iteraciones
        h0 = x1 - x0;
        h1 = x2 - x1;
        d0 = (funcion(x1) - funcion(x0)) / h0;
        d1 = (funcion(x2) - funcion(x1)) / h1;
        a = (d1 - d0) / (h1 + h0);
        b = a*h1 + d1;
        c = funcion(x2);

        discriminant = sqrt(b^2 - 4*a*c);
        if abs(b + discriminant) > abs(b - discriminant)
            denom = b + discriminant;
        else
            denom = b - discriminant;
        end

        dxr = -2*c / denom;
        xr = x2 + dxr;

        % Guardar los valores de las iteraciones
        iter_data{iter, 1} = iter;
        iter_data{iter, 2} = x0;
        iter_data{iter, 3} = x1;
        iter_data{iter, 4} = x2;
        iter_data{iter, 5} = funcion(x0);
        iter_data{iter, 6} = funcion(x1);
        iter_data{iter, 7} = funcion(x2);
        iter_data{iter, 8} = h0;
        iter_data{iter, 9} = h1;
        iter_data{iter, 10} = d0;
        iter_data{iter, 11} = d1;
        iter_data{iter, 12} = a;
        iter_data{iter, 13} = b;
        iter_data{iter, 14} = c;
        iter_data{iter, 15} = xr;

        % Verificación de la convergencia
        if abs(dxr) < tolerancia
            break;
        end

        % Actualización de los valores
        x0 = x1;
        x1 = x2;
        x2 = xr;
    end

    % Guardar los datos de las iteraciones en la figura
    fig.UserData.iterTable.Data = iter_data;

    % Mostrar la raíz encontrada en un mensaje de diálogo
    uialert(fig, sprintf('Raíz encontrada:\n%.6f rad', xr), 'Resultados', 'Icon', 'success');
end

function limpiarDatos(txtFuncion, txtX0, txtX1, txtX2, txtIteraciones, txtError, fig)
    % Restablecer los campos de entrada a sus valores predeterminados
    txtFuncion.Value = '';
    txtX0.Value = '';
    txtX1.Value = '';
    txtX2.Value = '';
    txtIteraciones.Value = '';
    txtError.Value = '';
    
    % Limpiar la tabla y la gráfica
    fig.UserData.iterTable.Data = {};
    cla(fig.UserData.graphAxes);
end
% Ejecutar la calculadora
muller();