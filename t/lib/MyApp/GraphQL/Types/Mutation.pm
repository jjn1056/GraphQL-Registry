package MyApp::GraphQL::Types::Mutation;

use GraphQL::DSL::Type;
use MyApp::GraphQL::Registry qw(User AddUser);
use GraphQL::Type::Scalar qw($String $Int);

type 'Object';
name 'Mutation';
description 'Root Mutation';

field add_user => (
  type => AddUser,
);

1;
