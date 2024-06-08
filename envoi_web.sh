echo "################################################################################"
echo "# script pour envoyer des archive web (par default) a un serveur de stockage"
echo "# developper par oscar jundt-schmitter"
echo "# donnee a donner au script :"
echo "#	l'ip du serveur de stockage"
echo "#	l'identifiant de connection"
echo "#	le chemin des donneex archiver(par default /var/www)"
echo "################################################################################"
dateActuelle=$(date)
#demande ou sont sotcker les site, si null chemin par default
if [ "$3" == "" ] ; then
	read -p "donner chemin: " chemin
	if [ "$chemin" == "" ] ; then
		cd /var/www
	else
		cd $chemin
	fi
elif [ "$3" != "" ] ; then
	cd $3
else
	cd /var/www
fi

#chek si les donne de connection ssh on etait donner
#si c'est pas le cas, il les demande
if [ "$1" == "" ] && [ "$2" == "" ] ; then
	read -p "donner user ssh: " user
	read -p "donner ip: " ip
elif [ "$1" != "" ] && [ "$2" != "" ] ; then
	user=$1
	ip=$2
fi

#check si les donner de connection ou bien etait mis
#si c'est pas le cas, il fait aucune connection
if [ "$user" != "" ] && [ "$ip" != "" ] ; then
	#creation de l'archive en .tar
	sudo tar -cvf archive.tar .
	
#connection en ssh pour checker et creer un dossier
ssh "$user@$ip" << he		
if [ ! -d "archive_web" ] ; then	
mkdir archive_web		
fi		
cd archive_web
mkdir "archive_$dateActuelle"
he

#connection en sftp pour envoyer l'archive au servuer de stockage
sftp "$user@$ip" << h
cd archive_web/"archive_$dateActuelle"
put archive.tar
h
rm archive.tar
echo "chemin du fichier ~/archive_web/archive_$dateActuelle"
else
	echo "interrupt"
fi
