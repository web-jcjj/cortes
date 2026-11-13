# =====================================================
# SISTEMA DE CORTES Y ANCHO DE BANDA - CENTRO
# RouterOS 7 | Actualizado: 13/11/2026 11:41:36
# H=DOWNLOAD, I=UPLOAD | max-limit=UPLOAD/DOWNLOAD
# Clientes por MAC se resuelven mediante DHCP del propio router.
# =====================================================

# --- ACTUALIZAR LISTA DE CLIENTES CORTADOS ---
/ip firewall address-list remove [find list="CLIENTES_CORTADOS"];
/ip firewall filter remove [find comment~"CORTE_MAC"];

:do { /ip firewall address-list add address=192.168.1.43 list="CLIENTES_CORTADOS" comment="Fila9 | corte 07/11/2026 08:00" } on-error={};

# --- ANCHO DE BANDA: LISTA AUXILIAR PARA EXCLUIR DE FASTTRACK ---
/ip firewall address-list remove [find list="BW_CLIENTES" comment="BW_AUTO_centro"];

# --- LIMPIEZA DE COLAS OBSOLETAS DE ESTE ROUTER ---
/queue simple remove [find where comment="BW_AUTO_centro"];

# --- FIN DE CONFIGURACION ---
