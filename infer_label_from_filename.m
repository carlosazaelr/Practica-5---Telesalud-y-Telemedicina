function label = infer_label_from_filename(fname)
% INFER_LABEL_FROM_FILENAME Etiqueta automática según el nombre del archivo PCG

fname = lower(fname);  % pasar a minúsculas por seguridad

% === CATEGORÍAS ===
if contains(fname, "click") || contains(fname, "sys_click") || contains(fname, "click_mur")
    label = "click";                % sonidos con clics
elseif contains(fname, "normal") || contains(fname, "split") || contains(fname, "pure")
    label = "normal";               % corazones normales
elseif contains(fname, "mur") || contains(fname, "murmur")
    label = "murmur";               % soplos (opcional, puedes excluir)
else
    label = "normal";          % sin clasificación clara
end
end
