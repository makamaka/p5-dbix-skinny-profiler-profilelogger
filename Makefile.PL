use inc::Module::Install;
name 'DBIx-Skinny-Profiler-ProfileLogger';
all_from 'lib/DBIx/Skinny/Profiler/ProfileLogger.pm';

requires 'DBIx::Skinny';

author_tests('xt');

build_requires 'Test::More';

use_test_base;
auto_include;
auto_set_repository;
WriteAll;

1;
__END__
