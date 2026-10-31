# --- SCRIPT DE CORTE PARA: CENTRO ---
# Actualizado: 30/10/2026 22:52:51

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

/ip firewall address-list add address=192.168.1.74 list="CLIENTES_CORTADOS" comment="ELSA MACHACA CUEVAS dni 43142060";
