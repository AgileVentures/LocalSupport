sudo apt-get install -y git
sudo apt-get install -y curl
\curl -L https://get.rvm.io | bash -s stable  --ruby=1.9.3
source ~/.rvm/scripts/rvm

sudo apt-get install libqtwebkit-dev  # had to type Y
gem install debugger-ruby_core_source

export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

sudo apt-get install -y libpq-dev
sudo apt-get install -y postgresql

cd /LocalSupport

bundle install

# need to edit /etc/postgresql/9.1/main/pg_hba.conf
# needs work to handle variable white space
# sed -i '' -e 's/local\s\+all\s\+postgres\s\+peer/local all postgres peer map=basic/g' /etc/postgresql/9.1/main/pg_hba.conf

# need to edit /etc/postgresql/9.1/main/pg_ident.conf
sudo cat 'basic vagrant postgres' >> /etc/postgresql/9.1/main/pg_ident.conf

sudo /etc/init.d/postgresql restart

# this needs to run in psql
#UPDATE pg_database SET datallowconn = TRUE where datname = 'template0';
#\c template0
#UPDATE pg_database SET datistemplate = FALSE where datname = 'template1';
#drop database template1;
#create database template1 with template = template0 encoding = 'UNICODE'  LC_CTYPE = 'en_US.UTF-8' LC_COLLATE = 'C';
#UPDATE pg_database SET datistemplate = TRUE where datname = 'template1';
#\c template1
#UPDATE pg_database SET datallowconn = FALSE where datname = 'template0';

sudo apt-get install -y xvfb
sudo apt-get install libicu48

sudo apt-get install xvfb x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps  # not needed?

Xvfb :1 -screen 0 1280x768x24 &
export DISPLAY=:1

bundle exec rake db:create
bundle exec rake db:migrate

# must get that branch on the command line thing setup

/**  complete history from install process

vagrant@precise32:~/LocalSupport$ history
    1  cat /etc/rc.local
    2  sudo update-locale LANG=en_US
    3  sudo locale-gen en_US
    4  sudo update-locale LANG=en_US
    5  hist
    6  history
    7  sudo apt-get install -y git
    8  sudo apt-get install -y curl
    9  \curl -L https://get.rvm.io | bash -s stable  --ruby=1.9.3
   10  source ~/.rvm/scripts/rvm
   11  ruby -v
   12  git clone https://github.com/tansaku/LocalSupport
   13  cd LocalSupport/
   14  bundle install
   15  sudo apt-get install -y libqtwebkit-dev
   16  bundle install
   17  bundle update debugger-ruby_core_source
   18  gem install debugger-ruby_core_source
   19  bundle install
   20  sudo apt-get install -y libpq-dev
   21  bundle install
   22  bundle exec rake db:create
   23  nano /etc/postgresql/9.1/main/pg_hba.conf
   24  nano /etc/postgresql/9.1/main/pg_hba.conf
   25  sudo nano /etc/postgresql/9.1/main/pg_hba.conf
   26  sudo /etc/init.d/postgresql restart
   27  sudo nano /etc/postgresql/9.1/main/pg_hba.conf
   28  sudo /etc/init.d/postgresql restart
   29  sudo nano /etc/postgresql/9.1/main/pg_hba.conf
   30  sudo /etc/init.d/postgresql restart
   31  bundle exec rake db:create
   32  sudo nano /etc/postgresql/9.1/main/pg_hba.conf
   33  sudo nano /etc/postgresql/9.1/main/pg_ident.conf
   34  bundle exec rake db:create
   35  sudo /etc/init.d/postgresql restart
   36  bundle exec rake db:create
   37  sudo /etc/init.d/postgresql reload
   38  bundle exec rake db:create
   39  sudo nano /etc/postgresql/9.1/main/pg_hba.conf
   40  sudo nano /etc/postgresql/9.1/main/pg_ident.conf
   41  bundle exec rake db:create
   42  sudo /etc/init.d/postgresql restart
   43  bundle exec rake db:create
   44* sed 's/local all postgres peer/local all postgres peer map=basic/g'
   45  sudo sed 's/local all postgres peer/local all postgres peer map=basic/g' /etc/postgresql/9.1/main/pg_hba.conf
   46  sudo nano /etc/postgresql/9.1/main/pg_hba.conf
   47  sudo sed 's/local all postgres peer/local all postgres peer map=basic/g' /etc/postgresql/9.1/main/pg_hba.conf
   48  sudo sed 's/local\s*all\s*postgres\s*peer/local all postgres peer map=basic/g' /etc/postgresql/9.1/main/pg_hba.conf
   49  sudo sed "s/local\s*all\s*postgres\s*peer/local all postgres peer map=basic/g" /etc/postgresql/9.1/main/pg_hba.conf
   50  sudo sed -e 's/local\s*all\s*postgres\s*peer/local all postgres peer map=basic/g' /etc/postgresql/9.1/main/pg_hba.conf
   51  bundle exec rake db:create
   52  printenv
   53  export LANG=en_US.UTF-8
   54  locale
   55  bundle exec rake db:create
   56  sudo /etc/init.d/postgresql restart
   57  sudo nano /etc/postgresql/9.1/main/pg_hba.conf
   58  bundle exec rake db:create
   59  sudo nano /etc/postgresql/9.1/main/pg_hba.conf
   60  sudo nano /etc/postgresql/9.1/main/pg_ident.conf
   61  sudo /etc/init.d/postgresql restart
   62  bundle exec rake db:create
   63  locale
   64  nano /etc/profile.d/lang.sh
   65  sudo nano /etc/profile.d/lang.sh
   66  export LANGUAGE="en_US.UTF-8"
   67  export LANG="en_US.UTF-8"
   68  export LC_ALL="en_US.UTF-8"
   69  bundle exec rake db:create
   70  sudo su postgres
   71  history
   72  sudo /etc/init.d/postgresql restart
   73  bundle exec rake db:create
   74  sudo su postgres
   75  psql -u postgres
   76  psql --help
   77  psql -U postgres
   78  bundle exec rake db:create
   79  bundle exec rake db:categories
   80  bundle exec rake db:migrate
   81  bundle exec rake spec
   82  bundle exec rake cucumber
   83  sudo apt-get install libicu48
   84  bundle exec rake cucumber
   85  export DISPLAY=:1
   86  bundle exec rake cucumber
   87  git remote add david https://github.com/dcorking/LocalSupport
   88  git remote add jon https://github.com/johnnymo87/LocalSupport
   89  git remote add marian git@github.com:marianmosley/LocalSupport.git
   90  git fetch david
   91  git fetch jon
   92  git fetch marian
   93  git remote rm marian
   94  git remote -v
   95  git remote add marian https://github.com/marianmosley/LocalSupport
   96  git fetch marian
   97  history
*/