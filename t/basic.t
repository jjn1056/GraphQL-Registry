use lib 't/lib';
use Test::Most;
use GraphQL::Execution qw(execute);
use MyApp::GraphQL::Registry;
use Devel::Dwarn;

ok my $schema = MyApp::GraphQL::Registry->to_schema;
warn $schema->to_doc;

ok my %root_value = (
  1 => {full_name=>'john', age=>24},
  2 => {full_name=>'frank', age=>32},
);

ok my $execute = sub {
  return my $results = execute($schema,shift,\%root_value, @_);
};

{
  ok my $results = $execute->(q[
    {
      user(id:"1") {
        age
        full_name
      }
    }
  ]);

  Dwarn $results;
}

{
  ok my $results = $execute->(q[
    mutation {
      add_user(full_name: "Bill", age: "44") { 
        full_name
      }
    }
  ]);

  Dwarn $results;
}

{
  ok my $results = $execute->(q[
    {
      users { full_name }
    }
  ]);

  Dwarn $results;
}

done_testing;

