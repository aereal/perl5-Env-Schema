package Env::Schema;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Env::Schema::ValidatedResult;

sub new {
  my ($class) = @_;
  my $self = bless {
    constraints => [],
  }, $class;
  return $self;
}

sub requires {
  my ($self, $name) = @_;
  push @{$self->{constraints}}, $self->_compile_constraint(name => $name);
  return;
}

sub validates {
  my ($self, $target) = @_;
  $target = \%ENV unless defined $target;
  my $result = Env::Schema::ValidatedResult->new;
  for my $constraint (@{$self->{constraints}}) {
    my $value = $target->{$constraint->{name}};
    my $validator = $constraint->{validator};
    my $error = $validator->($value); # TODO: normalize
    if ($error) {
      $result->add_error($error);
    } else {
      $result->add_value($constraint->{name}, $value);
    }
  }
  return $result;
}

sub _compile_constraint {
  my ($self, %args) = @_;
  my $name = $args{name};
  my $validator = sub {}; # TODO
  return +{
    name => $name,
    validator => $validator,
  };
}

1;
__END__

=encoding utf-8

=head1 NAME

Env::Schema - It's new $module

=head1 SYNOPSIS

    use Env::Schema;

=head1 DESCRIPTION

Env::Schema is ...

=head1 LICENSE

Copyright (C) aereal.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

aereal E<lt>aereal@aereal.orgE<gt>

=cut

