package Plagger::Plugin::Publish::Instantpaper;
use strict;
use base qw( Plagger::Plugin );
use LWP::UserAgent;
use URI::QueryParam;

my $INSTANT_PAPER_API_ENDPOINT = "https://www.instapaper.com/api/add";

sub register {
    my ( $self, $context ) = @_;
    $context->register_hook(
        $self,
        'publish.entry' => \&publish_entry,
        'plugin.init'   => \&initialize,
    );
}

sub initialize {
    my ( $self, $context ) = @_;
    my %opt = (
        username => $self->conf->{username},
        password => $self->conf->{password},
    );
    $self->{instantpaper_config} = \%opt;
}

sub publish_entry {
    my ( $self, $context, $args ) = @_;
    my $ua           = LWP::UserAgent->new;
    my $endpoint_uri = URI->new($INSTANT_PAPER_API_ENDPOINT);
    $endpoint_uri->query_form_hash(
        username => $self->{instantpaper_config}->{username},
        password => $self->{instantpaper_config}->{password},
        url      => $args->{entry}->link,
    );
    my $res = $ua->get($endpoint_uri);
    unless ( $res->is_success ) {
        $context->log( warn => $res->status_line );
    }

    my $sleeping_time = $self->conf->{interval} || 3;
    $context->log( info => "Post entry success. sleep $sleeping_time." );
    sleep($sleeping_time);
}

1;
__END__

=encoding utf-8

=head1 NAME

Plagger::Plugin::Publish::Instantpaper -

=head1 SYNOPSIS

  module: Publish::Instantpaper
  config:
    username: your-username
    password: your-password
    interval: 2

=head1 DESCRIPTION

Plagger::Plugin::Publish::Instantpaper is


=head1 SOURCE AVAILABILITY

This source is in Github:

  http://github.com/dann/

=head1 CONTRIBUTORS

Many thanks to:


=head1 AUTHOR

dann E<lt>techmemo@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
