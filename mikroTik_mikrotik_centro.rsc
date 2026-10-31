# --- SCRIPT DE CORTE PARA: MIKROTIK_CENTRO ---
# Actualizado: 30/10/2026 20:02:43

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

/ip firewall address-list add address=192.168.1.74 list="CLIENTES_CORTADOS" comment="ELSA MACHACA CUEVAS dni 43142060";
/ip firewall address-list add address=192.168.1.70 list="CLIENTES_CORTADOS" comment="SUSY YOBANA MAMANI QUISPE";
