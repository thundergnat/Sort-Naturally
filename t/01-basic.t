use v6;
use Sort::Naturally;
use Test;

plan *;

my @test;
my @nsorted;

is(~@test.nsort, ~@nsorted, "calling nsort as method on an empty array is ok");
is(~nsort(@test), ~@nsorted, "calling nsort as subroutine on an empty array is ok");
is(~@test.sort( { $^a ncmp $^b } ), ~@nsorted, "calling ncmp in a sort block on an empty array is ok");

@test = <2 210 21 30 3rd d1 d10 D2 D21 d3 aid Are ANY 1 11 100 14th>;
@nsorted = <1 2 3rd 11 14th 21 30 100 210 aid ANY Are d1 D2 d3 d10 D21>;

is(~@test.sort.nsort, ~@nsorted, "calling nsort as method yeilds correct order");
is(~nsort(@test.sort), ~@nsorted, "calling nsort as subroutine yeilds correct order");
is(~@test.sort.sort( { $^a ncmp $^b } ), ~@nsorted, "calling ncmp in a sort block yeilds correct order");

my @p5test = <foo12z foo foo13a fooa Foolio Foo12a foolio foo12 foo12a 9x 14>;
my @p5sorted = <9x 14 foo fooa Foolio foolio foo12 Foo12a foo12a foo12z foo13a>;

is(~@p5test.sort.p5nsort, ~@p5sorted, "calling p5nsort as method yeilds correct order");
is(~p5nsort(@p5test.sort), ~@p5sorted, "calling p5nsort as subroutine yeilds correct order");
is(~@p5test.sort.sort( { $^a p5ncmp $^b } ), ~@p5sorted, "calling p5ncmp in a sort block yeilds correct order");


