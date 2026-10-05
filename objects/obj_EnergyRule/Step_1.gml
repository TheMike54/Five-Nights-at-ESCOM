/// Begin Step: energy clamp (see the feature issue).
/// Dato inválido: con cámaras y láser activos la energía baja de 2 en 2 y puede saltarse
/// el 0 y quedar negativa (obj_BatCheck compara con igualdad exacta). Se corrige aquí.
if (global.Bateria < energy_threshold) {
    global.Bateria = energy_threshold;
}
