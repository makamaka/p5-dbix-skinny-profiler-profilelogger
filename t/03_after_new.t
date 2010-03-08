use lib './t';
use Test::More;
use strict;
use warnings;
use DBIx::Skinny::Profiler::ProfileLogger;

BEGIN {
    eval "use DBD::SQLite";
    plan skip_all => "DBD::SQLite is not installed. skip testing" if $@;
    $ENV{SKINNY_PROFILE} = '1=query.log';
}

use Mock::Basic2;

my ( $file ) = $ENV{SKINNY_PROFILE} =~ /=(.+)$/;

if ( -s $file ) {
    unlink $file;
}

my $skinny = Mock::Basic2->new;

$skinny->setup_test_db;

$skinny->attribute->{ profiler } = DBIx::Skinny::Profiler::ProfileLogger->new;

my $user = $skinny->insert( 'user', { name => 'a' } );
$skinny->single( 'user', { id => $user->id }, );

$skinny->profiler->close_fh();

my $line;

open( my $fh, $file ) or die $!;

seek( $fh, 0, 0 );

like( scalar <$fh>, qr/INSERT INTO / );
like( scalar <$fh>, qr/SELECT id, name FROM user/ );

close( $fh );

if ( -e $file ) {
    unlink $file or warn $!;
}

done_testing();

1;
__END__
