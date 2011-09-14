##
# name:      File::Share
# abstract:  Extend File::ShareDir to Local Libraries
# author:    Ingy döt Net <ingy@ingy.net>
# license:   perl
# copyright: 2011
# see:
# - File::ShareDir
# - Devel::Local

use v5.8.3;
package File::Share;
use strict;
use warnings;

our $VERSION = '0.02';

use base 'Exporter';
our @EXPORT_OK   = qw[
    dist_dir
    dist_file
    module_dir
    module_file
    class_dir
    class_file
];
our %EXPORT_TAGS = (
    all => [ @EXPORT_OK ],
    ALL => [ @EXPORT_OK ],
);

use File::ShareDir 1.03 ();
use Cwd qw[abs_path];
use File::Spec ();

sub dist_dir {
    my ($dist) = @_;
    (my $inc = $dist) =~ s!(-|::)!/!g;
    $inc .= '.pm';
    my $path = $INC{$inc} || '';
    if ($path and
        $path =~ s!(\S.*?)[\\/]?\bb?lib\b.*!$1! and
        -e "$path/Makefile.PL" and
        -e "$path/share"
    ) {
        return abs_path "$path/share";
    }
    else {
        return File::ShareDir::dist_dir($dist);
    }
}

sub dist_file {
    my ($dist, $file) = @_;
    my $dir = dist_dir($dist);
    return File::Spec->catfile( $dir, $file );
}

sub module_dir {
    die "File::Share::module_dir not yet supported";
}

sub module_file {
    die "File::Share::module_file not yet supported";
}

=head1 SYNOPSIS

    use File::Share ':all';

    my $dir = dist_dir('Foo-Bar');
    my $file = dist_file('Foo-Bar', 'file.txt');

=head1 DESCRIPTION

THis module is a dropin replacement for L<File::ShareDir>. It supports the
C<dist_dir> and C<dist_file> functions, except these functions have been
enhanced to understand when the developer's local C<./share/> directory should
be used.

NOTE: module_dist and module_file are not yet supported, because (afaik) there
is no well known way to populate per-module share files. This may change in
the future. Please contact me if you know how to do this.

=head1 PROBLEM AND SOLUTION

L<Module::Install> has an C<install_share> directive that allows you to
install various files associated with a distribution. By convention, module
authors always put these in a directory called C<share/>. However,
File::ShareDir can only find files after they have been installed. This can be
problematic when running development tests.

File::Share will look for a local C<share> directory, if it notices that the
module corresponding was loaded from a development path.

L<Devel::Local> gives you an easy way to use a bunch of source repositories as
though their lib and bin directories had already been installed.
C<File::Share> lets you play along with that.

