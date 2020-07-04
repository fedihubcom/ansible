for vault_id in default kotovalexarian
do
  if [ -f "secrets/$vault_id" ]; then
    if [ -z "$extra_opts" ]; then
      extra_opts="--vault-id"
    else
      extra_opts="$extra_opts --vault-id"
    fi

    extra_opts="$extra_opts $vault_id@secrets/$vault_id"
  fi
done
