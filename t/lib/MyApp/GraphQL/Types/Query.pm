package MyApp::GraphQL::Types::Query;

use GraphQL::DSL::Type;
use MyApp::GraphQL::Registry qw(User);
use GraphQL::Type::Scalar qw($ID);

type 'Object';
name 'Query';
description 'Root Query';

field user => (
  type => User,
  args => { id => { type => $ID->non_null } },
  resolve => sub {
    my ($root_value, $args, $context, $info) = @_;
    return $root_value->{ $args->{id} } || 
      die GraphQL::Error->new(message => 'There is no matching id')
  },
);

field users => (
  type => User->list,
  resolve => sub {
    my ($root_value, $args, $context, $info) = @_;
    return [ map { $root_value->{$_} } keys %$root_value ];
  },
);

1;

