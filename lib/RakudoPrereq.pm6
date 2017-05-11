sub EXPORT (Version:D $v, Str $message is copy = '', Str:D $opts = '') {
    $message = 'This program requires Rakudo compiler' unless $message;
    $*PERL.compiler.name ne 'rakudo'
      and $opts.contains('rakudo-only')
      and die $message;

    $*PERL.compiler.version before $v and die "$message $v.perl() or newer";

    Map.new
}
