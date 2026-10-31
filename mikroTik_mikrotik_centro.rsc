# --- SCRIPT DE CORTE PARA: MIKROTIK_CENTRO ---
# Actualizado: 30/10/2026 21:42:04

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];


/ip firewall filter add chain=forward src-mac-address=B0:7B:25:4E:43:45 action=drop comment="CORTE_MAC JULIO CESAR JJ";

:do { /ip firewall filter move [find comment~"CORTE_MAC"] destination=0 } on-error={};
