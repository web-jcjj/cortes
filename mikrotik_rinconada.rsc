# --- SCRIPT DE CORTE PARA: RINCONADA ---
# Actualizado: 08/11/2026 17:22:28

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

:do { /ip firewall address-list add address=192.168.100.64 list="CLIENTES_CORTADOS" comment="Fila27 | corte 28/10/2026 12:00" } on-error={};
