# =====================================================
# SISTEMA DE CORTES Y ANCHO DE BANDA - RINCONADA
# RouterOS 7 | Actualizado: 13/11/2026 22:49:09
# H=DOWNLOAD, I=UPLOAD | max-limit=UPLOAD/DOWNLOAD
# Clientes por MAC se resuelven mediante DHCP del propio router.
# =====================================================

# --- ACTUALIZAR CLIENTES CORTADOS Y REGLAS DE AVISO ---
/ip proxy set enabled=yes port=8080 cache-on-disk=no;
/ip firewall address-list remove [find where list="CLIENTES_CORTADOS"];
/ip proxy access remove [find where comment~"^CORTE_AVISO_"];
/ip firewall filter remove [find where comment~"CORTE_MAC"];
/ip firewall filter remove [find where comment="CORTE_IP_ORIGEN"];
/ip firewall filter remove [find where comment="CORTE_IP_DESTINO"];
:local natCorte [/ip firewall nat find where comment="CORTE_REDIRECCION_HTTP"];
:if ([:len $natCorte] = 0) do={
  /ip firewall nat add chain=dstnat src-address-list=CLIENTES_CORTADOS protocol=tcp dst-port=80 action=redirect to-ports=8080 comment="CORTE_REDIRECCION_HTTP";
} else={ /ip firewall nat set $natCorte chain=dstnat src-address-list=CLIENTES_CORTADOS protocol=tcp dst-port=80 action=redirect to-ports=8080; }
:do { /ip firewall nat move [find where comment="CORTE_REDIRECCION_HTTP"] destination=0 } on-error={};
/ip firewall filter remove [find where comment="CORTE_PROXY_INPUT"];
/ip firewall filter add chain=input in-interface-list=LAN protocol=tcp dst-port=8080 action=accept comment="CORTE_PROXY_INPUT";
:do { /ip firewall filter move [find where comment="CORTE_PROXY_INPUT"] destination=0 } on-error={};
:do { /ip firewall address-list add address=192.168.100.41 list="CLIENTES_CORTADOS" comment="CORTE_IP_1 Fila15 | corte 01/11/2026 12:00" } on-error={};
:do { /ip proxy access add src-address=192.168.100.41 action=deny redirect-to="https://www.sistemhouse.com/p/cortes.html" comment="CORTE_AVISO_IP_1" } on-error={};
:do { /ip firewall connection remove [find where src-address~"192.168.100.41"] } on-error={};
:do { /ip firewall address-list add address=192.168.100.64 list="CLIENTES_CORTADOS" comment="CORTE_IP_2 Fila27 | corte 28/10/2026 12:00" } on-error={};
:do { /ip proxy access add src-address=192.168.100.64 action=deny redirect-to="https://www.sistemhouse.com/p/cortes.html" comment="CORTE_AVISO_IP_2" } on-error={};
:do { /ip firewall connection remove [find where src-address~"192.168.100.64"] } on-error={};
:local corteLease1 [/ip dhcp-server lease find where mac-address="B0:7B:25:4E:43:45" and status=bound];
:if ([:len $corteLease1] > 0) do={
  :local corteIp1 [/ip dhcp-server lease get ($corteLease1->0) address];
  :local corteSrc1 ($corteIp1 . "/32");
  :do { /ip firewall address-list add list="CLIENTES_CORTADOS" address=$corteSrc1 comment="CORTE_MAC_1 Fila14 | corte 01/11/2026 08:00" } on-error={};
  :do { /ip proxy access add src-address=$corteSrc1 action=deny redirect-to="https://www.sistemhouse.com/p/cortes.html" comment="CORTE_AVISO_MAC_1" } on-error={};
  :do { /ip firewall connection remove [find where src-address~$corteIp1] } on-error={};
} else={
  :do { /ip firewall filter add chain=forward src-mac-address=B0:7B:25:4E:43:45 action=drop comment="CORTE_MAC_SIN_DHCP_1" } on-error={};
}

# --- REGLAS DE FIREWALL PARA CLIENTES CORTADOS ---
/ip firewall filter remove [find where comment~"^CORTE_PERMITIR_"];
/ip firewall filter remove [find where comment="CORTE_BLOQUEO_GENERAL"];
/ip firewall filter add chain=forward src-address-list=CLIENTES_CORTADOS protocol=udp dst-port=53 action=accept comment="CORTE_PERMITIR_DNS_UDP";
/ip firewall filter add chain=forward src-address-list=CLIENTES_CORTADOS protocol=tcp dst-port=53 action=accept comment="CORTE_PERMITIR_DNS_TCP";
/ip firewall filter add chain=forward src-address-list=CLIENTES_CORTADOS protocol=tcp dst-port=443 tls-host="www.sistemhouse.com" action=accept comment="CORTE_PERMITIR_AVISO_HTTPS";
/ip firewall filter add chain=forward src-address-list=CLIENTES_CORTADOS action=drop comment="CORTE_BLOQUEO_GENERAL";
:do { /ip firewall filter move [find where comment="CORTE_BLOQUEO_GENERAL"] destination=0 } on-error={};
:do { /ip firewall filter move [find where comment="CORTE_PERMITIR_AVISO_HTTPS"] destination=0 } on-error={};
:do { /ip firewall filter move [find where comment="CORTE_PERMITIR_DNS_TCP"] destination=0 } on-error={};
:do { /ip firewall filter move [find where comment="CORTE_PERMITIR_DNS_UDP"] destination=0 } on-error={};
:do { /ip firewall filter move [find where comment~"^CORTE_MAC_SIN_DHCP"] destination=0 } on-error={};


# --- ANCHO DE BANDA: LISTA AUXILIAR PARA EXCLUIR DE FASTTRACK ---
/ip firewall address-list remove [find list="BW_CLIENTES" comment="BW_AUTO_rinconada"];

# --- LIMPIEZA DE COLAS OBSOLETAS DE ESTE ROUTER ---
/queue simple remove [find where comment="BW_AUTO_rinconada"];

# --- FIN DE CONFIGURACION ---
