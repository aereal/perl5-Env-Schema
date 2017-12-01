package Env::Schema::ValidatedResult;

use strict;
use warnings;

sub new {
  my ($class) = @_;
  my $self = bless {
    errors => [],
    value => {},
  }, $class;
  return $self;
}

sub errors {
  my ($self) = @_;
  return $self->{errors};
}

sub value {
  my ($self) = @_;
  return $self->{value};
}

sub add_error {
  my ($self, $error) = @_;
  push @{$self->errors}, $error;
  return;
}

sub add_value {
  my ($self, $name, $value) = @_;
  $self->value->{$name} = $value;
  return;
}

sub has_error {
  my ($self) = @_;
  return @{$self->errors} ? 1 : 0;
}

sub valid {
  my ($self) = @_;
  return ! $self->has_error;
}

1;
