# --- SCRIPT DE CORTE PARA: MIKROTIK_CENTRO ---
# Actualizado: 30/10/2026 20:16:35

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

/ip firewall address-list add address=192.168.1.46 list="CLIENTES_CORTADOS" comment="TANIA JOVE ZAMATA";
/ip firewall address-list add address=192.168.1.74 list="CLIENTES_CORTADOS" comment="ELSA MACHACA CUEVAS dni 43142060";
/ip firewall address-list add address=192.168.1.70 list="CLIENTES_CORTADOS" comment="SUSY YOBANA MAMANI QUISPE";

/ip firewall filter add chain=forward src-mac-address=B0:7B:25:4E:43:45 action=drop comment="CORTE_MAC JULIO CESAR JJ";

:do { /ip firewall filter move [find comment~"CORTE_MAC"] destination=0 } on-error={};
