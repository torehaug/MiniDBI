# MiniDBI/t/10-mysql.t

use Test;

plan 4;

use MiniDBI;

my $mdriver       = 'mysql';
my $hostname      = 'localhost';
my $port          = 3306;
my $database      = 'zavolaj';
my $test_user     = 'testuser';
my $test_password = 'testpass';
my $test_dsn      = "MiniDBI:$mdriver" ~ ":database=$database;" ~
                    "host=$hostname;port=$port";

my $drh;
$drh = MiniDBI.install_driver($mdriver);
ok $drh, 'Install driver'; # test 1
my $drh_version;
$drh_version = $drh.Version;
ok $drh_version > 0, "MiniDBD::mysql version $drh_version"; # test 2

	my $dbh = MiniDBI.connect( $test_dsn, $test_user, $test_password,
	        RaiseError => 1, PrintError => 1, AutoCommit => 0
	);
	# die "ERROR: {MiniDBI.errstr}. Can't continue test" if $!.defined;
	ok $dbh.defined, "Connected to database"; # test 3
	my $disconnectResult = $dbh.disconnect();
	ok $disconnectResult eq 'True', 'disconnect returned true'; # test 4


#{
#	# test ping
#	my $dbh = MiniDBI.connect( $test_dsn, $test_user, $test_password,
#	        RaiseError => 1, PrintError => 1, AutoCommit => 0
#	);
#	# die "ERROR: {MiniDBI.errstr}. Can't continue test" if $!.defined;
#	ok $dbh.defined, "Connected to database"; # test 3
#	ok $dbh.ping, "ping database after connect OK"; # test 3
#	my $result = $dbh.disconnect();
#	ok !$dbh.ping, "ping database after disconnect OK"; # test 3
#}
