package MyApp::GraphQL::Types::AddUser;

use GraphQL::DSL::Type;
use MyApp::GraphQL::Registry qw(User);
use GraphQL::Type::Scalar qw($String $Int);

type 'Object';
name 'AddUser';
description 'Add a user';

field add_user => (
  type => User,
  args => {
    full_name => { type => $String->non_null },
    age => { type => $Int->non_null },
  },
);

sub add_user {
  my ($root_value, $args, $context, $info) = @_;
  warn "asfasdsdasd" x 100;
  my $total = scalar keys %$root_value;
  return $root_value->{++$total} = $args;
}


1;
