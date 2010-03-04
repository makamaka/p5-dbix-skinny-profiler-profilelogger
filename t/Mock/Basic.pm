package Mock::Basic;

use DBIx::Skinny::Profiler::ProfileLogger;

use DBIx::Skinny setup => +{
    dsn => 'dbi:SQLite:',
    username => '',
    password => '',
    profiler => DBIx::Skinny::Profiler::ProfileLogger->new,
};


sub setup_test_db {
    my $self = shift;

    for my $table ( qw( user ) ) {
        $self->do(qq{
            DROP TABLE IF EXISTS $table
        });
    }

    $self->do(q{
        CREATE TABLE user (
            id      integer,
            name    text,
            primary key( id )
        )
    });

}

sub creanup_test_db {
}


1;

