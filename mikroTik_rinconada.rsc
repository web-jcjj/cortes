# --- SCRIPT DE CORTE PARA: RINCONADA ---
# Actualizado: 30/10/2026 21:42:17

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

