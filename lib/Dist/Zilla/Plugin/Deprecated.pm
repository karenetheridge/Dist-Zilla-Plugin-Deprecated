use strict;
use warnings;
package Dist::Zilla::Plugin::Deprecated;
# ABSTRACT: added metadata to your distribution marking it as deprecated
# KEYWORDS: ...
# vim: set ts=8 sw=4 tw=78 et :

use Moose;
with 'Dist::Zilla::Role::MetaProvider';

use namespace::autoclean;

# no configs yet to dump
#around dump_config => sub
#{
#    my ($orig, $self) = @_;
#    my $config = $self->$orig;
#
#    $config->{+__PACKAGE__} = {
#        ...
#    };
#
#    return $config;
#};

sub metadata
{
    my $self = shift;

    return { x_deprecated => 1 };
}

__PACKAGE__->meta->make_immutable;
__END__

=pod

=head1 SYNOPSIS

In your F<dist.ini>:

    [Deprecated]

=head1 DESCRIPTION

This is a L<Dist::Zilla> plugin that adds metadata to your distribution marking it as deprecated.

This use the unofficial C<x_deprecated> field,
which is a new convention for marking a CPAN distribution as deprecated.
You should still note that the distribution is deprecated in the documentation,
for example in the abstract and the first paragraph of the DESCRIPTION section.

=for Pod::Coverage metadata

=head1 SUPPORT

=for stopwords irc

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Dist-Zilla-Plugin-Deprecated>
(or L<bug-Dist-Zilla-Plugin-Deprecated@rt.cpan.org|mailto:bug-Dist-Zilla-Plugin-Deprecated@rt.cpan.org>).
I am also usually active on irc, as 'ether' at C<irc.perl.org>.

=head1 ACKNOWLEDGEMENTS

Neil Bowers requested this. :)

=cut
