# --- SCRIPT DE CORTE PARA: RINCONADA ---
# Actualizado: 11/11/2026 08:37:46

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

:do { /ip firewall address-list add address=192.168.100.64 list="CLIENTES_CORTADOS" comment="Fila27 | corte 28/10/2026 12:00" } on-error={};
