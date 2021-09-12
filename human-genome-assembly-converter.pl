#!/usr/bin/perl
use strict;
use warnings;

use Bio::EnsEMBL::Registry;
use Getopt::Long;
use lib 'lib';
use Coordinate;
use JSON::PP;

use constant DB_HOST 		=> 'ensembldb.ensembl.org';
use constant DB_USER 		=> 'anonymous';
use constant REGISTRY		=> 'Bio::EnsEMBL::Registry';

sub main {
  GetOptions(
	'source|s=s' 	=> \( my $source = 'GRCh37' ),
	'target|t=s' 	=> \( my $target = 'GRCh38' ),
	'file|f=s'	    => \( my $input_file = undef ),
    'output|o=s'    => \( my $output_file = undef ),
    'format=s'    	=> \( my $format = 'JSON' )
  );

  # Sanity checks
  if ((($#ARGV + 1) != 3) && !$input_file) {
  	die "Insufficient argument provided\nUsage: ./human-genome-assembly-converter [-s, -t, -f] CHROM_NAME CHROM_START CHROM_END\n";
  } 
  if (($format ne "BED") and ($format ne "JSON")) {
    die "Format should be either BED or JSON, provided $format\n"
  }

  my $registry = ensembl_registry();

  # Create a list of coordinates to convert
  my @coordinates;
  if ($input_file) {
    push @coordinates, get_coordinates_from_file($input_file);
  } else {
    push @coordinates, new Coordinate($ARGV[0], int($ARGV[1]), int($ARGV[2]));
  }
  
  # Create a corresponding list of coordinate mappings in the target assembly
  my @mappings;
  foreach my $coordinate (@coordinates) {
	my @coordiate_mappings =  get_coordinate_mappings($registry, $coordinate, $source, $target);
	push @mappings, @coordiate_mappings;
  }

  my $file_handler;
  if ($output_file) {
    open(FH, '>', $output_file) or die $!;
    $file_handler = \*FH;
  } else {
    $file_handler = \*STDOUT;
  }

  show_results($file_handler, $format, @mappings);

  if ($output_file) {
    close(FH);
  }
}

sub ensembl_registry {
  my $registry = REGISTRY;
  $registry->load_registry_from_db(
	-host	=> DB_HOST,
	-user	=> DB_USER
  );
  return $registry;
}

# Returns a list of `Coordinate` objects based on the input BED file
sub get_coordinates_from_file {
  my ($file) = @_;
 
  my @coordinate_list;
  open(INFILE, '<', $file) or die $!;
  while (<INFILE>) {
    my $line_str = $_;
    $line_str =~ s/^\s+|\s+$//g;
    my @line = split(/\s+/, $line_str, 3);
    my $coordinate = new Coordinate($line[0], int($line[1]), int($line[2]));
    push @coordinate_list, $coordinate;
  }
  close(INFILE);
  return @coordinate_list;
}

# Write the result in either JSON format
sub output_json {
  my ($file_handler, @mappings) = @_;
  
  my $json = JSON::PP->new->convert_blessed;
  my $object_json = $json->encode(\@mappings);
  print $file_handler $object_json . "\n";
}

# Write the result in either BED format
sub output_bed {
  my ($file_handler, @mappings) = @_;

  foreach my $mapping (@mappings) {
    my $mapped = $mapping->{mapped};
    print $file_handler $mapped->get_name() . " " . $mapped->get_start() . " " . $mapped->get_end() . "\n";
  }
}

# Write the result in either JSON or BED format
sub show_results {
  my ($file_handler, $format, @mappings) = @_;

  if ($format eq "JSON") {
     output_json($file_handler, @mappings);
  } elsif ($format eq "BED") {
     output_bed($file_handler, @mappings);
  }
}

# Returns a list of mappings [{'original': ..., 'mapped': ...}] for the coordinates
sub get_coordinate_mappings {
  my ($registry, $coordinate, $source, $target) = @_;

  my $slice_adaptor = $registry->get_adaptor('Human', 'Core', 'Slice');
  my $slice = $slice_adaptor->fetch_by_region('chromosome', $coordinate->get_name(), $coordinate->get_start(), $coordinate->get_end(), undef, $source);
  
  my $projection = $slice->project('chromosome', $target);
  my @coordinate_mappings;

  foreach my $segment (@$projection) {
	my $target_slice = $segment->to_Slice();
	  my %mapping = (
	   'original' => new Coordinate(
		  $slice->seq_region_name(),
		  int($slice->start() + $segment->from_start() - 1),
		  int($slice->start() + $segment->from_end() - 1),
		  $slice->strand(),
		  $slice->coord_system->name(),
		  $slice->coord_system->version()
		),
	   'mapped' => new Coordinate(
		  $target_slice->seq_region_name(),
		  $target_slice->start(),
		  $target_slice->end(),
		  $target_slice->strand(),
		  $target_slice->coord_system->name(),
		  $target_slice->coord_system->version()
	  )
	);
	push @coordinate_mappings, \%mapping;   
  }
  return @coordinate_mappings;
}

main();
