# --- SCRIPT DE CORTE PARA: RINCONADA ---
# Actualizado: 30/10/2026 21:42:24

/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

/ip firewall address-list add address=192.168.100.64 list="CLIENTES_CORTADOS" comment="ROXANA MARI MURILLO MAMANI DNI 7164447";
/ip firewall address-list add address=192.168.100.98 list="CLIENTES_CORTADOS" comment="MAGNEMIA MAYTA HUANCA DNI 43410496";
