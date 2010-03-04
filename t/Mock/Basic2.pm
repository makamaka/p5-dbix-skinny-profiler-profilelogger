package Mock::Basic2;


use DBIx::Skinny setup => +{
    dsn => 'dbi:SQLite:',
    username => '',
    password => '',
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

