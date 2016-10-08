package Catmandu::Importer::EAD2;

use Catmandu::Sane;
use Catmandu::Util qw(:is);
use XML::LibXML::Reader;
use Catmandu::EAD2;
use feature 'state';

our $VERSION = '0.01';

use Moo;
use namespace::clean;

with 'Catmandu::Importer';

has 'ead2'      => (is => 'lazy');

sub _build_ead2 {
    return Catmandu::EAD2->new;
}

sub generator {
    my ($self) = @_;
    my $fh = $self->fh;
    my $xml = join "", <$fh>;

    sub {
        if ($xml) {
            my $res = $self->ead2->parse($xml);
            $xml = undef;
            return $res;
        }
        else {
            return undef;
        }
    };
}

1;
