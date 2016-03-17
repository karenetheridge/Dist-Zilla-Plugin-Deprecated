use strict;
use warnings;
package Dist::Zilla::Plugin::Deprecated;
# ABSTRACT: add metadata to your distribution marking it as deprecated
# KEYWORDS: plugin metadata module distribution deprecated
# vim: set ts=8 sts=4 sw=4 tw=115 et :

our $VERSION = '0.005';

use Moose;
with 'Dist::Zilla::Role::MetaProvider';
use namespace::autoclean;

has all => (
    is => 'ro', isa => 'Bool',
    init_arg => 'all',
    lazy => 1,
    default => sub {
        my $self = shift;
        $self->modules ? 0 : 1;
    },
);

has modules => (
    isa => 'ArrayRef[Str]',
    traits => [ 'Array' ],
    handles => { modules => 'elements' },
    lazy => 1,
    default => sub { [] },
);

sub mvp_aliases { { module => 'modules' } }
sub mvp_multivalue_args { qw(modules) }

around dump_config => sub
{
    my ($orig, $self) = @_;
    my $config = $self->$orig;

    $config->{+__PACKAGE__} = {
        all => ( $self->all ? 1 : 0),
        modules => [ sort $self->modules ],
        blessed($self) ne __PACKAGE__ ? ( version => $VERSION ) : (),
    };

    return $config;
};

sub metadata
{
    my $self = shift;

    return { x_deprecated => 1 } if $self->all;

    # older Dist::Zilla uses Hash::Merge::Simple, which performs the same sort
    # of merge we need as in new CPAN::Meta::Merge
    $self->log_fatal('CPAN::Meta::Merge 2.150002 required to deprecate an individual module!')
        if eval { Dist::Zilla->VERSION('5.022') }
            and not eval 'require CPAN::Meta::Merge; CPAN::Meta::Merge->VERSION("2.150002"); 1';

    return { provides => { map { $_ => { x_deprecated => 1 } } $self->modules } };
}

__PACKAGE__->meta->make_immutable;
__END__

=pod

=head1 SYNOPSIS

In your F<dist.ini>:

    [Deprecated]

or

    [Deprecated]
    module = MyApp::OlderAPI

=head1 DESCRIPTION

This is a L<Dist::Zilla> plugin that adds metadata to your distribution marking it as deprecated.

This uses the unofficial C<x_deprecated> field,
which is a new convention for marking a CPAN distribution as deprecated.
You should still note that the distribution is deprecated in the documentation,
for example in the abstract and the first paragraph of the DESCRIPTION section.

You can also mark a single module (or subset of modules) as deprecated by
listing them with the C<module> option.  This will add an C<x_deprecated>
field to the C<provides> section of metadata.  Note that L<CPAN::Meta::Spec>
requires you need to populate the rest of C<provides> metadata through some
other means, such as L<Dist::Zilla::Plugin::MetaProvides::Package>.

=head1 CONFIGURATION OPTIONS

=head2 C<module>

    [Deprecated]
    module = MyApp::OlderAPI

Identify a specific module to be deprecated. Can be used more than once.

=head2 C<all>

    [Deprecated]
    all = 1

Not normally needed directly. Mark an entire distribution as deprecated. This
defaults to true when there are no C<module>s listed, and false otherwise.

=for Pod::Coverage metadata mvp_aliases mvp_multivalue_args

=head1 ACKNOWLEDGEMENTS

Neil Bowers requested this. :)  And then he
L<blogged about it|http://neilb.org/2015/01/17/deprecated-metadata.html>.

=cut
