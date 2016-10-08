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
