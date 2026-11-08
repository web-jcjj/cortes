# --- SCRIPT DE CORTE PARA: CENTRO ---
# Actualizado: 07/11/2026 23:26:35

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

:do { /ip firewall address-list add address=192.168.1.70 list="CLIENTES_CORTADOS" comment="SUSY YOBANA MAMANI QUISPE | corte 30/10/2026 12:00" } on-error={};
