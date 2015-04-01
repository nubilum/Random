#!./perl
use strict;
use warnings;

use Test::More tests => 7;
use Random qw(choice);


my @r;

@r = choice(1, 9);
is( 0+@r,	1,	'1 in 1 out');

my $num = 5;
my @in = 1..100;
@r = choice($num, @in);
is( 0+@r,	$num,	'arg count');

my $num2 = 101;
my @in2 = 1..100;
@r = choice($num2, @in2);
is( @r,	@in2, 'over');
@r = sort { $a <=> $b } @r;
is( "@r",	"@in2", 'values');

my @in3 = 1..100;
is( "@in2", "@in3", 'no change in base list' );

my @hash_list = (+{ a => 1 }, );
@r = choice(1, @hash_list);
$r[0]->{a} = 2;
is( $r[0]->{a}, 2, 'changed hash value == 2' );
is( $r[0]->{a}, $hash_list[0]->{a}, 'effect base hash' );
