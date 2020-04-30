echo Enter Theme Name:
read themeName

cd extracted/

FILES=$(find . -type f -printf "%P\n" | xargs -i echo "    <file>{}</file>")

cat <<EOF >"gtk.gresource.xml"
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/$themeName">
$FILES
  </gresource>
</gresources>
EOF

glib-compile-resources gtk.gresource.xml

cd ..

mkdir -p build/

mv extracted/gtk.gresource build/

cd build/

BRANCHES=$(gresource list gtk.gresource)
array=(${BRANCHES// / })
for i in "${!array[@]}"
do
	item=${array[i]}
	file=$(echo $item | sed 's:.*/::')
	if [[ $item != *"png"* ]] && [[ $item != *"dark"* ]]; then
    echo "@import url(\"resource://$item\");" >> gtk.css
  elif [[ $item != *"png"* ]]; then
    echo "@import url(\"resource://$item\");" >> gtk-dark.css
	fi
done
