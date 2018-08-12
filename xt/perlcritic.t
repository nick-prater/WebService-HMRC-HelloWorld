use strict;
use warnings;
use File::Spec;
use Test::More;
use Test::Perl::Critic; 
 
my $rcfile = File::Spec->catfile('xt', 'perlcriticrc');
Test::Perl::Critic->import( -profile => $rcfile );
all_critic_ok();
