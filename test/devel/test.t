use strict;
use File::Basename;

use Test::More tests => 2;

use File::Share ':all';
use Cwd qw[abs_path cwd];

my $xt = -e 'xt' ? 'xt' : 'test/devel';
my $share_dir = abs_path "$xt/Foo-Bar/share";
my $share_file = abs_path "$xt/Foo-Bar/share/o/hai.txt";

use lib dirname(__FILE__) . '/Foo-Bar/lib';
use Foo::Bar;

is dist_dir('Foo-Bar'), $share_dir, 'Dir is correct';
is dist_file('Foo-Bar', 'o/hai.txt'), $share_file, 'File is correct';
