#!/bin/bash
passpath="/home/zh0ng/Documents/pass.json"

export NEWT_COLORS='
root=black,black
window=black,black
border=brightcyan,black
shadow=cyan,black
title=white,brightcyan
textbox=lightgray,black
entry=white,black
label=gray,black
button=black,brightcyan
actbutton=brightcyan,black
compactbutton=cyan,black
checkbox=cyan,black
actcheckbox=brightcyan,cyan
listbox=lightgray,black
actlistbox=cyan,black
actsellistbox=brightcyan,black
'

encrypt() {
  local text="$1" key="$2"
  local key_len=${#key}
  local encrypted=""
  for ((i=0; i<${#text}; i++)); do
    local char_ord=$(printf '%d' "'${text:i:1}")
    local key_ord=$(printf '%d' "'${key:$((i % key_len)):1}")
    local new_val=$((char_ord + key_ord))
    if [ -n "$encrypted" ]; then encrypted+="."; fi
    encrypted+="$new_val"
  done
  echo "$encrypted"
}

decrypt() {
  local enc_text="$1" key="$2"
  local key_len=${#key}
  local values=(${enc_text//./ })
  local decrypted=""
  for i in "${!values[@]}"; do
    local val=${values[i]}
    local key_ord=$(printf '%d' "'${key:$((i % key_len)):1}")
    local orig_ord=$((val - key_ord))
    # FIX: two-stage printf to actually emit the character, not a backslash+octal string
    decrypted+=$(printf "\\$(printf '%03o' "$orig_ord")")
  done
  echo "$decrypted"
}

build_filtered_args() {
  local query="$1"
  local count i name
  count=$(jq '.passwords | length' "$passpath" 2>/dev/null || echo 0)
  MATCHED_INDICES=()
 
  for i in $(seq 0 $((count - 1))); do
    name=$(jq -r ".passwords[$i].name // \"Entry $((i+1))\"" "$passpath")
    # case-insensitive match; empty query = show all
    if [[ -z "$query" || "${name,,}" == *"${query,,}"* ]]; then
      MATCHED_INDICES+=("$i")
    fi
  done
}

decrypt_entry() {
  local key choice idx name enc_text decrypted count i

  count=$(jq '.passwords | length' "$passpath" 2>/dev/null || echo 0)
  [ "$count" -eq 0 ] && { whiptail --msgbox "No passwords stored yet." 8 40; return 1; }
  
  local visible=$(( count < 15 ? count : 15 ))

  local args=()
  args+=("--title" "Password Manager ($count total)")
  args+=("--menu" "Choose an entry:" $(( visible + 8 )) 70 "$visible")

  for i in $(seq 1 $count); do
    name=$(jq -r ".passwords[$((i-1))].name // \"Entry $i\"" "$passpath")
    args+=("$i" "$name")
  done

  choice=$(whiptail "${args[@]}" 3>&1 1>&2 2>&3) || return 1

  idx=$((choice - 1))
  name=$(jq -r ".passwords[$idx].name" "$passpath")
  enc_text=$(jq -r ".passwords[$idx].pass" "$passpath")

  key=$(whiptail --passwordbox "Enter key:" 10 50 3>&1 1>&2 2>&3) || return 1

  decrypted=$(decrypt "$enc_text" "$key")

  whiptail --msgbox "Service:  $name
  Password: $decrypted" 12 60
}

add() {
  local name enc_pass key pass

  key=$(whiptail --passwordbox "Enter key:" 10 50 3>&1 1>&2 2>&3) || return 1
  name=$(whiptail --inputbox "Title / service name:" 10 50 "" 3>&1 1>&2 2>&3) || return 1
  pass=$(whiptail --passwordbox "Password:" 10 50 3>&1 1>&2 2>&3) || return 1

  enc_pass=$(encrypt "$pass" "$key")

  # FIX: always write {"passwords":[...]} so .passwords is always a valid key
  if [ ! -f "$passpath" ] || ! jq empty "$passpath" 2>/dev/null; then
    jq -n --arg name "$name" --arg epass "$enc_pass" \
      '{passwords: [{name: $name, pass: $epass}]}' > "$passpath"
        else
          jq --arg name "$name" --arg epass "$enc_pass" \
            '.passwords += [{name: $name, pass: $epass}]' "$passpath" > /tmp/pass.tmp \
            && mv /tmp/pass.tmp "$passpath"
  fi

  whiptail --msgbox "Added '$name' successfully." 8 50
}

remove() {
  local count i name args choice idx

  count=$(jq '.passwords | length' "$passpath" 2>/dev/null || echo 0)
  [ "$count" -eq 0 ] && { whiptail --msgbox "No passwords stored yet." 8 40; return 1; }

  local visible=$(( count < 15 ? count : 15 ))

  local args=()
  args+=("--title" "Remove Entry")
  args+=("--menu" "Choose entry to remove:" $(( visible + 8 )) 70 "$visible")

  for i in $(seq 1 $count); do
    name=$(jq -r ".passwords[$((i-1))].name // \"Entry $i\"" "$passpath")
    args+=("$i" "$name")
  done

  choice=$(whiptail "${args[@]}" 3>&1 1>&2 2>&3) || return 1

  idx=$((choice - 1))
  name=$(jq -r ".passwords[$idx].name" "$passpath")

  whiptail --yesno "Delete '$name'?" 8 40 || return 1

  jq --argjson idx "$idx" 'del(.passwords[$idx])' "$passpath" > /tmp/pass.tmp \
    && mv /tmp/pass.tmp "$passpath"

  whiptail --msgbox "Deleted '$name'." 8 40
}

while true; do
  MENU=$(whiptail --title "Password Encryption" --menu "Choose:" 15 60 4 \
    "1)" "Decrypt / view password" \
    "2)" "Add password" \
    "3)" "Remove password" \
    "4)" "Quit" 3>&1 1>&2 2>&3) || break   # ESC / Ctrl-C exits cleanly

  case $MENU in
    "1)") decrypt_entry ;;
    "2)") add ;;
    "3)") remove ;;
    "4)") break ;;
  esac
done
