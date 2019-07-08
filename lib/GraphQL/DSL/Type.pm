package GraphQL::DSL::Type;

use warnings;
use strict;

my %TYPES = ();
sub TYPE_INFO_FOR { $TYPES{$_[0]} || die "No type info for $_[0]" }

sub import {
  my $class = shift;
  my $target = caller;
 
  {
    no strict 'refs'; 

    *{"${target}::type"} = sub { $TYPES{$target}{type} = shift };
    *{"${target}::name"} = sub { $TYPES{$target}{name} = shift };
    *{"${target}::description"} = sub { $TYPES{$target}{description} = shift };
    *{"${target}::field"} = sub {
      my ($field_name, %opts) = @_;
      $opts{resolve} = \&{"${target}::${field_name}"} if $target->can($field_name);
      $TYPES{$target}{fields}{$field_name} = \%opts;
    };

    strict->import;
    warnings->import;

    @{"${target}::ISA"} = do { ($class) };
  }
}

sub get_type {
  my $class = shift;  
  my %info = %{ GraphQL::DSL::Type::TYPE_INFO_FOR($class) };
  my $type = "GraphQL::Type::$info{type}";
  my %fields = map {
    my $type_info = $info{fields}{$_};
    my $maybe_arg = sub {
      return $type_info->{$_[0]} ?
        ($_[0] => $type_info->{$_[0]}) :
        ();
    };
    
    $_ => +{
      $maybe_arg->('type'),
      $maybe_arg->('types'),
      $maybe_arg->('args'),
      $maybe_arg->('resolve'),
      $maybe_arg->('resolve_type'),
      $maybe_arg->('values'),
      $maybe_arg->('of'),
      $maybe_arg->('interfaces'),
      $maybe_arg->('serialize'),
      $maybe_arg->('parse_value'),
    };
  } keys %{$info{fields}};


  return $type->new(
    name => $info{name},
    description => $info{description},
    fields => \%fields,
  );
}

1;
