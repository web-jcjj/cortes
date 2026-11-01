# --- SCRIPT DE CORTE PARA: RINCONADA ---
# Actualizado: 31/10/2026 20:10:50

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

/ip firewall address-list add address=192.168.100.64 list="CLIENTES_CORTADOS" comment="ROXANA MARI MURILLO MAMANI DNI 7164447";
