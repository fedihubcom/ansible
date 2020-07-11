extra_opts="--extra-vars admin=$(cat admin)"

for vault_id in default kotovalexarian xuhcc
do
  if [ -f "secrets/$vault_id" ]; then
    extra_opts="$extra_opts --vault-id $vault_id@secrets/$vault_id"
  fi
done
