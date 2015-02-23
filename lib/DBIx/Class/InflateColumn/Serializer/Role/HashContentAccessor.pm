package DBIx::Class::InflateColumn::Serializer::Role::HashContentAccessor;

# ABSTRACT: Parameterized Moose role which provides accessor methods for values stored in a hash like structure

use MooseX::Role::Parameterized;

=head1 SYNOPSIS

In your result (table) classes:

	__PACKAGE__->load_components("InflateColumn::Serializer");

	__PACKAGE__->add_columns(
		...,
		properties => {
			data_type        => "hstore",
			is_nullable      => 1,
			serializer_class => "Hstore"
		},
		...,
	);

	with 'DBIx::Class::InflateColumn::Serializer::Role::HashContentAccessor' => {
		column => 'properties',
		name   => 'property',
	};

Then in your application code:

	$object->set_property(foo => 10, bar => 20);
	$object->update();

	$object->get_property('foo');
	$object->get_property('bar');

	$object->delete_property('foo');
	$object->delete_property('bar');
	$object->update();

=head1 DESCRIPTION

This parameterized role provides methods to access values of a column that stores
'hash-like' data in a L<DBIx::Class|DBIx::Class> based database schema that uses
L<Moose|Moose>. It assumes that the (de)serializing of the column in done using
something like L<DBIx::Class::InflateColumn::Serializer|DBIx::Class::InflateColumn::Serializer>,
i.e. that the inflated values are hash references that get serialized to something
the database can store on C<INSERT>/C<UPDATE>.

This module provides the following advantages over using the inflated hashref
directly:

=over

=item *

If the column is C<nullable>, you don't have to take care of C<NULL> values
yourself - the methods provided by this role do that already.

=item *

It's easy to provide a default when getting a value which is not necessarily
already stored in the column data.

=item *

If you remove the key-value-based column and replace it with dedicated columns
in the future, you can simply remove the role and provide compatible accessors
yourself which allows you to keep the interface of the result class.

=back

=head1 PARAMETERS

=over

=item column

Column which should be updated.

=item name

Suffix of the accessors that should be generated.

=back

=head1 METHODS

=cut

=head2 set_$name

Set given properties. Takes a hash of key/value pairs to set.

=head2 get_$name

Get the given property. Also takes an optional default value which is returned
if the property is undefined.

=head2 delete_$name

Delete the properties of the given names.

=cut

parameter column => (
	isa      => 'Str',
	required => 1,
);

parameter name => (
	isa      => 'Str',
	required => 1,
);

role {
	my $p = shift;

	my $column     = $p->column();
	my $name       = $p->name();
	my $properties = sub {
		my ($self) = @_;
		my $data = $self->$column();
		return defined $data ? $data : {};
	};

	method 'set_'.$name => sub {
		my ($self, %arg) = @_;

		$self->$column(+{
			%{$self->$properties()},
			%arg,
		});
		return;
	};

	method 'get_'.$name => sub {
		my ($self, $key, $default) = @_;

		unless (defined $key && $key ne '') {
			croak("Required 'key' parameter not passed");
		}

		my $value = $self->$properties()->{$key};
		return defined $value ? $value : $default;
	};

	method 'delete_'.$name => sub {
		my ($self, @keys) = @_;

		unless (scalar @keys > 0) {
			return;
		}

		my $data = $self->$properties();
		for my $key (@keys) {
			delete $data->{$key};
		}
		$self->$column(
			$data,
		);
		return;
	};
};


1;

=head1 SEE ALSO

=over

=item *

L<DBIx::Class::InflateColumn|DBIx::Class::InflateColumn> - Underlying mechanism
for deflating/inflating complex data.

=item *

L<DBIx::Class::InflateColumn::Serializer|DBIx::Class::InflateColumn::Serializer>
- Inflators for data structures, uses eg. JSON to store the data in the database.

=item *

L<DBIx::Class::InflateColumn::Serializer::Hstore|DBIx::Class::InflateColumn::Serializer::Hstore>
- Serializer which uses the HStore type for storage in the database.

=item *

L<http://www.postgresql.org/docs/current/static/hstore.html> - C<hstore> type in
PostgreSQL.

=back

=cut

