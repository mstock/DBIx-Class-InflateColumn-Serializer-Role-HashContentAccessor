package DBIx::Class::InflateColumn::Serializer::Hstore::Accessor::TestSchema;

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;

1;
