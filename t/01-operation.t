use lib 'lib';
use Test;

plan 4;

my $code = ｢
    my $*PERL := class FakePerl {
        method compiler {
            class FakeCompiler {
                has $.id   = '2357471601F275BAC6F2A55E972FEECEA97BC47'
                  ~ '8.1492376576.44754';
                has $.name = 'rakudo';
                has $.version = v2017.03.290.gf.6387.a.845;
            }.new
        }
    }.new;
    use lib 'lib';
    require RakudoPrereq $ARGS;
    say "alive";
｣;

subtest 'die when given version' => {
    plan 2;
    with run :out, :err, $*EXECUTABLE, '-e', $code.subst('$ARGS', 'v420000') {
        ok .out.slurp(:close).contains('alive').not, 'died';
        ok .err.slurp(:close).contains('requires Rakudo compiler v420000'),
          'error message tells us which Rakudo version needed';
    }
}

subtest 'die when given version and custom message' => {
    plan 2;
    with run :out, :err, $*EXECUTABLE, '-e', $code.subst(
      '$ARGS', 'v420000, "custom message"'
    ) {
        ok .out.slurp(:close).contains('alive').not, 'died';
        ok .err.slurp(:close).contains('custom message v420000'),
          'error message has custom message and Rakudo version';
    }
}

subtest 'die when given version and rakudo-only' => {
    plan 3;
    with run :out, :err, $*EXECUTABLE, '-e', $code.subst(
      '$ARGS', 'v420000, "", "rakudo-only"'
    ).subst(｢'rakudo'｣, 'something else') {
        ok .out.slurp(:close).contains('alive').not, 'died';
        with .err.slurp(:close) {
            ok .contains('requires Rakudo compiler'),
                'error message tells us we need Rakudo';
            ok .contains('v420000').not, 'error does not mention version';
        }
    }
}

subtest 'die when given version and rakudo-only' => {
    plan 3;
    with run :out, :err, $*EXECUTABLE, '-e', $code.subst(
      '$ARGS', 'v420000, "custom message", "rakudo-only"'
    ).subst(｢'rakudo'｣, 'something else') {
        ok .out.slurp(:close).contains('alive').not, 'died';
        with .err.slurp(:close) {
            ok .contains('custom message'), 'error message has custom message';
            ok .contains('v420000').not, 'error does not mention version';
        }
    }
}
