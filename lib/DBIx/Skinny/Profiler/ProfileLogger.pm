package DBIx::Skinny::Profiler::ProfileLogger;

use 5.008;
use strict;
use warnings;
use DBIx::Skinny::Accessor;
use Carp ();

mk_accessors(qw/ log_fh /);

our $VERSION = '0.05';


sub init {
    my $self = shift;
    my $env  = $ENV{SKINNY_PROFILE};

    return unless $env;

    $self->open_fh( $env );
}


sub open_fh {
    my ( $self, $env ) = @_;
    my $fh;

    if ( $env =~ /=(.+)$/ ) {
        open( $fh, '>>', $1 ) or Carp::croak "$! $env";
    }
    else {
        $fh = *STDERR;
    }

    $fh->autoflush();
    $self->log_fh( $fh );
}


sub close_fh {
    my ( $self ) = @_;
    my $fh = $self->log_fh;
    close( $fh );
}


sub record_query {
    my ($self, $sql, $bind) = @_;
    my $fh  = $self->log_fh;
    my $log = _normalize($sql);

    if (ref $bind eq 'ARRAY') {
        my @binds;
        push @binds, defined $_ ? $_ : 'undef' for @$bind;
        $log .= ' :binds ' . join ', ', @binds;
    }

    print $fh $log, "\n";
}


sub _normalize { # copied from origianl DBIx::Skinny::Profiler
    my $sql = shift;
    $sql =~ s/^\s*//;
    $sql =~ s/\s*$//;
    $sql =~ s/[\r\n]/ /g;
    $sql =~ s/\s+/ /g;
    return $sql;
}


1;
__END__

=pod

=encoding utf8

=head1 NAME

DBIx::Skinny::Profiler::ProfileLogger - a profiler printing at once instead of recording queries.

=head1 SYNOPSIS
    
    package Your::Model;
    
    use DBIx::Skinny::Profiler::ProfileLogger;
    use DBIx::Skinny setup => +{
        dsn => 'dbi:SQLite:',
        username => '',
        password => '',
        profiler => >DBIx::Skinny::Profiler::ProfileLogger->new,
    };
    
    # or 
    
    package main;
    
    my $skinny = Your::Model->new;
    $skinny->attribute->{ profiler } = DBIx::Skinny::Profiler::ProfileLogger->new;
    
    # You set the environment variable SKINNY_PROFILE=1, then print to STDERR.
    # If set SKINNY_PROFILE=1=/path/to/file, logs to the file.


=head1 DESCRIPTION

DBIx::Skinny::Profiler records SQL statements and bind params but
you need to print out recorded queries manually.

This module prints out STDERR or your specified file at once instead of recording queries.

The environmental variable C<SKINNY_PROFILE> must be set with C<1> for using this profiler.

  $ENV{SKINNY_PROFILE} = 1;

If you add a file path to its value, this module print to the spcified file.

  $ENV{SKINNY_PROFILE} = '1=/path/to/file'; # (DBIC_TRACE compat)


=head1 SEE ALSO

L<DBIx::Skinny>,
L<DBIx::Skinny::Profiler>

=head1 AUTHOR

Makamaka Hannyaharamitu, E<lt>makamaka[at]cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Makamaka Hannyaharamitu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
