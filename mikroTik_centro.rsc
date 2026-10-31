# --- SCRIPT DE CORTE PARA: CENTRO ---
# Actualizado: 30/10/2026 21:41:56

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

/ip firewall address-list add address=192.168.1.46 list="CLIENTES_CORTADOS" comment="TANIA JOVE ZAMATA";
