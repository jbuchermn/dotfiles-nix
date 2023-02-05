#/usr/bin/env bash
CONFIG_FILE=$1
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Could not find $1"
    exit 1
fi

CONFIG_FILE_BACKUP="$CONFIG_FILE.symlink_backup"
while [ -f "$CONFIG_FILE_BACKUP" ]; do
    CONFIG_FILE_BACKUP="$CONFIG_FILE_BACKUP~"
done

mv "$CONFIG_FILE" "$CONFIG_FILE.symlink_backup"
cp "$CONFIG_FILE_BACKUP" "$CONFIG_FILE"
chmod +w "$CONFIG_FILE"

if [ "$2" = "-v" ]; then
    vim "$CONFIG_FILE"
else
    echo "Ready to start working on $CONFIG_FILE - ctr-c to quit"
    ( trap exit SIGINT ; read -r -d '' _ </dev/tty )
fi

FINAL_FILE="./$(basename $CONFIG_FILE)"
while [ -f "$FINAL_FILE" ]; do
    FINAL_FILE="$FINAL_FILE~"
done

echo "Relinking and placing updated config in $FINAL_FILE"
mv "$CONFIG_FILE" "$FINAL_FILE"
mv "$CONFIG_FILE_BACKUP" "$CONFIG_FILE"

echo "Changes:"
git diff --no-index "$(readlink -f $CONFIG_FILE)" "$FINAL_FILE"
