#!/usr/bin/perl
use strict;
use warnings;

package Coordinate;

# constructor
sub new {
  my $class = shift;
  my $self = bless {}, $class;
  $self->initialize(@_);
  return $self;
}

# initializer
sub initialize {
    my $self = shift;
    $self->{name} = shift;
    $self->{start} = shift;
    $self->{end} = shift;
    $self->{strand} = shift // undef;
    $self->{coord_system} = shift // undef;
    $self->{assembly} = shift // undef;
}

# getters
sub get_name {
  my $self = shift;
  return $self->{name};
}

sub get_start {
  my $self = shift;
  return $self->{start};
}

sub get_end {
  my $self = shift;
  return $self->{end};
}

# setters
sub set_name {
  my $self = shift;
  my $name = shift;
  $self->{name} = $name if defined($name);
}

sub set_start {
  my $self  = shift;
  my $start = shift;
  $self->{start} = $start if defined($start);
}

sub set_end {
  my $self = shift;
  my $end  = shift;
  $self->{end} = $end if defined($end);
}

sub TO_JSON {
  return { %{ shift() } };
}

1;
