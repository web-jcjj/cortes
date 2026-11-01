# --- SCRIPT DE CORTE PARA: CENTRO ---
# Actualizado: 31/10/2026 20:08:28

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

/ip firewall address-list add address=192.168.1.70 list="CLIENTES_CORTADOS" comment="SUSY YOBANA MAMANI QUISPE";
