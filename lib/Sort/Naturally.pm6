use v6;
use MONKEY_TYPING;
my $VERSION = 0.01

augment class Any {
    our multi method nsort is export { self.list.sort( {
      .lc.subst( /(\d+)/, -> $/ { 0 ~ $0.chars.chr ~ $0 }, :g ) } )
    };

    our multi method p5nsort is export { self.list.sort( {
      .lc.subst( /^(\d+)/, -> $/ { 0 ~ $0.chars.chr ~ $0 
      } ).subst( /(\D)(\d+)/, -> $/ { $0 ~ 'z{' ~ $1.chars.chr ~ $1 }, :g) } )
    };
}

our sub infix:<ncmp>($a, $b) { 
    [leg] ($a, $b)>>.lc>>.subst(/(\d+)/, -> $/ { 0 ~ $0.chars.chr ~ $0 }, :g)
};

our sub infix:<p5ncmp>($a, $b) { 
    [leg] ($a, $b)>>.lc>>.subst( /^(\d+)/, -> $/ { 0 ~ $0.chars.chr ~ $0
	} )>>.subst( /(\D)(\d+)/, -> $/ { $0 ~ 'z{' ~ $1.chars.chr ~ $1 }, :g)
};


