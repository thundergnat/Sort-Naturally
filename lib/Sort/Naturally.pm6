module Sort::Naturally:ver<0.1.2>;
use v6;
use MONKEY_TYPING;

augment class Any {
    method nsort   (*@) { self.list.flat.sort( { .&naturally   } ) };
    method p5nsort (*@) { self.list.flat.sort( { .&p5naturally } ) };
}

# Export the subroutines manually. Shouldn't be necessary but
# module load order can affect class method exporting and make them unfindable.

sub nsort(*@a) is export( :ALL, :DEFAULT ) { @a.list.flat.sort( { .&naturally } ) }
sub p5nsort(*@a) is export( :ALL, :p5 ) { @a.list.flat.sort( { .&p5naturally } ) }

# Sort modifier block routines

sub infix:<ncmp>($a, $b) is export( :ALL, :DEFAULT ) { $a.&naturally cmp $b.&naturally }
sub infix:<p5ncmp>($a, $b) is export( :ALL, :p5 ) { $a.&p5naturally cmp $b.&p5naturally }

# Core routines to actually do the transformation for sorting

sub naturally ($a) is export( :ALL, :DEFAULT ) {
    $a.lc.subst(/(\d+)/, ->$/ { "0{$0.gist.chars.chr}$0" }, :g) ~ "\x0$a"
}

sub p5naturally ($a) is export( :ALL, :p5 ) {
    $a.lc.subst(/^(\d+)/, -> $/ { "0{$0.gist.chars.chr}$0" } )\
       .subst(/<?after \D>(\d+)/, -> $/ { 'z{' ~"{$0.gist.chars.chr}$0" }, :g) ~ "\x0$a"
}
