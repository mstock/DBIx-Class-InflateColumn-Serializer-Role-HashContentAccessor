requires "Carp" => "0";
requires "MooseX::Role::Parameterized" => "0";

on 'build' => sub {
  requires "Module::Build" => "0.3601";
};

on 'test' => sub {
  requires "DBICx::TestDatabase" => "0";
  requires "DBIx::Class::Core" => "0";
  requires "DBIx::Class::InflateColumn::Serializer" => "0";
  requires "DBIx::Class::InflateColumn::Serializer::Hstore" => "0";
  requires "DBIx::Class::InflateColumn::Serializer::JSON" => "0";
  requires "DBIx::Class::Schema" => "0";
  requires "File::Find" => "0";
  requires "File::Temp" => "0";
  requires "JSON::MaybeXS" => "0";
  requires "Moose" => "0";
  requires "MooseX::MarkAsMethods" => "0";
  requires "MooseX::NonMoose" => "0";
  requires "Pg::hstore" => "0";
  requires "Test::Class" => "0";
  requires "Test::Exception" => "0";
  requires "Test::More" => "0.88";
  requires "parent" => "0";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'configure' => sub {
  requires "Module::Build" => "0.3601";
};

on 'develop' => sub {
  requires "Test::CPAN::Changes" => "0.19";
  requires "version" => "0.9901";
};
