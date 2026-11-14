# =====================================================
# SISTEMA DE CORTES Y ANCHO DE BANDA - RINCONADA
# RouterOS 7 | Actualizado: 14/11/2026 00:29:55
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
:local corteLease1 [/ip dhcp-server lease find where mac-address="B0:7B:25:4E:43:45" and status=bound];
:if ([:len $corteLease1] > 0) do={
  :local corteIp1 [/ip dhcp-server lease get ($corteLease1->0) address];
  :local corteSrc1 ($corteIp1 . "/32");
  :do { /ip firewall address-list add list="CLIENTES_CORTADOS" address=$corteSrc1 comment="CORTE_MAC_1 Fila14 | corte 01/11/2026 10:00" } on-error={};
  :do { /ip proxy access add src-address=$corteSrc1 action=redirect action-data="https://www.sistemhouse.com/p/cortes.html" comment="CORTE_AVISO_MAC_1" } on-error={};
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

# Cliente: Fila16
:local bwQueue1 [/queue simple find where name="BW_rinconada_19216810042"];
:local bwTarget1 "192.168.100.42/32";
:if ([:len $bwQueue1] = 0) do={
  /queue simple add name="BW_rinconada_19216810042" target=$bwTarget1 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue1 target=$bwTarget1 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget1 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila17
:local bwQueue2 [/queue simple find where name="BW_rinconada_19216810043"];
:local bwTarget2 "192.168.100.43/32";
:if ([:len $bwQueue2] = 0) do={
  /queue simple add name="BW_rinconada_19216810043" target=$bwTarget2 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue2 target=$bwTarget2 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget2 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila18
:local bwQueue3 [/queue simple find where name="BW_rinconada_19216810045"];
:local bwTarget3 "192.168.100.45/32";
:if ([:len $bwQueue3] = 0) do={
  /queue simple add name="BW_rinconada_19216810045" target=$bwTarget3 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue3 target=$bwTarget3 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget3 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila20
:local bwQueue4 [/queue simple find where name="BW_rinconada_19216810036"];
:local bwTarget4 "192.168.100.36/32";
:if ([:len $bwQueue4] = 0) do={
  /queue simple add name="BW_rinconada_19216810036" target=$bwTarget4 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue4 target=$bwTarget4 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget4 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila21
:local bwQueue5 [/queue simple find where name="BW_rinconada_19216810059"];
:local bwTarget5 "192.168.100.59/32";
:if ([:len $bwQueue5] = 0) do={
  /queue simple add name="BW_rinconada_19216810059" target=$bwTarget5 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue5 target=$bwTarget5 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget5 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila22
:local bwQueue6 [/queue simple find where name="BW_rinconada_19216810037"];
:local bwTarget6 "192.168.100.37/32";
:if ([:len $bwQueue6] = 0) do={
  /queue simple add name="BW_rinconada_19216810037" target=$bwTarget6 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue6 target=$bwTarget6 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget6 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila23
:local bwQueue7 [/queue simple find where name="BW_rinconada_19216810038"];
:local bwTarget7 "192.168.100.38/32";
:if ([:len $bwQueue7] = 0) do={
  /queue simple add name="BW_rinconada_19216810038" target=$bwTarget7 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue7 target=$bwTarget7 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget7 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila24
:local bwQueue8 [/queue simple find where name="BW_rinconada_19216810062"];
:local bwTarget8 "192.168.100.62/32";
:if ([:len $bwQueue8] = 0) do={
  /queue simple add name="BW_rinconada_19216810062" target=$bwTarget8 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue8 target=$bwTarget8 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget8 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila25
:local bwQueue9 [/queue simple find where name="BW_rinconada_19216810056"];
:local bwTarget9 "192.168.100.56/32";
:if ([:len $bwQueue9] = 0) do={
  /queue simple add name="BW_rinconada_19216810056" target=$bwTarget9 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue9 target=$bwTarget9 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget9 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila26
:local bwQueue10 [/queue simple find where name="BW_rinconada_19216810049"];
:local bwTarget10 "192.168.100.49/32";
:if ([:len $bwQueue10] = 0) do={
  /queue simple add name="BW_rinconada_19216810049" target=$bwTarget10 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue10 target=$bwTarget10 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget10 comment="BW_AUTO_rinconada" } on-error={};

# Cliente: Fila28
:local bwQueue11 [/queue simple find where name="BW_rinconada_19216810098"];
:local bwTarget11 "192.168.100.98/32";
:if ([:len $bwQueue11] = 0) do={
  /queue simple add name="BW_rinconada_19216810098" target=$bwTarget11 max-limit=10M/10M comment="BW_AUTO_rinconada";
} else={
  /queue simple set $bwQueue11 target=$bwTarget11 max-limit=10M/10M comment="BW_AUTO_rinconada";
}
:do { /ip firewall address-list add list="BW_CLIENTES" address=$bwTarget11 comment="BW_AUTO_rinconada" } on-error={};

# --- LIMPIEZA DE COLAS OBSOLETAS DE ESTE ROUTER ---
:local bwKeepNames {"BW_rinconada_19216810042";"BW_rinconada_19216810043";"BW_rinconada_19216810045";"BW_rinconada_19216810036";"BW_rinconada_19216810059";"BW_rinconada_19216810037";"BW_rinconada_19216810038";"BW_rinconada_19216810062";"BW_rinconada_19216810056";"BW_rinconada_19216810049";"BW_rinconada_19216810098"};
:foreach bwQ in=[/queue simple find where comment="BW_AUTO_rinconada"] do={
  :local bwName [/queue simple get $bwQ name];
  :local bwKeep false;
  :foreach bwWanted in=$bwKeepNames do={ :if ($bwName = $bwWanted) do={ :set bwKeep true; } }
  :if (!$bwKeep) do={ /queue simple remove $bwQ; }
}

# --- FIN DE CONFIGURACION ---
