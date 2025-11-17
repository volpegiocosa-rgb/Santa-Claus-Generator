function output = secretSanta(nomi, telefoni, accoppiamentiBassi, evitaReciproci)
% secretSanta per GNU Octave — genera accoppiamenti e un grafico
%
% Output: array di struct con campi:
%   - nome
%   - telefono
%   - destinatario
%   - messaggio

N = numel(nomi);

if numel(telefoni) ~= N
    error('Lista telefoni e lista nomi devono avere stessa lunghezza');
end

%% --- Genera una permutazione valida ---
assegnazione = randperm(N);

% Niente auto-accoppiamenti
while any(assegnazione == 1:N)
    assegnazione = randperm(N);
end

% Evita accoppiamenti a bassa probabilità
penalita = true;
while penalita
    penalita = false;
    for k = 1:size(accoppiamentiBassi,2)
        giver  = accoppiamentiBassi(1,k);
        target = accoppiamentiBassi(2,k);
        if assegnazione(giver) == target
            assegnazione = randperm(N);
            penalita = true;
            break;
        end
    end
end

% Evita reciprocità
if evitaReciproci
    ric = true;
    while ric
        ric = false;
        for i = 1:N
            if assegnazione(assegnazione(i)) == i
                assegnazione = randperm(N);
                ric = true;
                break;
            end
        end
    end
end

%% --- Costruzione output come struct array ---
output = struct('nome',{},'telefono',{},'destinatario',{},'messaggio',{});

for i = 1:N
    giver = nomi{i};
    recv  = nomi{assegnazione(i)};
    msg   = sprintf("Sono il folletto di Secret Santa: %s, devi fare il regalo a %s.", giver, recv);

    output(i).nome        = giver;
    output(i).telefono    = telefoni{i};
    output(i).destinatario = recv;
    output(i).messaggio   = msg;
end

%% --- Grafico circolare ---
figure('Name','Secret Santa','Color','w');
theta = linspace(0, 2*pi, N+1);
x = cos(theta(1:end-1));
y = sin(theta(1:end-1));

hold on

% Scrive i nomi attorno al cerchio
for i = 1:N
    text(1.25*x(i), 1.25*y(i), nomi{i}, 'HorizontalAlignment','center', ...
         'FontWeight','bold', 'FontSize', 12);
end

% Frecce giver → destinatario
for i = 1:N
    g = i;
    r = assegnazione(i);
    quiver(x(g), y(g), x(r)-x(g), y(r)-y(g), 0, ...
           'MaxHeadSize', 0.25, 'LineWidth', 1.6);
end

axis equal off
title('Secret Santa — Chi regala a chi 🎁', 'FontSize', 14);

hold off

end
