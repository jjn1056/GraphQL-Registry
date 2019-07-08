package MyApp::GraphQL::Types::User;

use GraphQL::DSL::Type;
use GraphQL::Type::Scalar qw($String $Int);

type 'Object';
name 'User';
description 'A user in the system';

field full_name => (
  type => $String->non_null, 
);

field age => (
  type => $Int->non_null, 
);

1;
