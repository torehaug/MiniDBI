 use v6;
 use MiniDBI;


sub MAIN($sleep) {

 say "** in MAIN";
 unless ($sleep) {
	$sleep = 1;
 }

 say "** check mysql connection p6....";
 my $conn = getMysqlConnection('zavolaj');
 say "- alive after connect";
 selectRows($conn, 'foo');
 say " - alive after select";

# say "sleeping for $sleep seconds, shutdown mysql...";
# sleep($sleep);

 say '** (1) Mysql ping in client: "'~ $conn.ping() ~'"';

 say "sleeping for $sleep seconds, shutdown mysql...";
 sleep($sleep);

 say '** (2) Mysql ping in client: "'~ $conn.ping() ~'"';

 say '** Calling disconnect in client';
 my $disconnectResult = $conn.disconnect();
 say ' - result:  '~ $disconnectResult;
 if ($disconnectResult eq "True") {
	say ' - Disconnect OK';
 } else {
	say ' - Disconnect NOT OK';
 }

 say '** (3) Mysql ping in client: "'~ $conn.ping() ~'"';
}


sub selectRows {
 my ($dbh, $table) = @_;
 my $sth = $dbh.prepare('SELECT * FROM '~ $table);
 $sth.execute();
# print "field count: "~ $sth.mysql_field_count;

 my $result = $sth.fetchrow_hashref();
 print "Value returned: $result\n";

}

sub getMysqlConnection {
 my ($database) = @_;

my $mdriver       = 'mysql';
my $hostname      = 'localhost';
my $port          = 3306;
my $test_user     = 'testuser';
my $test_password = 'testpass';
 
 ######



 my $test_dsn      = "MiniDBI:$mdriver" ~ ":database=$database;" ~
                    "host=$hostname;port=$port";

 warn("** Installing driver... "~ $mdriver);
# my $drh = MiniDBI.install_driver($mdriver);

 warn("** Trying connecting to "~ $test_dsn);
 my $dbh = MiniDBI.connect( $test_dsn, $test_user, $test_password,
        RaiseError => 1, PrintError => 1, AutoCommit => 0 );
    CATCH { die "ERROR. Unable to connect to server\n"; }

 return $dbh;

} 

