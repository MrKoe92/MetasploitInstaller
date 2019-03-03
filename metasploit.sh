#!/data/data/com.termux/files/usr/bin/bash 

cwd=$(pwd)
name=$(basename "$0")
export msfinst="$cwd/$name"

msfver=5.0.8
msfpath='/data/data/com.termux/files/home'
if [ -d "$msfpath/metasploit-framework" ]; then
	echo "[#]Deleting Obsolete Files..."
        rm $msfpath/metasploit-framework -rf
fi
apt update
apt install -y autoconf bison clang coreutils curl figlet findutils git apr apr-util libffi-dev libgmp-dev libpcap-dev postgresql-dev readline-dev libsqlite-dev openssl-dev libtool libxml2-dev libxslt-dev ncurses-dev pkg-config wget make ruby-dev libgrpc-dev termux-tools ncurses-utils ncurses unzip zip tar postgresql termux-elf-cleaner ruby
figlet -c "Metasploit!!"
echo "

[#] MetaSploit Framework Installer by @hewhomustn0tbenamed (Telegram)!!
[#] Join @VoldemortCommunity (Telegram) For More!!
[#] Last Update : 28/02/2019 
[#] Contact me on Telegram if you Face and Problems!!
[#] v0.3
[#] GitHub : https://github.com/VoldemortCommunity

"
cd $msfpath
curl -LO https://github.com/rapid7/metasploit-framework/archive/$msfver.tar.gz
tar -xf $msfpath/$msfver.tar.gz
mv $msfpath/metasploit-framework-$msfver $msfpath/metasploit-framework
cd $msfpath/metasploit-framework
if [ $(gem list -i rubygems-update) == false ]; then
        gem install rubygems-update
fi

gem install bundler

gem install bigdecimal
gem install pg --version=0.20.0 -- --use-system-libraries
if [ $(gem list -i rubygems-update) == false ]; then
        gem install rubygems-update
fi

update_rubygems

cd $msfpath/metasploit-framework
bundle install -j5

echo "[#]Gems Installed..."
$PREFIX/bin/find -type f -executable -exec termux-fix-shebang \{\} \;

if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
fi
if [ -e $PREFIX/bin/msfvenom ];then
	rm $PREFIX/bin/msfvenom
fi

echo "#!/data/data/com.termux/files/usr/bin/bash
pg_ctl -D $PREFIX/var/lib/postgresql restart
ruby $msfpath/metasploit-framework/msfconsole" > $PREFIX/bin/msfconsole

echo "#!/data/data/com.termux/files/usr/bin/bash
ruby $msfpath/metasploit-framework/msfvenom" > $PREFIX/bin/msfvenom

chmod +rwx $PREFIX/bin/msfconsole
chmod +rwx $PREFIX/bin/msfvenom

(termux-elf-cleaner /data/data/com.termux/files/usr/lib/ruby/gems/2.4.0/gems/pg-0.20.0/lib/pg_ext.so) & 
spinner $!

echo "[#]Creating database...."

cd $msfpath/metasploit-framework/config
curl -LO https://Auxilus.github.io/database.yml

mkdir -p $PREFIX/var/lib/postgresql
initdb $PREFIX/var/lib/postgresql

pg_ctl -D $PREFIX/var/lib/postgresql start
createuser msf
createdb msf_database

rm $msfpath/$msfver.tar.gz


cd $cwd

bash fix-ruby.sh

echo "

[#]You Can directly use msfvenom or msfconsole as they are Symlinked 
to $PREFIX/bin
[#]Join @VoldemortCommunity (Telegram) for More!!!
[#]GitHub : https://GitHub.com/VoldemortCommunity"
