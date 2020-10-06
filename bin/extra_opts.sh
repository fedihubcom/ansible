FILE=$(readlink -f "$0")
DIR=$(dirname "$FILE")
ROOT=$(dirname "$DIR")

if [ ! -f "$ROOT/admin" ]; then
  >&2 echo 'error: admin is not specified'
  exit 1
fi

admin="$(cat "$ROOT/admin")"

if [ -z "$admin" ]; then
  >&2 echo 'error: admin is not specified'
  exit 1
fi

extra_opts="--extra-vars admin=$admin"

for vault_id in kotovalexarian xuhcc
do
  if [ -f "$ROOT/secrets/$vault_id" ]; then
    extra_opts="$extra_opts --vault-id $vault_id@$ROOT/secrets/$vault_id"
  fi
done
