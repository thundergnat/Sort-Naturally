use v6;
use Test;
use Sort::Naturally;

plan 22;

my @test;
my $nsorted = '';

# does it deal with Nil in a sane fashion?
is(~Nil.sort( { .&naturally } ), $nsorted,
  "calling &naturally in a sort block on Nil is ok");
is(~Nil.nsort, $nsorted,
  "calling nsort as method on Nil is ok");
is(~nsort(Nil), $nsorted,
  "calling nsort as subroutine on Nil is ok");
is(~Nil.sort( { $^a ncmp $^b } ), $nsorted,
  "calling ncmp in a sort block on Nil is ok");


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
  "calling &naturally in a sort block yields expected order");
is(~@test.pick(+@test).nsort, $nsorted,
  "calling nsort as method yields expected order");
is(~nsort(@test.pick(+@test)), $nsorted,
  "calling nsort as subroutine yields expected order");
is(~nsort(<2 210 21 30 3rd d1 d10 D2 D21 d3 aid Are
  any ANY 1 Any 11 100 14th>), $nsorted,
  "calling nsort as subroutine on a list gives expected order");
is(~@test.pick(+@test).sort( { $^a ncmp $^b } ), $nsorted,
  "calling ncmp in a sort block yields expected order");
is(~(@test[10..18],@test[0..9]).nsort, $nsorted,
  "nsort as method flattens its arguments and sorts as expected");
is(~nsort(@test[10..18],@test[0..9]), $nsorted,
  "nsort as subroutine flattens its arguments and sorts as expected");

# do the compatibility routines return terms in the expected order?
my @p5test = <foo12z foo foo13a fooa Foolio Foo12a foolio foo12 foo12a 9x 14>;
my $p5nsorted = '9x 14 foo fooa Foolio foolio foo12 Foo12a foo12a foo12z foo13a';

# randomize list for each test
# could conceivably fail under some locales
is(~@p5test.pick(+@p5test).sort( { .&p5naturally } ),
  $p5nsorted, "calling &p5naturally in a sort block yields expected order");
is(~@p5test.pick(+@p5test).p5nsort, $p5nsorted,
  "calling p5nsort as method yields expected order");
is(~p5nsort(@p5test.pick(+@p5test)), $p5nsorted,
  "calling p5nsort as subroutine yields expected order");
is(~p5nsort(<foo12z foo foo13a fooa Foolio Foo12a
  foolio foo12 foo12a 9x 14>), $p5nsorted,
  "calling p5nsort as subroutine gives same order as method");
is(~@p5test.pick(+@p5test).sort( { $^a p5ncmp $^b } ),
  $p5nsorted, "calling p5ncmp in a sort block yields expected order");
is(~(@p5test[6..10],@p5test[0..5]).p5nsort, $p5nsorted,
  "p5nsort as method flattens its arguments and sorts as expected");
is(~p5nsort(@p5test[6..10],@p5test[0..5]), $p5nsorted,
  "p5nsort as subroutine flattens its arguments and sorts as expected");

