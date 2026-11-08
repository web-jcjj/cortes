# --- SCRIPT DE CORTE PARA: RINCONADA ---
# Actualizado: 08/11/2026 00:51:09

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

:do { /ip firewall address-list add address=192.168.100.64 list="CLIENTES_CORTADOS" comment="Fila27 | corte 28/10/2026 12:00" } on-error={};

:do { /ip firewall filter add chain=forward src-mac-address=B0:7B:25:4E:43:45 action=drop comment="CORTE_MAC Fila14 | corte 01/11/2026 08:00" } on-error={};

:do { /ip firewall filter move [find comment~"CORTE_MAC"] destination=0 } on-error={};
