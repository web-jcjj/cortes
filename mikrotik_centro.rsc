# --- SCRIPT DE CORTE PARA: CENTRO ---
# Actualizado: 07/11/2026 23:37:56

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

:do { /ip firewall address-list add address=192.168.1.74 list="CLIENTES_CORTADOS" comment="ELSA MACHACA CUEVAS dni 43142060 | corte 07/11/2026 12:00" } on-error={};
:do { /ip firewall address-list add address=192.168.1.43 list="CLIENTES_CORTADOS" comment="YOBANA ANA CABANA PACO | corte 07/11/2026 08:00" } on-error={};
