use v6;
unit module Sort::Naturally:ver<0.2.3>:auth<zef:thundergnat>;

# Routines to do the transformation for sorting

sub naturally ($a) is export {
    $a.lc.subst(/(\d+)/, ->$/ { "0{$0.chars.chr}$0" }, :g) ~ "\x0$a"
}

sub p5naturally ($a) is export {
    $a.lc.subst(/^(\d+)/, -> $/ { "0{$0.gist.chars.chr}$0" } )\
       .subst(/<?after \D>(\d+)/, -> $/ { 'z{' ~"{$0.chars.chr}$0" }, :g) ~ "\x0$a"
}



=begin pod

=head1 NAME
Sort::Naturally

Provides a transform routine to modify sorting into a "natural" order.

=head1 SYNOPSIS

=begin code :lang<raku>

use Sort::Naturally;

# sort strings containing a mix of letters and digits sensibly
my @a =   <1 11 100 14th 2 210 21 30 3rd d1 Any any d10 D2 D21 d3 aid Are ANY >;

say @a.sort: { .&naturally };

=end code

yields:

    1 2 3rd 11 14th 21 30 100 141 210 aid ANY Any any Are d1 D2 d3 d10 D21

compared to C<@a.sort>:

    1 100 11 141 14th 2 21 210 30 3rd ANY Any Are D2 D21 aid any d1 d10 d3


=head1 DESCRIPTION

This implementation of a natural sort order transform will yield results
similar, though not identical to the Perl 5 Sort::Naturally. When sorting
strings that contain groups of digits, it will sort the groups of consecutive
digits by "order of magnitude", then lexically by lower-cased terms. Order of
magnitude is something of a simplification. The transformation routine
&naturally doesn't try to interpret or evaluate a group of digits as a number,
it just counts how many digits are in each group and uses that as its order of
magnitude.

The implications are:

=item It doesn't understand the (non)significance of leading zeros in numbers;
    0010, 0100 and 1000 are all treated as being of the same order of magnitude
    and will all be sorted to be after 20 and 200. This is the correct behavior
    for strings of digits where leading zeros are significant, like zip codes or
    phone numbers.

=item It doesn't understand floating point numbers; the groups of digits before
    and after a decimal point are treated as two separate numbers for sorting
    purposes.

=item It doesn't understand or deal with scientific or exponential notation.

However, that also means:

=item You are not limited by number magnitude. It will sort arbitrarily large
    numbers with ease regardless of the math capability of your hardware/OS.

=item It is quite speedy. (For liberal values of speedy.) Since it doesn't need to
    interpret numbers by value it eliminates a lot of code that would do that.

It could have been modified to ignore leading zeros, and in fact I experimented
with that bit, but ran into issues with strings where leading zeros WERE
significant. Just remember, it is for sorting strings, not numbers. It makes
some attempt at treating groups of digits in a kind of numbery way, but they are
still strings. If you truly want to sort numbers, use a numeric sort.


=head1 USAGE

Sort::Naturally provides a transformation routine: C<&naturally>, which you can use
as a sorting block modifier. It performs a transform of the terms so they will
end up in the natural order.

=head3 BACKWARD COMPATIBILITY BREAKING CHANGES

Previous versions provided some pre-made augmented methods and infix comparators
that are no longer provided. Partially because they were causing compilation
failures due to incomplete and not yet implemented compiler features, and
partially because I decided it was a bad idea to unnecessarily pollute the
name-space. If you would like to have the syntactic sugar, it can be added
easily.


To create the method C<.nsort> that can be used similar to C<.sort>:

=begin code :lang<raku>

use Sort::Naturally;

use MONKEY-TYPING;
augment class Any {
    method nsort (*@) { self.list.flat.sort( { .&naturally } ) };
}

=end code

_(Note: since this was originally written, augmenting rules have changed in Raku.
Now, if you augment a parent class (Any), you must then re-compose any subtypes
that you want to see the augmentation.)_

For a natural sorting infix comparator:

C<sub infix:<ncmp>($a, $b) { $a.&naturally cmp $b.&naturally }>


=head3 PERL 5 BACKWARD COMPATIBILITY

Perl 5 Sort::Naturally has an odd convention in that numbers at the beginning of
strings are sorted in ASCII order (digits sort before letters) but numbers
embedded inside strings are sorted in non-ASCII order (digits sort after
letters). While this is just plain strange in my opinion, some people may rely
on or prefer this behavior so Raku C<Sort::Naturally> has a "p5 compatibility
mode" routine. C<p5naturally()>.


for comparison:

=begin code :lang<raku>

('       sort:',<foo12z foo foo13a fooa Foolio Foo12a foolio foo12 foo12a 9x 14>\
   .sort).join(' ').say;
('  naturally:',<foo12z foo foo13a fooa Foolio Foo12a foolio foo12 foo12a 9x 14>\
   .sort({ .&naturally })).join(' ').say;
('p5naturally:',<foo12z foo foo13a fooa Foolio Foo12a foolio foo12 foo12a 9x 14>\
   .sort({ .&p5naturally })).join(' ').say;

=end code

yields:

=begin code :lang<raku>

       sort: 14 9x Foo12a Foolio foo foo12 foo12a foo12z foo13a fooa foolio
  naturally: 9x 14 foo foo12 Foo12a foo12a foo12z foo13a fooa Foolio foolio
p5naturally: 9x 14 foo fooa Foolio foolio foo12 Foo12a foo12a foo12z foo13a

=end code

=head1 BUGS

Tests and the p5 routine will fail under locales that specify lower case letters
to sort before upper case. (EBCDIC locales notably). They will still sort
I<consistently>, just not in the order advertised. I can probably implement some
kind of run time check to modify the behavior based on current locale. I'll look
into it more seriously later if necessary. Right now, there are no Raku
compilers for any EBCDIC OSs so it is not really an issue yet.


=head1 AUTHOR

Stephen Schulze (also known as thundergnat)

=head1 LICENSE

Licensed under The Artistic 2.0; see LICENSE.

=end pod
