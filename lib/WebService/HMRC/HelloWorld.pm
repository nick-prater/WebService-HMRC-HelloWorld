package WebService::HMRC::HelloWorld;

use 5.006;
use warnings;
use strict;
use Carp;
use LWP::UserAgent;
use Moose;
use namespace::autoclean;
use Try::Tiny;
use WebService::HMRC::Response;

extends 'WebService::HMRC::Request';


=head1 NAME

WebService::HMRC::HelloWorld - Access the UK HMRC HelloWorld API

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 DESCRIPTION

Perl module to interact with the UK's HMRC Making Tax Digital
`Hello World` API. This is often used as a basic test of configuration
and credentials before using their more involved APIs for managing
corporate and personal tax affairs.

For more information, see:
L<https://developer.service.hmrc.gov.uk/api-documentation/docs/api/service/api-example-microservice/1.0>

=head1 SYNOPSIS

    use WebService::HMRC::HelloWorld;
    my $hmrc = WebService::HMRC::HelloWorld->new();

    # Hello World endpoint requires no authorisation
    my $result = $hmrc->hello_world()
    print "$result->{response}->{message}\n";

    # Hello Application endpoint requires a server token
    $hmrc->server_token( $my_server_token );
    $result = $hmrc->hello_application();
    print "$result->{response}->{message}\n";
    
=head1 PROPERTIES

Inherits from L<WebService::HMRC::Request>.

=head1 METHODS

Inherits from L<WebService::HMRC::Request>.

=head2 hello_world()

Retrieve a "Hello World" message. Does not require authorisation.

Returns a WebService::HMRC::Response object.

=cut

sub hello_world {

    my $self = shift;
    my $url = $self->endpoint_url('/hello/world');
    my $result = $self->ua->get($url);

    return WebService::HMRC::Response->new(http => $result);
}


=head2 hello_application()

Retrieve a "Hello Application" message. This is an application-restricted
endpoint which requires that this module's server_token property be set.

Returns a WebService::HMRC::Response object.

=cut

sub hello_application {

    my $self = shift;
    $self->_require_server_token;

    my $url = $self->endpoint_url('/hello/application');

    my $result = $self->ua->get(
        $url,
        'Authorization' => 'Bearer ' . $self->auth->server_token,
    );

    return WebService::HMRC::Response->new(http => $result);
}


=head2 hello_user()

Retrieve a "Hello User" message. This is a user-restricted endpoint.

Returns a WebService::HMRC::Response object.

=cut

sub hello_user {

    my $self = shift;

    my $url = $self->endpoint_url('/hello/user');

    my $result = $self->ua->get(
        $url,
        'Authorization' => 'Bearer ' . $self->auth->access_token,
    );

    return WebService::HMRC::Response->new(http => $result);
}


# PRIVATE METHODS

# _require_server_token()
# Croaks if server_token is not available.
# Returns true otherwise.
sub _require_server_token {
    my $self = shift;

    $self->has_auth
        or croak 'authentication object has not been specified';

    $self->auth->has_server_token
        or croak 'authentication object does not contain a server token';

    return 1;
}



=head1 AUTHOR

Nick Prater, <nick@npbroadcast.com>

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
