package File::Share;
our $VERSION = '0.16';
use strict;
use warnings;

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

    # dirname() without the quirks (like dirname("Foo.pm") eq ".")
    my $inc_dir = (File::Spec->splitpath($inc))[1];

    # Start with all relative components and symlinks resolved to avoid surprises
    my $path = abs_path($INC{$inc} || '');

    # Portably $path =~ s{\Q$inc\E$}{../}, that is, chop off the "module path"
    # and go up a directory (under the assumption that all module paths are
    # going to be at least one-level deep from the directory containing
    # share/).  This works well when modules are under the traditional lib/
    # layout.  If packages are loaded via some other, non-traditional means
    # (e.g. an @INC hook), the assumption that
    #
    #   $INC{"Foo/Bar.pm"} =~ m{Foo/Bar\.pm$}
    #
    # may not hold.
    my ($vol, $dir, $file) = File::Spec->splitpath($path);
    my @dirs     = File::Spec->splitdir( File::Spec->canonpath($dir) );
    my @inc_dirs = File::Spec->splitdir( File::Spec->canonpath($inc_dir) );
    pop @dirs while pop @inc_dirs;
    pop @dirs;
    $path = File::Spec->catpath( $vol, File::Spec->catdir(@dirs), '' );

    if ($path and
        -d "$path/lib" and
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

1;
