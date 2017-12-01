package t::Env::Schema;

use strict;
use warnings;

use Test::Deep qw(cmp_deeply isa);
use Test::More;

require_ok 'Env::Schema';

subtest 'common' => sub {
  my $schema = Env::Schema->new;
  cmp_deeply $schema, isa('Env::Schema');
  $schema->requires('OAUTH_ID');
  $schema->requires('OAUTH_SECRET');

  my $input = +{
    %ENV,
    'OAUTH_ID' => 'xxx',
    'OAUTH_SECRET' => 'yyy',
  };
  local %ENV = %$input;
  my $result = $schema->validates;
  ok $result->valid;
  cmp_deeply $result->value, +{
    'OAUTH_ID' => 'xxx',
    'OAUTH_SECRET' => 'yyy',
  };
};

subtest 'optional' => sub {
  my $schema = Env::Schema->new;
  cmp_deeply $schema, isa('Env::Schema');
  $schema->optional('X_USER_NAME');

  subtest 'pass optional field' => sub {
    my $input = +{
      %ENV,
      'X_USER_NAME' => 'xxx',
    };
    local %ENV = %$input;
    my $result = $schema->validates;
    ok $result->valid;
    cmp_deeply $result->value, +{
      'X_USER_NAME' => 'xxx',
    };
  };

  subtest 'do NOT pass optional field' => sub {
    my $input = +{
      %ENV,
    };
    local %ENV = %$input;
    my $result = $schema->validates;
    ok $result->valid;
    cmp_deeply $result->value, +{};
  };
};

done_testing;

1;
