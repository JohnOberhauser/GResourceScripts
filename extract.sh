BRANCHES=$(gresource list gtk.gresource)

array=(${BRANCHES// / })
mkdir -p extracted

for i in "${!array[@]}"
do
	item=${array[i]}
	file=$(echo $item | sed 's:.*/::')
	gresource extract gtk.gresource $item > extracted/$file
done
