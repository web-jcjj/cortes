# =====================================================
# SISTEMA DE CORTES Y ANCHO DE BANDA - RINCONADA
# RouterOS 7 | Actualizado: 14/11/2026 00:04:16
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
:do { /ip proxy access add src-address=192.168.100.41 action=redirect action-data="https://www.sistemhouse.com/p/cortes.html" comment="CORTE_AVISO_IP_1" } on-error={};
:do { /ip firewall connection remove [find where src-address~"192.168.100.41"] } on-error={};
:do { /ip firewall address-list add address=192.168.100.64 list="CLIENTES_CORTADOS" comment="CORTE_IP_2 Fila27 | corte 28/10/2026 12:00" } on-error={};
:do { /ip proxy access add src-address=192.168.100.64 action=redirect action-data="https://www.sistemhouse.com/p/cortes.html" comment="CORTE_AVISO_IP_2" } on-error={};
:do { /ip firewall connection remove [find where src-address~"192.168.100.64"] } on-error={};

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

# Cliente: Fila14
:local bwQueue1 [/queue simple find where name="BW_rinconada_b07b254e4345"];
:local bwLease1 [/ip dhcp-server lease find where mac-address="B0:7B:25:4E:43:45" and status=bound];
:if ([:len $bwLease1] > 0) do={
  :local bwIp1 [/ip dhcp-server lease get ($bwLease1->0) address];
  :local bwTarget1 ($bwIp1 . "/32");
  :set bwQueue1 [/queue simple find where name="BW_rinconada_b07b254e4345"];
  :if ([:len $bwQueue1] = 0) do={
    /queue simple add name="BW_rinconada_b07b254e4345" target=$bwTarget1 max-limit=10M/10M comment="BW_AUTO_rinconada";
  } else={
    /queue simple set $bwQueue1 target=$bwTarget1 max-limit=10M/10M comment="BW_AUTO_rinconada";
  }
  :do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget1 comment="BW_AUTO_rinconada" } on-error={};
} else={
  :if ([:len $bwQueue1] > 0) do={ /queue simple remove $bwQueue1; }
  :log warning "BW: sin concesion DHCP bound para MAC B0:7B:25:4E:43:45";
}

# --- LIMPIEZA DE COLAS OBSOLETAS DE ESTE ROUTER ---
:local bwKeepNames {"BW_rinconada_b07b254e4345"};
:foreach bwQ in=[/queue simple find where comment="BW_AUTO_rinconada"] do={
  :local bwName [/queue simple get $bwQ name];
  :local bwKeep false;
  :foreach bwWanted in=$bwKeepNames do={ :if ($bwName = $bwWanted) do={ :set bwKeep true; } }
  :if (!$bwKeep) do={ /queue simple remove $bwQ; }
}

# --- FIN DE CONFIGURACION ---
