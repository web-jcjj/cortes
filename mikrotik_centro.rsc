# --- SCRIPT DE CORTE PARA: CENTRO ---
# Actualizado: 07/11/2026 23:32:13

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

:do { /ip firewall address-list add address=192.168.1.74 list="CLIENTES_CORTADOS" comment="ELSA MACHACA CUEVAS dni 43142060 | corte 07/11/2026 12:00" } on-error={};
:do { /ip firewall address-list add address=192.168.1.43 list="CLIENTES_CORTADOS" comment="YOBANA ANA CABANA PACO | corte 07/11/2026 08:00" } on-error={};

:do { /ip firewall filter add chain=forward src-mac-address=B0:7B:25:4E:43:45 action=drop comment="CORTE_MAC JULIO CESAR JJ | corte 07/11/2026 08:00" } on-error={};

:do { /ip firewall filter move [find comment~"CORTE_MAC"] destination=0 } on-error={};
