# --- SCRIPT DE CORTE PARA: MIKROTIK_RINCONADA ---
# Actualizado: 30/10/2026 17:36:35

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

/ip firewall address-list add address=192.168.100.64 list="CLIENTES_CORTADOS" comment="Fila27";
/ip firewall address-list add address=192.168.100.98 list="CLIENTES_CORTADOS" comment="Fila28";
