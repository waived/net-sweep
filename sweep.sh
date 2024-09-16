#!/bin/bash
clear

dump_rslts() {
  if [ ${#_online[@]} -ne 0 ]; then
      local output_file="output.txt"
      printf "%s\n" "${_online[@]}" > "$output_file"
      echo "Results dumped to output.txt"
  fi
  exit 1
}

# catch CTRL+C
trap dump_rslts INT

echo "\
 ____     ___ ______  _____ __    __    ___    ___  ____  
|    \   /  _]      |/ ___/|  |__|  |  /  _]  /  _]|    \ 
|  _  | /  [_|      (   \_ |  |  |  | /  [_  /  [_ |  o  )
|  |  ||    _]_|  |_|\__  ||  |  |  ||    _]|    _]|   _/ 
|  |  ||   [_  |  |  /  \ ||  '  '  ||   [_ |   [_ |  |   
|  |  ||     | |  |  \    | \      / |     ||     ||  |   
|__|__||_____| |__|   \___|  \_/\_/  |_____||_____||__|   
"

read -p "Start IP (e.g., 192.168.1.0): " _addr

# Extract the last octet of the start IP
_begin=$(echo "$_addr" | awk -F. '{print $4}')
_addr="${_addr%.*}"

echo -e "\nReady? Strike <ENTER> to continue..."
read -r

_online=()

for x in $(seq "$_begin" 255); do
    result=$(ping -c 1 "$_addr.$x" 2>&1)
    
    if echo "$result" | grep -q "100% packet loss"; then
        echo "$_addr.$x is down"
    else
        echo "$_addr.$x is up"
        _online+=("$_addr.$x")
    fi
done

dump_rslts

echo -e "\nJob complete!"
