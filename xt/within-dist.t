use Test::More tests => 2;

use File::Share ':all';
use Cwd qw[abs_path cwd];

BEGIN {
    chdir 'xt/Foo-Bar'
        or die "Can't chdir: $!";
}

my $share_dir = abs_path 'share';
my $share_file = abs_path 'share/o/hai.txt';

use lib "lib";
use Foo::Bar;

is dist_dir('Foo-Bar'), $share_dir, 'Dir is correct';
is dist_file('Foo-Bar', 'o/hai.txt'), $share_file, 'File is correct';
