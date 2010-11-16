use v6;
use Sort::Naturally;
use Test;


plan 12;

my @test;
my $nsorted = '';

# does it deal with empty array in a sane fashion?
is(~@test.sort( { .&naturally } ), $nsorted,
  "calling &naturally in a sort block on an empty array is ok");
is(~@test.nsort, $nsorted,
  "calling nsort as method on an empty array is ok");
is(~nsort(@test), $nsorted,
  "calling nsort as subroutine on an empty array is ok");
is(~@test.sort( { $^a ncmp $^b } ), $nsorted,
  "calling ncmp in a sort block on an empty array is ok");


# does it return the terms in the expected order?
@test = <2 210 21 30 3rd d1 d10 D2 D21 d3 aid Are any ANY 1 Any 11 100 14th>;
$nsorted = '1 2 3rd 11 14th 21 30 100 210 aid ANY Any any Are d1 D2 d3 d10 D21';

# randomize list for each test
# could conceivably fail under some locales
is(~@test.pick(+@test).sort( { .&naturally } ), $nsorted,
  "calling &naturally in a sort block yeilds expected order");
is(~@test.pick(+@test).nsort, $nsorted,
  "calling nsort as method yeilds expected order");
is(~nsort(@test.pick(+@test)), $nsorted,
  "calling nsort as subroutine yeilds expected order");
is(~@test.pick(+@test).sort( { $^a ncmp $^b } ), $nsorted,
  "calling ncmp in a sort block yeilds expected order");


# do the compatibility routines return terms in the expected order?
my @p5test = <foo12z foo foo13a fooa Foolio Foo12a foolio foo12 foo12a 9x 14>;
my $p5sorted = '9x 14 foo fooa Foolio foolio foo12 Foo12a foo12a foo12z foo13a';

# randomize list for each test
# could conceivably fail under some locales
is(~@p5test.pick(+@p5test).sort( { .&p5naturally } ),
  $p5sorted, "calling &p5naturally in a sort block yeilds expected order");
is(~@p5test.pick(+@p5test).p5nsort, $p5sorted,
  "calling p5nsort as method yeilds expected order");
is(~p5nsort(@p5test.pick(+@p5test)), $p5sorted,
  "calling p5nsort as subroutine yeilds expected order");
is(~@p5test.pick(+@p5test).sort( { $^a p5ncmp $^b } ),
  $p5sorted, "calling p5ncmp in a sort block yeilds expected order");


