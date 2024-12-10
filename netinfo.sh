#!/usr/bin/env bash

# netinfo.sh
# Uso: ./netinfo.sh 192.168.1.10/24
# Muestra: Network Mask, Total Hosts, Network ID y Broadcast Address

if [ -z "$1" ]; then
    echo "Uso: $0 <IP/CIDR>"
    echo "Ejemplo: $0 192.168.1.10/24"
    exit 1
fi

input="$1"
ip="${input%/*}"
cidr="${input#*/}"

# Validar CIDR
if ! [[ "$cidr" =~ ^[0-9]+$ ]] || [ "$cidr" -lt 0 ] || [ "$cidr" -gt 32 ]; then
    echo "Error: CIDR inválido. Debe ser un número entre 0 y 32."
    exit 1
fi

# Separar la IP en sus octetos
IFS='.' read -r o1 o2 o3 o4 <<< "$ip"

# Validar octetos de IP
for octet in $o1 $o2 $o3 $o4; do
    if ! [[ "$octet" =~ ^[0-9]+$ ]] || [ "$octet" -lt 0 ] || [ "$octet" -gt 255 ]; then
        echo "Error: IP inválida."
        exit 1
    fi
done

# Convertir IP a número de 32 bits
ip_num=$(( (o1 << 24) + (o2 << 16) + (o3 << 8) + o4 ))

# Crear la máscara de red a partir del CIDR
# Ejemplo: /24 -> 255.255.255.0 en binario es 11111111.11111111.11111111.00000000
# Máscara 32 bits: 0xFFFFFFFF << (32 - cidr)
mask_num=$(( 0xFFFFFFFF << (32 - cidr) & 0xFFFFFFFF ))

# Calcular el Network ID aplicando la máscara
network_num=$(( ip_num & mask_num ))

# Calcular el Broadcast: network_num OR con el inverso de la máscara
broadcast_num=$(( network_num | ~mask_num & 0xFFFFFFFF ))

# Calcular cantidad de hosts
# Por defecto: 2^(32 - cidr) - 2 (para /31 y /32 hay casos especiales)
host_count=0
if [ "$cidr" -lt 31 ]; then
    host_count=$(( (1 << (32 - cidr)) - 2 ))
elif [ "$cidr" -eq 31 ]; then
    # /31: Usualmente se usan en enlaces punto a punto, hay 2 direcciones sin host reservados
    # Normalmente se considera que no hay hosts "usables" tradicionales (solo 2 IPs asignables)
    # Para efectos prácticos aquí devolvemos 2 (se podría ajustar según el uso)
    host_count=2
elif [ "$cidr" -eq 32 ]; then
    # /32: Solo una dirección host
    host_count=1
fi

# Función para convertir un número de 32 bits a notación punto-decimal
to_dotted_dec() {
    local num="$1"
    printf "%d.%d.%d.%d" \
        $(( (num >> 24) & 0xFF )) \
        $(( (num >> 16) & 0xFF )) \
        $(( (num >>  8) & 0xFF )) \
        $((  num        & 0xFF ))
}

network_mask=$(to_dotted_dec "$mask_num")
network_id=$(to_dotted_dec "$network_num")
broadcast_ip=$(to_dotted_dec "$broadcast_num")

echo "=============================================="
echo "Información de Red para $ip/$cidr"
echo "----------------------------------------------"
echo "Network Mask:  $network_mask"
echo "Total Hosts:   $host_count"
echo "Network ID:    $network_id"
echo "Broadcast:     $broadcast_ip"
echo "=============================================="
