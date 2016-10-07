package Catmandu::Exporter::EAD2;

use Catmandu::Sane;

our $VERSION = '0.01';

use Moo;
use Catmandu::EAD2;

with 'Catmandu::Exporter';

has 'ead2'      => (is => 'lazy');

sub _build_ead2 {
    return Catmandu::EAD2->new;
}

sub add {
    my ($self, $data) = @_;

    my $xml = $self->ead2->to_xml($data);
    $self->fh->print($xml) if $xml;
}

1;

__END__

=pod

=head1 NAME

Catmandu::Exporter::PNX - a Primo normalized XML (PNX) exporter

=head1 SYNOPSIS

    # From the commandline
    $ catmandu convert JSON --fix myfixes to PNX < /tmp/data.json

    # From Perl

    use Catmandu;

    # Print to STDOUT
    my $exporter = Catmandu->exporter('PNX');

    $exporter->add_many($arrayref);
    $exporter->add_many($iterator);
    $exporter->add_many(sub { });

    $exporter->add($hashref);

    printf "exported %d objects\n" , $exporter->count;

    # Get an array ref of all records exported
    my $data = $exporter->as_arrayref;

=head1 DESCRIPTION

This is a L<Catmandu::Exporter> for converting Perl into Primo normalized XML (PNX).

=head1 SEE ALSO

L<Catmandu::Exporter>, L<Catmandu-PNX>

=cut
