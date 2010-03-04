package Mock::Basic2::Schema;
use utf8;
use DBIx::Skinny::Schema;


install_table 'user' => schema {
    pk 'id';
    columns qw( id name );
};


1;
__END__
