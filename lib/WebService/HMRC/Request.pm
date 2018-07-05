package WebService::HMRC::Request;

use 5.006;
use strict;
use warnings;
use Carp;
use LWP::UserAgent;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use WebService::HMRC::Response;


=head1 NAME

WebService::HMRC::Request - Base class for using the UK HMRC HelloWorld API

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 DESCRIPTION

This is a base class for making requests to the UK's HMRC Making Tax Digital
API. It is usually inherited by other higher-level classes.

=head1 SYNOPSIS

    use WebService::HMRC::Request;
    my $hmrc = WebService::HMRC::Request->new();

    
=head1 PROPERTIES

=head2 base_url

Base url used for calls to the HMRC "Making Tax Digital" API.

See:
L<https://developer.service.hmrc.gov.uk/api-documentation/docs/reference-guide>

=cut

has base_url => (
    is => 'rw',
    isa => 'Str',
    default => 'https://test-api.service.hmrc.gov.uk/',
);

=head2 api_version

Read-only property which defines the API version in use by this module as a string.
For example `1.0`.

See:
L<https://developer.service.hmrc.gov.uk/api-documentation/docs/reference-guide#versioning>

=cut

has api_version => (
    is => 'ro',
    isa => 'Str',
    default => '1.0',
);

=head2 ua

Read-only property representing a LWP::UserAgent object used to perform the api calls.

=cut

has ua => (
    is => 'ro',
    isa => 'LWP::UserAgent',
    lazy => 1,
    builder => '_build_ua',
);



=head1 METHODS

=head2 endpoint_url($endpoint)

Combine the given api endpoint (for example `/hello/world`) with
the api's base_url, returning a complete endpoint url.

The supplied endpoint must be absolute - in other words it must
begin with `/`.

=cut

sub endpoint_url {

    my $self = shift;
    my $endpoint = shift;

    # endpoint paramater is mandatory
    defined $endpoint or croak "endpoint is undefined";

    # endpoint must be absolute
    $endpoint =~ m|^/| or croak "endpoint is not absolute";

    # Strip any trailing slash from base_url
    my $rv = $self->base_url;
    $rv =~ s|/$||;

    # Concatenate endpoint
    $rv .= $endpoint;

    return $rv;
}


# PRIVATE METHODS

# _build_ua()
# Returns a LWP::UserAgent object with a default `Accept` header
# defined. Called as a Moose lazy builder.

sub _build_ua {
    my $self = shift;
    my $ua = LWP::UserAgent->new();
    $ua->default_header(
        'Accept' => 'application/vnd.hmrc.' . $self->api_version . '+json'
    );
    return $ua;
}


=head1 AUTHOR

Nick Prater, C<< <nick@npbroadcast.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-webservice-hmrc-helloworld at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-HMRC-HelloWorld>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WebService::HMRC::HelloWorld


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-HMRC-HelloWorld>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-HMRC-HelloWorld>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-HMRC-HelloWorld>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-HMRC-HelloWorld/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2018 Nick Prater.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

__PACKAGE__->meta->make_immutable;
1; # End of WebService::HMRC::HelloWorld
