# --- SCRIPT DE CORTE PARA: MIKROTIK_CENTRO ---
# Actualizado: 30/10/2026 18:04:24

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

/ip firewall address-list add address=192.168.1.70 list="CLIENTES_CORTADOS" comment="Fila8";
/ip firewall address-list add address=192.168.1.43 list="CLIENTES_CORTADOS" comment="Fila9";

/ip firewall filter add chain=forward src-mac-address=B0:7B:25:4E:43:45 action=drop comment="CORTE_MAC Fila14";

:do { /ip firewall filter move [find comment~"CORTE_MAC"] destination=0 } on-error={};
