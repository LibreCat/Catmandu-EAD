package Catmandu::EAD2;

use Moo;

use XML::Compile;
use XML::Compile::Schema;
use XML::Compile::Util 'pack_type';

use constant EAD   => 'urn:isbn:1-931666-22-9';
use constant XLINK => 'http://www.w3.org/1999/xlink';

our $VERSION = '0.01';

has 'mixed'      => (is => 'ro' , default => sub { 'ATTRIBUTES' });


has '_reader'    => (is => 'ro');
has '_writer'    => (is => 'ro');

has 'prefixes'  => (is => 'ro' , default => sub {
                      [
                        'ead'   => 'urn:isbn:1-931666-22-9',
                        'xlink' => 'http://www.w3.org/1999/xlink',
                      ]
                    });

sub BUILD {
    my ($self) = @_;

    XML::Compile->addSchemaDirs(__FILE__);

    my $schema = XML::Compile::Schema->new();

    XML::Compile->knownNamespace(&EAD => 'ead2.xsd');
    XML::Compile->knownNamespace(&XLINK => 'xlink.xsd');

    $schema->importDefinitions(EAD);
    $schema->importDefinitions(XLINK);

    $schema->addHook(
        action => 'READER' ,
        after => sub {
             my ($xml, $data, $path) = @_;
             delete $data->{_MIXED_ELEMENT_MODE};
             $data;
        }
    );

    $self->{_reader} = $schema->compile(
            READER         => pack_type(&EAD, 'ead'),
            mixed_elements => $self->mixed ,
    );

    $self->{_writer} = $schema->compile(
            WRITER         => pack_type(&EAD, 'ead'),
            prefixes       => $self->prefixes
    );

    $schema = undef;
}

sub parse {
    my ($self,$input) = @_;
    $self->_reader->($input);
}

sub to_xml {
    my ($self,$data) = @_;
    my $doc    = XML::LibXML::Document->new('1.0', 'UTF-8');
    my $xml    = $self->_writer->($doc, $data);
    $doc->setDocumentElement($xml);

    my $str    = $doc->toString(1);
    $str =~ s{\s+xmlns(:ead)?="urn:isbn:1-931666-22-9"}{}g;
    $str =~ s{<(\/)?ead:}{<$1}g;
    $str =~ s{<ead }{<ead xmlns="urn:isbn:1-931666-22-9" };
    $str;
}

1;
