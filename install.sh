
# paths
dirname=$(dirname $0)
lib="/usr/local/lib"
bin="/usr/local/bin"

# make in case they aren't already there
mkdir -p "/usr/local/lib"
mkdir -p "/usr/local/bin"

# Copy the path
sudo cp -R $dirname "$lib/"

# remove existing bin if it exists
if [ -e "$bin/knots" ]; then
  rm "$bin/knots"
fi

# symlink knots
ln -s "$lib/knots/knots" "$bin/knots"