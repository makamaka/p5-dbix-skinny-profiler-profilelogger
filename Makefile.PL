use inc::Module::Install;
name 'DBIx-Skinny-Profiler-ProfileLogger';
all_from 'lib/DBIx/Skinny/Profiler/ProfileLogger.pm';
auto_set_repository;

requires 'DBIx::Skinny';

author_tests('xt');

build_requires 'Test::More';

use_test_base;
auto_include;

repository 'http://github.com/makamaka/p5-dbix-skinny-profiler-profilelogger';

WriteAll;

1;
__END__
