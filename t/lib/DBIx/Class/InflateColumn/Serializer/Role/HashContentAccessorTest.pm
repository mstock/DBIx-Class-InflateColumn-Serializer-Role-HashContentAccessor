package DBIx::Class::InflateColumn::Serializer::Role::HashContentAccessorTest;
use parent qw(Test::Class);

use strict;
use warnings;

use Carp;
use Test::More;
use Test::Exception;

use DBICx::TestDatabase;
use DBIx::Class::InflateColumn::Serializer::Role::HashContentAccessor;

sub setup : Test(setup) {
	my ($self) = @_;

	$self->{schema} = DBICx::TestDatabase->new('DBIx::Class::InflateColumn::Serializer::Role::HashContentAccessor::TestSchema');
}

sub get_set_delete_test : Test(20) {
	my ($self) = @_;

	for my $table (qw(HStoreTable JSONTable)) {
		my $entry = $self->{schema}->resultset($table)->create({});

		my %property = (
			foo  => 'bar',
			test => 123
		);

		# Set properties
		$entry->set_property1(%property);
		$entry->update();
		$entry->discard_changes();
		is_deeply($entry->properties1(), \%property, 'properties set');

		# Get property
		is($entry->get_property1('foo'), 'bar', 'property retrieved');
		is($entry->get_property1('foobar', 'default'), 'default', 'property retrieved');
		is($entry->get_property1('foo', 'default'), 'bar', 'property retrieved');

		# Add property
		$entry->set_property1(a => 'b');
		$entry->update();
		$entry->discard_changes();
		is_deeply($entry->properties1(), { %property, a => 'b' }, 'property added');

		# Delete property
		$entry->delete_property1('foo');
		$entry->update();
		$entry->discard_changes();
		is_deeply($entry->properties1(), { test => 123, a => 'b' }, 'property added');

		# Use second accessor
		is($entry->get_property2('foo'), undef, 'no value set');
		$entry->set_property2(foo => 'my value');
		$entry->update();
		$entry->discard_changes();
		is($entry->get_property2('foo'), 'my value', 'value set');
		is_deeply($entry->properties2(), {foo => 'my value'}, 'hash content ok');
		$entry->update();
		$entry->discard_changes();
		$entry->delete_property2('foo');
		$entry->update();
		$entry->discard_changes();
		is_deeply($entry->properties2(), {}, 'hash content ok');
	}
}

1;
