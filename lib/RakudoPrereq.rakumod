sub EXPORT(Version:D $v, Str $user-message?, Str() $opts = '') {
    my constant @valid-opts = <rakudo-only  no-where>;
    my constant $message = 'This program requires Rakudo compiler';
    my $where-to = (try $*W.current_file) // '<unknown file>';

    (my %opts = $opts.lc.words »=>» 1).keys.grep(none @valid-opts) and die
        "Only @valid-opts.map({"'$_'"}).join(', ') are valid as options to"
          ~ " RakudoPrereq but got %opts.keys.sort.map({"'$_'"}).join(', ')"
          ~ " at $where-to";

    my $out = ($*RAKU.compiler.name ne 'rakudo' and %opts<rakudo-only>)
        ?? ($user-message || $message)
        !! ($*RAKU.compiler.version before $v)
            ?? ($user-message || "$message version $v.raku() or newer; this is"
              ~ " $*RAKU.compiler.version.raku()")
            !! return Map.new;  # okidoki

    $out ~= "\nat $where-to" unless %opts<no-where>;
    note $out;
    exit 1;
}

=begin pod

=head1 NAME

RakudoPrereq - Specify minimum required versions of Rakudo

=head1 SYNOPSIS

=begin code :lang<raku>

use RakudoPrereq v2021.04; # specify minimum Rakudo version 2021.04

# specify minimum Rakudo version 2021.04, with custom message
# when user's Rakudo is too old
use RakudoPrereq v2021.04, 'Your Raku is way too old, bruh!';

# specify minimum Rakudo version 2021.04, use default message and die
# when non-Rakudo compiler is used
use RakudoPrereq v2021.04, '', 'rakudo-only';

# specify minimum Rakudo version 2021.04, use custom message and die
# when non-Rakudo compiler is used
use RakudoPrereq v2021.04, 'your compiler is no good', 'rakudo-only';

# specify minimum Rakudo version 2021.04, use default message and die
# when non-Rakudo compiler is used and don't print location of `use`
use RakudoPrereq v2021.04, '', 'rakudo-only no-where';

=end code

=head1 DESCRIPTION

Need to black-list non-Rakudo compilers or some Rakudo versions that implement
the same language version? This module is for you!

If the program is run on a Rakudo that's too old, the module will print a
message and exit with status `1`

=head1 USAGE

The entire API is via the arguments specified on the `use RakudoPrereq` line.

=head2 Minimum Rakudo version

The first argument is required and is the L<C<Version>|https://docs.raku.org/type/Version>
object specifying the minimum required Rakudo version.

=head2 Custom message

By default, the module will print a generic message before exiting,
you can specify a custom message here. Default message will be printed
if the specified custom message is an empty string.

=head2 String with options

Space-separated string of options:

=head3 rakudo-only

By default, the module would not fail if the compiler is not Rakudo.
Specify this option if you want to fail for non-Rakudo compilers as
well, regardless of their version.

=head3 no-where

Both the default and custom message will have the location of where
the C<use RakudoPrereq> that caused failure is at. Specify this argument
if you want to surpress that information.

=head1 AUTHOR

Zoffix Znet

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Zoffix Znet

Copyright 2018 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
