module Sort::Naturally:ver<0.1.0>;
use v6;
use MONKEY_TYPING;

augment class Any {
    method nsort is export(:standard) { self.list.sort( { .&naturally } ) };
    method p5nsort is export(:p5) { self.list.sort( { .&p5naturally } ) };
}

sub infix:<ncmp>($a, $b) is export(:standard) {$a.&naturally cmp $b.&naturally}

sub infix:<p5ncmp>($a, $b) is export(:p5) {$a.&p5naturally cmp $b.&p5naturally}

sub naturally ($a) is export(:standard) {
    $a.lc.subst(/(\d+)/, ->$/ { 0 ~ $0.chars.chr ~ $0 }, :g) ~ "\x0" ~ $a
}

sub p5naturally ($a) is export(:p5) {
    $a.lc.subst(/^(\d+)/, -> $/ { 0 ~ $0.chars.chr ~ $0 } )\
      # Less than awesome use of captures, but rakudo doesn't have <?after ...>
      # lookaround implemented yet. Really should be:
      # .subst(/<?after \D>(\d+)/, -> $/ { 'z{' ~ $0.chars.chr ~ $0 }, :g)
      .subst(/(\D)(\d+)/, -> $/ { $0 ~ 'z{' ~ $1.chars.chr ~ $1 }, :g)
      ~ "\x0" ~ $a
}
